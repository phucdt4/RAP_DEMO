CLASS zcl_tab_function_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_order_data FOR TABLE FUNCTION ztab_function_demo.
    Class-METHODS test_normal_method.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_tab_function_demo IMPLEMENTATION.

  METHOD get_order_data
  BY DATABASE FUNCTION FOR HDB
  LANGUAGE SQLSCRIPT
  OPTIONS READ-ONLY
  USING afko jest tj02t.
    RETURN
      SELECT
        :p_client AS client,
        aufnr AS productionorder,
        plnbez AS material,
        string_agg(tj02t.txt04,',') AS status
      FROM afko
      INNER JOIN jest
        ON afko.mandt = jest.mandt AND
           afko.aufnr = substr(jest.objnr,3,12)
      INNER JOIN tj02t ON jest.stat = tj02t.istat
      WHERE
        afko.mandt = :p_client AND
        jest.inact = '' AND
        tj02t.spras = :p_spras
      GROUP BY
        afko.aufnr,
        afko.plnbez;
  ENDMETHOD.

  METHOD test_normal_method.

    data lt_test type  table of vbak.

  ENDMETHOD.

ENDCLASS.
