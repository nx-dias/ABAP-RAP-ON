CLASS lhc_ygds_i_booking_m DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booksuppl FOR NUMBERING
      IMPORTING entities FOR CREATE ygds_i_booking_m\_BookingSupp.
ENDCLASS.

CLASS lhc_ygds_i_booking_m IMPLEMENTATION.


  METHOD earlynumbering_cba_Booksuppl.
    DATA lv_max_suppl_id TYPE /dmo/booking_supplement_id.

    " Supplements que já existem para esses bookings
    READ ENTITIES OF ygds_i_travel_m IN LOCAL MODE
      ENTITY ygds_i_booking_m BY \_BookingSupp
      FROM CORRESPONDING #( entities )
      LINK DATA(lt_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking_group>)
         GROUP BY <booking_group>-%tky.

      CLEAR lv_max_suppl_id.

      " Maior supplement_id já gravado
      LOOP AT lt_supplements INTO DATA(ls_link)
           USING KEY entity
           WHERE source-travel_id  = <booking_group>-travel_id
             AND source-booking_id = <booking_group>-booking_id.
        lv_max_suppl_id = nmax( val1 = lv_max_suppl_id
                                val2 = ls_link-target-booking_supplement_id ).
      ENDLOOP.

      " Maior supplement_id entre os que estão sendo criados agora
      LOOP AT entities INTO DATA(ls_entity)
           USING KEY entity
           WHERE travel_id  = <booking_group>-travel_id
             AND booking_id = <booking_group>-booking_id.
        LOOP AT ls_entity-%target INTO DATA(ls_target).
          lv_max_suppl_id = nmax( val1 = lv_max_suppl_id
                                  val2 = ls_target-booking_supplement_id ).
        ENDLOOP.
      ENDLOOP.

      " Atribui os novos números
      LOOP AT entities ASSIGNING FIELD-SYMBOL(<booking>)
           USING KEY entity
           WHERE travel_id  = <booking_group>-travel_id
             AND booking_id = <booking_group>-booking_id.

        LOOP AT <booking>-%target ASSIGNING FIELD-SYMBOL(<suppl_new>).
          APPEND CORRESPONDING #( <suppl_new> ) TO mapped-ygds_i_bookingsupp_m
                 ASSIGNING FIELD-SYMBOL(<mapped_suppl>).

          IF <mapped_suppl>-booking_supplement_id IS INITIAL.
            lv_max_suppl_id += 1.
            <mapped_suppl>-booking_supplement_id = lv_max_suppl_id.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
