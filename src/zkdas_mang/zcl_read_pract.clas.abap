CLASS zcl_read_pract DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_READ_PRACT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " short form read entity with control parameters
*    READ ENTITY zi_travel_kdas_m
*        FROM VALUE #( ( %key-TravelId   = '4276024'
*         %control = VALUE #( AgencyId   = if_abap_behv=>mk-on
*                             customerid = if_abap_behv=>mk-on
*                             begindate  = if_abap_behv=>mk-on )
*        ) )
*        RESULT DATA(lt_result_short)
*        FAILED DATA(lt_failed_short).
*
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Read failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.




*    READ ENTITY zi_travel_kdas_m
**      FIELDS ( AgencyId CreatedAt customerid begindate enddate )
*        ALL FIELDS
*         WITH VALUE #( ( %key-TravelId   = '4276024' ) ( %key-TravelId   = '112233') )
*         RESULT DATA(lt_result_short)
*         FAILED DATA(lt_failed_short).
*
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Read failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.



    "  entity read with association
*    READ ENTITY zi_travel_kdas_m
*       BY \_Booking   " by association to read the travel with the booking data
*       ALL FIELDS
*        WITH VALUE #( ( %key-TravelId   = '4276024' ) ( %key-TravelId   = '112233') )
*        RESULT DATA(lt_result_short)
*        FAILED DATA(lt_failed_short).
*
*
*    IF lt_failed_short IS NOT INITIAL.
*      out->write( 'Read failed' ).
*    ELSE.
*      out->write( lt_result_short ).
*    ENDIF.




    " longer form read entity multiple entity
    READ ENTITIES OF zi_travel_kdas_m
        ENTITY zi_travel_kdas_m
        ALL FIELDS WITH VALUE #( ( %key-TravelId   = '4276024' ) ( %key-TravelId   = '112233') )
                RESULT DATA(lt_result_short)

        ENTITY zi_booking_kdas_m
        ALL FIELDS WITH VALUE #( ( %key-TravelId   = '4276024'  %key-BookingId   = '6969'  ) )
*        %key-BookingId   = '6969'
                RESULT DATA(lt_result_book)
                FAILED DATA(lt_failed_short).

    IF lt_failed_short IS NOT INITIAL.
      out->write( 'Read failed' ).
    ELSE.
      out->write( lt_result_short ).
      out->write( lt_result_book ).
    ENDIF.





*    DATA: it_optab          TYPE abp_behv_retrievals_tab,
*          it_travel         TYPE TABLE FOR READ IMPORT zi_travel_kdas_m,
*          it_travel_result  TYPE TABLE FOR READ RESULT  zi_travel_kdas_m,
*          it_booking        TYPE TABLE FOR READ IMPORT zi_travel_kdas_m\_Booking,
*          it_booking_result TYPE TABLE FOR READ RESULT zi_travel_kdas_m\_Booking.
*
*    it_travel = VALUE #( ( %key-TravelId = '4276024'
*                              %control = VALUE #( AgencyId    = if_abap_behv=>mk-on
*                                                 customerid  = if_abap_behv=>mk-on
*                                                 begindate   = if_abap_behv=>mk-on
*                                              ) ) ).
*
*    it_booking = VALUE #( ( %key-TravelId = '4276024'
*                            %control = VALUE #(
*                               BookingDate = if_abap_behv=>mk-on
*                                BookingStatus = if_abap_behv=>mk-on
*                                BookingId =  if_abap_behv=>mk-on
*                            )    ) ).
*
*
*    it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
*                  entity_name = 'ZI_TRAVEL_KDAS_M'
*                  instances = REF #( it_travel )
*                  results  = REF #( it_travel_result )  )
*                ( op = if_abap_behv=>op-r-read_ba
*                  entity_name = 'ZI_TRAVEL_KDAS_M'
*                  sub_name  = '_BOOKING'
*                  instances = REF #( it_booking )
*                  results  = REF #( it_booking_result )
*                    ) ).
*
*
*    READ ENTITIES OPERATIONS it_optab
*       FAILED DATA(lt_failed_dy).
*
*
*
*    IF lt_failed_dy IS NOT INITIAL.
*      out->write( 'Read failed' ).
*    ELSE.
*      out->write( it_travel_result ).
*      out->write( it_booking_result ).
*
*    ENDIF.


  ENDMETHOD.
ENDCLASS.
