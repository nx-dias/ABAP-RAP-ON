CLASS lhc_ygds_i_travel_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ygds_i_travel_m RESULT result.
    METHODS copia FOR MODIFY
      IMPORTING keys FOR ACTION ygds_i_travel_m~copia.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE ygds_i_travel_m.
    METHODS earlynumbering_cba_Booking FOR NUMBERING
      IMPORTING entities FOR CREATE ygds_i_travel_m\_Booking.

ENDCLASS.

CLASS lhc_ygds_i_travel_m IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    TRY.

        cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr       = '01'
                                                      object            = '/DMO/TRV_M'
                                                      quantity          = 1
                                            IMPORTING number            = DATA(lv_last_number)
                                            " TODO: variable is assigned but never used (ABAP cleaner)
                                                      returned_quantity = DATA(lv_quantity) ).

      CATCH cx_nr_object_not_found INTO DATA(lo_notfound). " TODO: variable is assigned but never used (ABAP cleaner)

        LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

          APPEND VALUE #( %cid = <entity>-%cid
                          %key = <entity>-%key ) TO failed-ygds_i_travel_m.

          APPEND VALUE #( %cid = <entity>-%cid
                          %key = <entity>-%key
                          %msg = lo_notfound ) TO reported-ygds_i_travel_m.

        ENDLOOP.

      CATCH cx_number_ranges INTO DATA(lo_number). " TODO: variable is assigned but never used (ABAP cleaner)
        LOOP AT entities ASSIGNING <entity>.

          APPEND VALUE #( %cid = <entity>-%cid
                          %key = <entity>-%key ) TO failed-ygds_i_travel_m.

          APPEND VALUE #( %cid = <entity>-%cid
                          %key = <entity>-%key
                          %msg = lo_number ) TO reported-ygds_i_travel_m.
        ENDLOOP.

    ENDTRY.

    LOOP AT entities ASSIGNING <entity>.
      APPEND VALUE #( %cid      = <entity>-%cid
                      travel_id = lv_last_number ) TO mapped-ygds_i_travel_m.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Booking.
    DATA lv_max_booking_id TYPE /dmo/booking_id.

    " Bookings que já existem para esses travels
    READ ENTITIES OF ygds_i_travel_m IN LOCAL MODE
         ENTITY ygds_i_travel_m BY \_Booking
         FROM CORRESPONDING #( entities )
         LINK DATA(lt_bookings).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel_group>)
         GROUP BY <travel_group>-travel_id.

      CLEAR lv_max_booking_id.

      " Maior booking_id já gravado
      LOOP AT lt_bookings INTO DATA(ls_link)
           USING KEY entity
           WHERE source-travel_id = <travel_group>-travel_id.
        lv_max_booking_id = nmax( val1 = lv_max_booking_id
                                  val2 = ls_link-target-booking_id ).
      ENDLOOP.

      " Maior booking_id entre os que estão sendo criados agora
      LOOP AT entities INTO DATA(ls_entity)
           USING KEY entity
           WHERE travel_id = <travel_group>-travel_id.
        LOOP AT ls_entity-%target INTO DATA(ls_target).
          lv_max_booking_id = nmax( val1 = lv_max_booking_id
                                    val2 = ls_target-booking_id ).
        ENDLOOP.
      ENDLOOP.

      " Atribui os novos números
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<travel>)
           USING KEY entity
           WHERE travel_id = <travel_group>-travel_id.

        LOOP AT <travel>-%target ASSIGNING FIELD-SYMBOL(<booking_new>).
          APPEND CORRESPONDING #( <booking_new> ) TO mapped-ygds_i_booking_m
                 ASSIGNING FIELD-SYMBOL(<mapped_booking>).

          IF <mapped_booking>-booking_id IS INITIAL.
            lv_max_booking_id += 10.
            <mapped_booking>-booking_id = lv_max_booking_id.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD copia.
    DATA lt_travel       TYPE TABLE FOR CREATE YGDS_I_Travel_m.
    DATA lt_booking      TYPE TABLE FOR CREATE YGDS_I_Travel_m\_Booking.
    DATA lt_booking_supp TYPE TABLE FOR CREATE YGDS_I_Booking_m\_BookingSupp.

    READ ENTITIES OF YGDS_I_Travel_m IN LOCAL MODE
         ENTITY YGDS_I_Travel_m
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel_r)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_travel_f).

    READ ENTITIES OF YGDS_I_Travel_m IN LOCAL MODE
         ENTITY YGDS_I_Travel_m BY \_Booking
         ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
         RESULT DATA(lt_booking_r)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_booking_f).

    READ ENTITIES OF YGDS_I_Travel_m IN LOCAL MODE
         ENTITY YGDS_I_Booking_m BY \_BookingSupp
         ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
         RESULT DATA(lt_booking_s_r)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(lt_booking_s_f).

    LOOP AT lt_travel_r ASSIGNING FIELD-SYMBOL(<travel_r>).

      APPEND VALUE #( %cid  = keys[ travel_id = <travel_r>-travel_id ]-%cid
                      %data = CORRESPONDING #( <travel_r> EXCEPT travel_id ) )
             TO lt_travel ASSIGNING FIELD-SYMBOL(<travel_c>).

      APPEND VALUE #( %cid_ref = <travel_c>-%cid )
             TO lt_booking ASSIGNING FIELD-SYMBOL(<booking_c>).

      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<booking_r>)
        USING KEY entity
           WHERE travel_id = <travel_r>-travel_id.

        APPEND VALUE #( %cid  = <travel_r>-travel_id && <booking_r>-booking_id
                        %data = CORRESPONDING #( <booking_r> EXCEPT travel_id ) )
               TO <booking_c>-%target ASSIGNING FIELD-SYMBOL(<booking_cc>).

        APPEND VALUE #( %cid_ref = <booking_cc>-%cid )
               TO lt_booking_supp ASSIGNING FIELD-SYMBOL(<booking_sup_c>).

        LOOP AT lt_booking_s_r ASSIGNING FIELD-SYMBOL(<booking_s_r>)
          USING KEY entity
             WHERE     travel_id  = <travel_r>-travel_id
                   AND booking_id = <booking_r>-booking_id.

          APPEND VALUE #( %cid  = <travel_r>-travel_id && <booking_r>-booking_id
                                  && <booking_s_r>-booking_supplement_id
                          %data = CORRESPONDING #( <booking_s_r> EXCEPT travel_id booking_id ) )
                 TO <booking_sup_c>-%target.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.

    " update data ddic
    MODIFY ENTITIES OF YGDS_I_Travel_m IN LOCAL MODE
           ENTITY YGDS_I_Travel_m
           CREATE FIELDS ( agency_id customer_id begin_date end_date booking_fee total_price currency_code description )
           WITH lt_travel

           ENTITY YGDS_I_Travel_m
           CREATE BY \_Booking FIELDS ( booking_id booking_date customer_id carrier_id connection_id flight_date flight_price currency_code booking_status )
           WITH lt_booking

           ENTITY YGDS_I_booking_m
           CREATE BY \_BookingSupp FIELDS ( booking_supplement_id supplement_id price currency_code )
           WITH lt_booking_supp
           MAPPED DATA(it_mapp).

    mapped-ygds_i_travel_m = it_mapp-ygds_i_travel_m.
  ENDMETHOD.

ENDCLASS.
