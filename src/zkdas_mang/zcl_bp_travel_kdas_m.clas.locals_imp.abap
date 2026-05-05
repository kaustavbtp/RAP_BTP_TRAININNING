CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_kdas_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_kdas_m RESULT result.

    METHODS accepttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_kdas_m~accepttravel RESULT result.

    METHODS copytravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_kdas_m~copytravel.

    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_kdas_m~recalctotprice.

    METHODS rejecttravel FOR MODIFY
      IMPORTING keys FOR ACTION zi_travel_kdas_m~rejecttravel RESULT result.

*    METHODS earlynumbering_create
*      FOR NUMBERING
*      IMPORTING entities FOR CREATE zi_travel_kdas_m.


ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.
*  METHOD earlynumbering_create.

* Another logic for early numbering can be to get the latest number from the database
* and then add 1 to it for each record. Below is a sample code snippet for this logic.

**    DATA(lo_doc_handler) = zcl_bp_document_handler=>get_instance( ).
**
**    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
**      INSERT VALUE #( %cid     = <lfs_entity>-%cid
**                     travelid  = lo_doc_handler->get_next_doc_number( ) ) INTO TABLE mapped-zi_travel_kdas_m.
**    ENDLOOP.


***    CONSTANTS : lv_latest_num TYPE numc5 VALUE '01000',
***                lv_qty        TYPE numc5 VALUE '00001'.
***
***
*    DATA(lt_entities) = entities.
*
*    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
*
*    TRY.
*        cl_numberrange_runtime=>number_get(
*          EXPORTING
*            nr_range_nr = '01'
*            object      = '/DMO/TRV_M'
*            quantity    = CONV #( lines( lt_entities ) )
*          IMPORTING
*            number      = DATA(lv_latest_num)
*            returncode    = DATA(lv_code)
*            returned_quantity = DATA(lv_qty)
*
*        ).
*
*      CATCH cx_nr_object_not_found.
*      CATCH cx_number_ranges INTO DATA(lo_error).
**
**    DATA : lo_error TYPE REF TO cx_number_ranges.
**    LOOP AT lt_entities INTO DATA(ls_entities).
**
***     DATA(lv_uuid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16(  ).
**
*      APPEND VALUE #( %cid = ls_entities-%cid
*                      %key = ls_entities-%key
*                      travelid = lv_uuid ) TO failed-zi_travel_kdas_m.
*
*      APPEND VALUE #( %cid = ls_entities-%cid
*                      %key = ls_entities-%key
*                      travelid = lv_uuid
*                      %msg = lo_error ) TO reported-zi_travel_kdas_m.
*
*      APPEND VALUE #( %cid = ls_entities-%cid
*                       TravelId = lv_uuid
*                        ) TO mapped-zi_travel_kdas_m.
*
*
*    ENDLOOP.
*    EXIT.
*    ENDTRY.
**
*    ASSERT data(lv_qty) = lines( lt_entities ).
**
**    DATA: lt_travel_kdas_m TYPE TABLE FOR MAPPED EARLY zi_travel_kdas_m,
**          ls_travel_kdas_m LIKE LINE OF lt_travel_kdas_m.
**
*    DATA(lv_current_num) = lv_latest_num - lv_qty.
*
*    LOOP AT lt_entities INTO data(ls_entities).
*
*      lv_current_num = lv_current_num + 1.
**
**      ls_travel_kdas_m = VALUE #( %cid = ls_entities-%cid
**                                 TravelId = lv_current_num ).
**
**
**      APPEND ls_travel_kdas_m TO mapped-zi_travel_kdas_m.
*
*      APPEND VALUE #( %cid = ls_entities-%cid
*                     TravelId = lv_current_num
*                     ) TO mapped-zi_travel_kdas_m.
*
*
*    ENDLOOP.

** new code early numbering


*    LOOP AT entities INTO DATA(ls_entity).
*
*      TRY.
*          mapped-zi_travel_kdas_m = VALUE #(  ( %cid = ls_entity-%cid
*                                                travelid = cl_uuid_factory=>create_system_uuid(  )->create_uuid_x16(  ) ) ).
*        CATCH cx_uuid_error.
*          "handle exception
*      ENDTRY.
*
*    ENDLOOP.



