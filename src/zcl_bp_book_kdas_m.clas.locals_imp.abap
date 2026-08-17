CLASS lhc_ZI_BOOKING_KDAS_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
       keys FOR zi_booking_kdas_m~calculateTotalPrice.

ENDCLASS.

CLASS lhc_zi_booking_kdas_m IMPLEMENTATION.

  METHOD calculateTotalPrice.


    DATA: it_travel TYPE STANDARD TABLE OF zi_travel_kdas_m WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING Travelid = TravelId ).

    MODIFY ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
     ENTITY zi_travel_kdas_m
     EXECUTE recalcTotPrice
     FROM CORRESPONDING #( it_travel ).


  ENDMETHOD.

ENDCLASS.

