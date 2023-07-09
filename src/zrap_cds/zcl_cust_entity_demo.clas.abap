CLASS zcl_cust_entity_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_cust_entity_demo IMPLEMENTATION.
  METHOD if_rap_query_provider~select.

    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).
    DATA lt_sortorder TYPE abap_sortorder_tab.
    DATA ls_sortorder TYPE abap_sortorder.
    DATA lt_userlist TYPE STANDARD TABLE OF bapiusname.
    DATA lt_bapiret TYPE bapiret2_t.
    DATA lt_result TYPE STANDARD TABLE OF zcust_entity_demo.
    DATA ls_result TYPE zcust_entity_demo.

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    TRY.
        IF io_request->is_data_requested( ).
          CALL FUNCTION 'BAPI_USER_GETLIST'
            EXPORTING
*             max_rows      = 0
              with_username = abap_true
*           IMPORTING
*             rows          =
            TABLES
*             selection_range =
*             selection_exp =
              userlist      = lt_userlist
              return        = lt_bapiret.
* Filter püfen
          LOOP AT lt_userlist INTO DATA(ls_userlist).
            DATA(lv_tabix) = sy-tabix.
            LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
              CASE ls_filter_cond-name.
                WHEN 'USERNAME'.
                  IF NOT ls_userlist-username IN ls_filter_cond-range[].
                    DELETE lt_userlist INDEX lv_tabix.
                  ENDIF.
                WHEN 'FIRSTNAME'.
                  IF NOT ls_userlist-firstname IN ls_filter_cond-range[].
                    DELETE lt_userlist INDEX lv_tabix.
                  ENDIF.
                WHEN 'LASTNAME'.
                  IF NOT ls_userlist-lastname IN ls_filter_cond-range[].
                    DELETE lt_userlist INDEX lv_tabix.
                  ENDIF.
                WHEN 'FULLNAME'.
                  IF NOT ls_userlist-fullname IN ls_filter_cond-range[].
                    DELETE lt_userlist INDEX lv_tabix.
                  ENDIF.
              ENDCASE.
            ENDLOOP.
          ENDLOOP.
* Sortierung
          IF lt_sort IS NOT INITIAL.
            LOOP AT lt_sort INTO DATA(ls_sort).
              ls_sortorder-name = ls_sort-element_name.
              ls_sortorder-descending = ls_sort-descending.
              APPEND ls_sortorder TO lt_sortorder.
            ENDLOOP.
          ELSE.
            ls_sortorder-name = 'USERNAME'.
            ls_sortorder-descending = ls_sort-descending.
            APPEND ls_sortorder TO lt_sortorder.
          ENDIF.
          SORT lt_userlist BY (lt_sortorder).

* Paging
*          DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
*          DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
*          DATA(lv_max_rows) = COND #( WHEN lv_page_size = if_rap_query_paging=>page_size_unlimited THEN 0
*                                      ELSE lv_page_size ).

          IF lv_top > 0.
            LOOP AT lt_userlist INTO ls_userlist FROM lv_skip + 1 TO ( lv_skip + lv_top ).
              MOVE-CORRESPONDING ls_userlist TO ls_result.
              APPEND ls_result TO lt_result.
            ENDLOOP.
          ELSE.
            LOOP AT lt_userlist INTO ls_userlist.
              MOVE-CORRESPONDING ls_userlist TO ls_result.
              APPEND ls_result TO lt_result.
            ENDLOOP.
          ENDIF.
          IF io_request->is_total_numb_of_rec_requested( ).
            io_response->set_total_number_of_records( lines( lt_result ) ).
          ENDIF.
          io_response->set_data( lt_result ).
        ELSE.
*         no data is requested
        ENDIF.
      CATCH cx_rap_query_provider INTO DATA(lx_exc).        "error handling
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
