CLASS zcl_flightdetail_calc_exit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
*    Interfaces if_sadl_exit_filter_transform.
*    Interfaces if_sadl_exit_sort_transform.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_flightdetail_calc_exit IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF iv_entity <> 'ZI_FLIGHTDETAIL'.
      RAISE EXCEPTION TYPE zcx_sadl_exit.
    ENDIF.
    LOOP AT it_requested_calc_elements
         ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
      CASE <fs_calc_element>.
        WHEN 'FLIGHTDATEWEEKDAY'.
          APPEND 'FLIGHTDATE' TO et_requested_orig_elements.
        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_sadl_exit.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_original_data
      TYPE STANDARD TABLE OF zi_flightdetail
      WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).
    LOOP AT lt_original_data
         ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      CALL FUNCTION 'GET_WEEKDAY_NAME'
        EXPORTING
          date        = <fs_original_data>-FlightDate
          language    = sy-langu
        IMPORTING
          longtext    = <fs_original_data>-FlightDateWeekday
        EXCEPTIONS
          calendar_id = 1
          date_error  = 2
          not_found   = 3
          wrong_input = 4
          OTHERS      = 5.
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDLOOP.
    ct_calculated_data = CORRESPONDING #( lt_original_data ).
  ENDMETHOD.

ENDCLASS.







