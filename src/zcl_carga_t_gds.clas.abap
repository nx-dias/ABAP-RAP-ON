CLASS zcl_carga_t_gds DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_carga_t_gds IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM YGDS_TRAVEL_M.
    COMMIT WORK.


    INSERT YGDS_TRAVEL_M FROM ( SELECT * FROM /dmo/travel_m ).
    COMMIT WORK AND WAIT.

    INSERT ygds_booking_m FROM ( SELECT * FROM /dmo/booking_m ).
    COMMIT WORK AND WAIT.

    INSERT ygds_booking_sup FROM ( SELECT * FROM /dmo/booksuppl_m ).
    COMMIT WORK AND WAIT.

  ENDMETHOD.
ENDCLASS.
