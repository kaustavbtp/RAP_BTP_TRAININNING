CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

    METHODS rba_Booking FOR READ
      IMPORTING keys_rba FOR READ Travel\_Booking FULL result_requested RESULT result LINK association_links.

    METHODS cba_Booking FOR MODIFY
      IMPORTING entities_cba FOR CREATE Travel\_Booking.

    METHODS set_status_booked FOR MODIFY
      IMPORTING keys FOR ACTION Travel~set_status_booked RESULT result.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zkd_jp_trav_01 IN LOCAL MODE
      ENTITY travel
         FIELDS (  travelID status )
         WITH CORRESPONDING #( keys )
       RESULT DATA(lt_travel_result)
       FAILED failed.

    result =
      VALUE #( FOR ls_travel IN lt_travel_result
        ( %key = ls_travel-%key
          %features-%action-set_status_booked = COND #( WHEN ls_travel-status = 'B'
                                                        THEN if_abap_behv=>fc-o-disabled
                                                        ELSE if_abap_behv=>fc-o-enabled )
         ) ).

  ENDMETHOD.

  METHOD create.
    DATA : ls_travel TYPE /dmo/travel,
           lt_msg    TYPE /dmo/t_message.

    LOOP AT entities ASSIGNING  FIELD-SYMBOL(<lfs_travel_entity>).

      ls_travel = CORRESPONDING #( <lfs_travel_entity> MAPPING FROM ENTITY USING CONTROL ).


      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_CREATE'
        EXPORTING
          is_travel   = CORRESPONDING /dmo/s_travel_in( ls_travel )
        IMPORTING
          es_travel   = ls_travel
          et_messages = lt_msg.

      IF lt_msg IS NOT INITIAL.
        mapped-travel = VALUE #( BASE mapped-travel
                              ( %cid = <lfs_travel_entity>-%cid
                                travelid = ls_travel-travel_id
                              ) ).

      ELSE.
        LOOP AT lt_msg INTO DATA(ls_msg).
          APPEND VALUE #( %cid = <lfs_travel_entity>-%cid
              travelid = <lfs_travel_entity>-TravelID )
              TO failed-travel.

          APPEND VALUE #( %msg = new_message( id       = ls_msg-msgid
                                              number   = ls_msg-msgno
                                              v1       = ls_msg-msgv1
                                              v2       = ls_msg-msgv2
                                              v3       = ls_msg-msgv3
                                              v4       = ls_msg-msgv4
                                              severity = if_abap_behv_message=>severity-error )
                          %key-TravelID = <lfs_travel_entity>-TravelID
                          %cid =  <lfs_travel_entity>-%cid
                          %create = 'X'
                          TravelID = <lfs_travel_entity>-TravelID )
                          TO reported-travel.
        ENDLOOP.

      ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    DATA : lt_msg     TYPE /dmo/t_message.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_del_keys>).

      CALL FUNCTION '/DMO/FLIGHT_TRAVEL_DELETE'
        EXPORTING
          iv_travel_id = <lfs_del_keys>-TravelID
        IMPORTING
          et_messages  = lt_msg.
      IF lt_msg IS NOT INITIAL.
        LOOP AT lt_msg INTO DATA(ls_msg) WHERE msgty CA 'EA'.
          APPEND VALUE #( %cid     = <lfs_del_keys>-%cid_ref
                          travelid = <lfs_del_keys>-TravelID
                        ) TO failed-travel.

          APPEND VALUE #( %msg = new_message( id       = ls_msg-msgid
                                              number   = ls_msg-msgno
                                              v1       = ls_msg-msgv1
                                              v2       = ls_msg-msgv2
                                              v3       = ls_msg-msgv3
                                              v4       = ls_msg-msgv4
                                              severity = if_abap_behv_message=>severity-error )
                          %key-TravelID = <lfs_del_keys>-TravelID
                          %cid          =  <lfs_del_keys>-%cid_ref
                          %delete       = 'X'
                          TravelID      = <lfs_del_keys>-TravelID
                        ) TO reported-travel.

        ENDLOOP.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD read.

    SELECT * FROM zkd_jp_trav_01
      FOR ALL ENTRIES IN @keys
      WHERE TravelId = @keys-TravelId
      INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Booking.
  ENDMETHOD.

  METHOD cba_Booking.
  ENDMETHOD.

  METHOD set_status_booked.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZKD_JP_TRAV_01 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZKD_JP_TRAV_01 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_SAVE'.
    CALL FUNCTION '/DMO/FLIGHT_TRAVEL_INITIALIZE'.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
