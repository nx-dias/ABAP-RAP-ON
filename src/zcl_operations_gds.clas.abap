CLASS zcl_operations_gds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_operations_gds IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*    " MODIFICANDO UMA ENTIDADE
*    MODIFY ENTITY YGDS_I_Travel_m
*           UPDATE FROM VALUE #( ( %key-travel_id      = '00000178'
*                                  %data-begin_date    = '20250222'
*                                  %control-begin_date = if_abap_behv=>mk-on ) )
*
*           FAILED DATA(lt_fail)
*           REPORTED DATA(lt_report)
*           MAPPED DATA(mapp).


*    MODIFY ENTITY YGDS_I_Travel_m
*           UPDATE FIELDS ( begin_date )
*           WITH VALUE #( ( %key-travel_id      = '00000178'
*                                  %data-begin_date    = '20250222' ) )
*
*           FAILED DATA(lt_fail)
*           REPORTED DATA(lt_report)
*           MAPPED DATA(mapp).

    MODIFY ENTITY YGDS_I_Travel_m
           UPDATE set FIELDS WITH VALUE #( ( %key-travel_id      = '00000178'
                                  %data-begin_date    = '20250222' ) )

           FAILED DATA(lt_fail)
           REPORTED DATA(lt_report)
           MAPPED DATA(mapp).

    IF lt_fail IS INITIAL AND lt_report IS INITIAL.
      COMMIT ENTITIES.

    ELSE.
      out->write( data = lt_fail ).

      out->write( data = lt_report ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
