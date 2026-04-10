CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_travel_kdas_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_travel_kdas_m RESULT result.

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
**    DATA: lv_code TYPE char1.
**
**
**    CONSTANTS : lv_latest_num TYPE numc5 VALUE '01000',
**                lv_qty        TYPE numc5 VALUE '00001'.
**
**
**    DATA(lt_entities) = entities.
**
**    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
**
***    TRY.
***        cl_numberrange_runtime=>number_get(
***          EXPORTING
***            nr_range_nr = '01'
***            object      = '/DMO/TRV_M'
***            quantity    = CONV #( lines( lt_entities ) )
***          IMPORTING
***            number      = DATA(lv_latest_num)
***            returncode    = DATA(lv_code)
***            returned_quantity = DATA(lv_qty)
***
***        ).
**
***      CATCH cx_nr_object_not_found.
***      CATCH cx_number_ranges INTO DATA(lo_error).
**
**    DATA : lo_error TYPE REF TO cx_number_ranges.
**    LOOP AT lt_entities INTO DATA(ls_entities).
**
**      DATA(lv_uuid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16(  ).
**
**      APPEND VALUE #( %cid = ls_entities-%cid
**                      %key = ls_entities-%key
**                      travelid = lv_uuid ) TO failed-zi_travel_kdas_m.
**
**      APPEND VALUE #( %cid = ls_entities-%cid
**                      %key = ls_entities-%key
**                      travelid = lv_uuid
**                      %msg = lo_error ) TO reported-zi_travel_kdas_m.
**
**      APPEND VALUE #( %cid = ls_entities-%cid
**                       TravelId = lv_uuid
**                        ) TO mapped-zi_travel_kdas_m.
**
**
**    ENDLOOP.
**    EXIT.
***    ENDTRY.
**
***    ASSERT lv_qty = lines( lt_entities ).
***
***    DATA: lt_travel_kdas_m TYPE TABLE FOR MAPPED EARLY zi_travel_kdas_m,
***          ls_travel_kdas_m LIKE LINE OF lt_travel_kdas_m.
***
***    DATA(lv_current_num) = lv_latest_num - lv_qty.
***
***    LOOP AT lt_entities INTO ls_entities.
***
***      lv_current_num = lv_current_num + 1.
****
****      ls_travel_kdas_m = VALUE #( %cid = ls_entities-%cid
****                                 TravelId = lv_current_num ).
****
****
****      APPEND ls_travel_kdas_m TO mapped-zi_travel_kdas_m.
***
***      APPEND VALUE #( %cid = ls_entities-%cid
***                     TravelId = lv_current_num
***                     ) TO mapped-zi_travel_kdas_m.
***
***
***    ENDLOOP.

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

ENDCLASS.
