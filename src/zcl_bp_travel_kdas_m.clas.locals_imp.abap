CLASS lhc_ZI_TRAVEL_KDAS_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zi_travel_kdas_m RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zi_travel_kdas_m RESULT result.

    METHODS acceptTravel FOR MODIFY
       keys FOR ACTION zi_travel_kdas_m~acceptTravel.

    METHODS copyTravel FOR MODIFY
       keys FOR ACTION zi_travel_kdas_m~copyTravel.

    METHODS recalcTotPrice FOR MODIFY
       keys FOR ACTION zi_travel_kdas_m~recalcTotPrice.

    METHODS rejectTravel FOR MODIFY
       keys FOR ACTION zi_travel_kdas_m~rejectTravel.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
       keys FOR zi_travel_kdas_m~calculateTotalPrice.

    METHODS validateCustomer FOR VALIDATE ON SAVE
       keys FOR zi_travel_kdas_m~validateCustomer.

ENDCLASS.


CLASS lhc_ZI_TRAVEL_KDAS_M IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD copyTravel.
  ENDMETHOD.

*  METHOD earlynumbering_create.
*
** Another logic for early numbering can be to get the latest number from the database
** and then add 1 to it for each record. Below is a sample code snippet for this logic.
*
**    DATA(lo_doc_handler) = zcl_bp_document_handler=>get_instance( ).
**
**    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).
**      INSERT VALUE #( %cid     = <lfs_entity>-%cid
**                     travelid  = lo_doc_handler->get_next_doc_number( ) ) INTO TABLE mapped-zi_travel_kdas_m.
**    ENDLOOP.
*
*
*  ENDMETHOD.

  METHOD acceptTravel.
    MODIFY ENTITIES OF zi_travel_kdas_m
           ENTITY zi_travel_kdas_m
           UPDATE FIELDS ( OverallStatus )
           WITH VALUE #( FOR ls_keys IN keys
                         ( %tky          = ls_keys-%tky
                           OverallStatus = 'A' ) ).

    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
         ENTITY zi_travel_kdas_m
         ALL FIELDS WITH VALUE #( FOR ls_keys IN keys
                                  ( %tky = ls_keys-%tky ) )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_result).

*  data(result) = VALUE #( FOR ls_result in lt_result ( %tky = ls_result-%tky
*                                                  %param = ls_result   )).
  ENDMETHOD.

  METHOD rejectTravel.
    MODIFY ENTITIES OF zi_travel_kdas_m
           ENTITY zi_travel_kdas_m
           UPDATE FIELDS ( OverallStatus )
           WITH VALUE #( FOR ls_keys IN keys
                         ( %tky          = ls_keys-%tky
                           OverallStatus = 'X' ) ).

    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
         ENTITY zi_travel_kdas_m
         ALL FIELDS WITH VALUE #( FOR ls_keys IN keys
                                  ( %tky = ls_keys-%tky ) )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_result).

*  data(result) = VALUE #( FOR ls_result in lt_result ( %tky = ls_result-%tky
*                                                  %param = ls_result   )).
  ENDMETHOD.

  METHOD validateCustomer.
    DATA lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    READ ENTITY IN LOCAL MODE zi_travel_kdas_m
         FIELDS ( CustomerId )
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_travel).

    lt_cust = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).

    DELETE lt_cust WHERE customer_id IS INITIAL.

    SELECT FROM /dmo/customer
      FIELDS customer_id
      FOR ALL ENTRIES IN @lt_cust
      WHERE customer_id = @lt_cust-customer_id
      INTO TABLE @FINAL(lt_cust_db).

    IF sy-subrc IS INITIAL.

    ENDIF.

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-CustomerId IS NOT INITIAL AND line_exists( lt_cust_db[ customer_id = <ls_travel>-CustomerId ] ).
        CONTINUE.
      ENDIF.

      APPEND VALUE #( %tky = <ls_travel>-%tky  )
             TO failed-zi_travel_kdas_m.

      APPEND VALUE #( %tky                = <ls_travel>-%tky
                      %msg                = NEW /dmo/cm_flight_messages(
                                                    textid      = /dmo/cm_flight_messages=>customer_unkown
                                                    customer_id = <ls_travel>-CustomerId
                                                    severity    = if_abap_behv_message=>severity-error )

                      %element-CustomerId = if_abap_behv=>mk-on )
             TO reported-zi_travel_kdas_m.

    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
           ENTITY zi_travel_kdas_m
           EXECUTE recalcTotPrice
           FROM CORRESPONDING #( keys ).
  ENDMETHOD.

  METHOD recalcTotPrice.
    TYPES : BEGIN OF ty_total,
              price TYPE /dmo/total_price,
              curr  TYPE /dmo/currency_code,
            END OF ty_total.

    DATA lt_total      TYPE TABLE OF ty_total.

    DATA lv_conv_price TYPE ty_total-price.

    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
         ENTITY zi_travel_kdas_m
         FIELDS ( BookingFee CurrencyCode )
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_travel).

    DELETE lt_travel WHERE CurrencyCode IS INITIAL.

    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
         ENTITY zi_travel_kdas_m BY \_Booking
         FIELDS ( FlightPrice CurrencyCode )
         WITH CORRESPONDING #( lt_travel )
         RESULT FINAL(lt_ba_booking).

    READ ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
         ENTITY zi_booking_kdas_m BY \_Bookingsuppl
         FIELDS ( Price CurrencyCode )
         WITH CORRESPONDING #( lt_ba_booking )
         RESULT FINAL(lt_ba_booksuppl).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      lt_total = VALUE #( ( price = <ls_travel>-BookingFee curr = <ls_travel>-CurrencyCode ) ).

      LOOP AT lt_ba_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
           USING KEY entity
           WHERE     TravelID      = <ls_travel>-TravelId
                 AND CurrencyCode IS NOT INITIAL.

        APPEND VALUE #( price = <ls_booking>-FlightPrice
                        curr  = <ls_booking>-CurrencyCode )
               TO lt_total.

        LOOP AT lt_ba_booksuppl ASSIGNING FIELD-SYMBOL(<ls_booksuppl>)
             USING KEY entity
             WHERE     TravelID      = <ls_booking>-TravelId
                   AND BookingID     = <ls_booking>-BookingId
                   AND CurrencyCode IS NOT INITIAL.

          APPEND VALUE #( price = <ls_booksuppl>-Price
                          curr  = <ls_booksuppl>-CurrencyCode )
                 TO lt_total.

        ENDLOOP.
      ENDLOOP.

      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).

        IF <ls_total>-curr = <ls_travel>-CurrencyCode.
          lv_conv_price = <ls_total>-price.
        ELSE.

          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING iv_amount               = <ls_total>-price
                      iv_currency_code_source = <ls_total>-curr
                      iv_currency_code_target = <ls_travel>-CurrencyCode
                      iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
            IMPORTING ev_amount               = lv_conv_price ).

        ENDIF.

        <ls_travel>-TotalPrice += lv_conv_price.

      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF zi_travel_kdas_m IN LOCAL MODE
           ENTITY zi_travel_kdas_m
           UPDATE FIELDS ( TotalPrice )
           WITH CORRESPONDING #( lt_travel ).
  ENDMETHOD.
ENDCLASS.
