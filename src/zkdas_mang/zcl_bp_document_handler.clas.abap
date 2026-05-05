CLASS zcl_bp_document_handler DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS:
      get_instance
        RETURNING VALUE(ro_handler) TYPE REF TO zcl_bp_document_handler,

      refresh.

    METHODS get_next_doc_number
      RETURNING VALUE(rv_number) TYPE char13.


    METHODS set_header_for_create
      IMPORTING
        is_travel TYPE ztravel_kdas_m.


  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
        mo_handler TYPE REF TO zcl_bp_document_handler.

    DATA:
        mt_header  TYPE SORTED TABLE OF ztravel_kdas_m WITH UNIQUE KEY travel_id.


ENDCLASS.

CLASS zcl_bp_document_handler IMPLEMENTATION.

  METHOD get_instance.
    IF mo_handler IS NOT BOUND.
      mo_handler = NEW #( ).
    ENDIF.

    ro_handler = mo_handler.
  ENDMETHOD.

  METHOD refresh.
    CLEAR mo_handler.
  ENDMETHOD.

  METHOD get_next_doc_number.

    IF mt_header IS INITIAL.
      "-- no unsaved documents
      SELECT MAX( travel_id ) FROM ztravel_kdas_m INTO @rv_number.
    ELSE.
      "-- unsaved new documents
      rv_number = mt_header[ lines( mt_header ) ]-travel_id.
    ENDIF.

    rv_number += 1.

  ENDMETHOD.

  METHOD set_header_for_create.
    INSERT is_travel INTO TABLE mt_header.
  ENDMETHOD.

ENDCLASS.