*  ENDMETHOD.

  METHOD acceptTravel.
  ENDMETHOD.

  METHOD copyTravel.


    DATA: it_travel       TYPE TABLE FOR CREATE zi_travel_kdas_m,
          it_booking_cba  TYPE TABLE FOR CREATE zi_travel_kdas_m\_Booking,
          it_booksupp_cba TYPE TABLE FOR CREATE zi_booking_kdas_m\_Bookingsuppl.

    READ TABLE keys ASSIGNING FIELD-SYMBOL(<lfs_without_cd>) WITH KEY %cid = ' '.

    ASSERT <lfs_without_cd> IS NOT ASSIGNED.

    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
    ENTITY zi_travel_kdas_m
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_r)
    FAILED DATA(lt_failed).


    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
    ENTITY zi_travel_kdas_m BY \_Booking
    ALL FIELDS WITH CORRESPONDING #( lt_travel_r )
    RESULT DATA(lt_booking_r).


    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
    ENTITY zi_booking_kdas_m BY \_Bookingsuppl
    ALL FIELDS WITH CORRESPONDING #( lt_booking_r )
    RESULT DATA(lt_booksupp_r).


    LOOP AT lt_travel_r  ASSIGNING FIELD-SYMBOL(<lfs_travel_r>).

*      APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<lfs_travel>).
*      <lfs_travel>-%cid = keys[ KEY entity travelid = <lfs_travel_r>-travelid ]-%cid.
*      <lfs_travel>-%data = CORRESPONDING #( <lfs_travel_r> EXCEPT travelid ).


      APPEND VALUE #( %cid = keys[ KEY entity travelid = <lfs_travel_r>-travelid ]-%cid
                     %data = CORRESPONDING #( <lfs_travel_r> EXCEPT travelid ) )
                      TO it_travel ASSIGNING FIELD-SYMBOL(<lfd_travel>).


      APPEND VALUE #( %cid_ref = <lfd_travel>-%cid )
          TO it_booking_cba ASSIGNING FIELD-SYMBOL(<lfs_booking_cba>).


      LOOP AT lt_booking_r ASSIGNING FIELD-SYMBOL(<lfs_booking_r>)
                                 USING KEY entity
                                WHERE travelid = <lfs_travel_r>-travelid.

        APPEND VALUE #( %cid = <lfd_travel>-%cid && <lfs_booking_r>-BookingId
                       %data = CORRESPONDING #( <lfs_booking_r> EXCEPT travelid ) )
                       TO <lfs_booking_cba>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

        <ls_booking_n>-BookingStatus = 'N'.


        APPEND VALUE #( %cid_ref = <ls_booking_n>-%cid )
            TO it_booksupp_cba ASSIGNING FIELD-SYMBOL(<ls_booksupp>).

        LOOP AT lt_booksupp_r ASSIGNING FIELD-SYMBOL(<lfs_booksupp_r>)      USING KEY entity
                                                                             WHERE TravelId = <lfs_travel_r>-travelid
                                                                            AND  BookingId = <lfs_booking_r>-BookingId.

          APPEND VALUE #( %cid = <lfd_travel>-%cid && <lfs_booking_r>-BookingId && <lfs_booksupp_r>-BookingSupplementId
                         %data = CORRESPONDING #( <lfs_booksupp_r> EXCEPT travelid bookingId ) )
                         TO <ls_booksupp>-%target.



        ENDLOOP.
      ENDLOOP.
    ENDLOOP.


    MODIFY ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
    ENTITY zi_travel_kdas_m
    CREATE FIELDS ( AgencyId customerid beginDate endDate bookingfee totalprice currencycode OverallStatus description )
    WITH it_travel
    ENTITY zi_travel_kdas_m
    CREATE BY \_Booking
    FIELDS  ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
    WITH it_booking_cba
    ENTITY zi_booking_kdas_m
    CREATE BY \_Bookingsuppl
    FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
       WITH it_booksupp_cba
       MAPPED DATA(lt_mapped).

    mapped-zi_travel_kdas_m = lt_mapped-zi_travel_kdas_m.



  ENDMETHOD.

  METHOD recalcTotPrice.
  ENDMETHOD.

  METHOD rejectTravel.
  ENDMETHOD.

ENDCLASS.
