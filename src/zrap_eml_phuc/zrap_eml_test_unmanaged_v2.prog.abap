*&---------------------------------------------------------------------*
*& Report zrap_eml_test_unmanaged_v2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrap_eml_test_unmanaged_v2.

DATA: gr_alv          TYPE REF TO cl_salv_table.

PARAMETERS pa_show TYPE xfeld DEFAULT 'X'.
PARAMETERS pa_trav TYPE /dmo/travel_id DEFAULT '00000001'.
PARAMETERS pa_desc TYPE /dmo/description DEFAULT 'Test aus ABAP Report 1'.

START-OF-SELECTION.

  IF pa_show = 'X'.
* Read Entities für die gefundene Travel-ID ausführen
    READ ENTITIES OF /DMO/I_Travel_U
    ENTITY travel
    ALL FIELDS
    WITH VALUE #( ( travelid = pa_trav ) )
    RESULT DATA(gt_my_Sales_Orders).

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = gr_alv
          CHANGING
            t_table      = gt_my_Sales_Orders.
        ##NO_HANDLER.
      CATCH cx_salv_msg .
    ENDTRY.
    CALL METHOD gr_alv->display.

  ELSE.

    " UPDATE der Reisedaten
    MODIFY ENTITY /DMO/I_Travel_U
       UPDATE FIELDS ( memo )
       WITH VALUE #( (
              travelid          = pa_trav
              memo              = pa_desc ) )
    FAILED   DATA(ls_failed)
    REPORTED DATA(ls_reported).

* Daten in der Datenbank veruchen
    IF ls_failed IS INITIAL.
* Starten der Speichersequenz -> FINALIZE,...
      COMMIT ENTITIES.

* Read Entities für die gefundene Travel-ID ausführen
      READ ENTITIES OF /DMO/I_Travel_U
      ENTITY travel
      ALL FIELDS
      WITH VALUE #( ( travelid = pa_trav ) )
      RESULT gt_my_Sales_Orders.

      TRY.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              list_display = if_salv_c_bool_sap=>false
            IMPORTING
              r_salv_table = gr_alv
            CHANGING
              t_table      = gt_my_Sales_Orders.
          ##NO_HANDLER.
        CATCH cx_salv_msg .
      ENDTRY.
      CALL METHOD gr_alv->display.

    ENDIF.

  ENDIF.
