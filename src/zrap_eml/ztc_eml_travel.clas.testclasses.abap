*"* use this source file for your ABAP unit test classes
CLASS ltcl_eml_travel DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      mo_test_environment TYPE REF TO if_cds_test_environment,
      ms_travel           TYPE /DMO/I_Travel_U,
      mt_read_travel      TYPE STANDARD TABLE OF /dmo/travel.
    CLASS-METHODS:
      class_setup,
      class_teardown.
    METHODS:
      teardown,
      read_ok FOR TESTING,
      update_ok FOR TESTING.
ENDCLASS.

CLASS ltcl_eml_travel IMPLEMENTATION.

  METHOD class_setup.
*  Mock Daten aufbauen
    mo_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                          i_for_entities = VALUE #(
                             ( i_for_entity = '/DMO/I_Travel_U'
                             i_select_base_dependencies = abap_true ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
*  vernichtet die Testumgebung und die als Teil der Testklasse erstellten Dubletten.
    mo_test_environment->destroy(  ).
  ENDMETHOD.

  METHOD teardown.
* Löscht die Daten in den Test-Dubletten für eine bestimmte Methode, bevor die nächste Methode ausgeführt wird.
    mo_test_environment->clear_doubles(  ).
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD read_ok.
    mt_read_travel =  VALUE #( (
                              travel_id = '110'
                             ) ).
* Testdaten erzeugen
    mo_test_environment->insert_test_data( i_data = mt_read_travel  ).

    READ ENTITIES OF /DMO/I_Travel_U
    ENTITY travel ALL FIELDS WITH
       VALUE #( (  %key-TravelID = mt_read_travel[ 1 ]-travel_id ) )
      RESULT DATA(lt_read_travel)
      FAILED DATA(ls_failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_equals(
    EXPORTING
      act                  =  lt_read_travel[ 1 ]-travelid
      exp                  =  '110'
      msg                  = 'Fehler beim Lesen der Daten.'
  ).

  ENDMETHOD.

  METHOD update_ok.

    DATA lt_read_travel TYPE TABLE FOR READ RESULT /DMO/I_Travel_U.

    mt_read_travel =  VALUE #( (
                              travel_id = '110'
                             ) ).
* Testdaten erzeugen
    mo_test_environment->insert_test_data( i_data = mt_read_travel  ).

    " UPDATE der Reisedaten
    MODIFY ENTITY /DMO/I_Travel_U
       UPDATE FIELDS ( memo )
       WITH VALUE #( (
              travelid          = '00000110'
              memo              = 'Test ABAP Unit' ) )
    FAILED   DATA(ls_ls_failed)
    REPORTED DATA(ls_reported).

* Verbuchen
    COMMIT ENTITIES.

* Auslesen der Reisedaten
    READ ENTITIES OF /DMO/I_Travel_U
    ENTITY travel ALL FIELDS WITH
       VALUE #( (  %key-TravelID = '00000110' ) )
      RESULT lt_read_travel
      FAILED data(ls_failed)
      REPORTED ls_reported.

    cl_abap_unit_assert=>assert_equals(
    EXPORTING
      act                  =  lt_read_travel[ 1 ]-Memo
      exp                  =  'Test ABAP Unit'
      msg                  = 'Fehler beim Update.'
  ).

  ENDMETHOD.

ENDCLASS.
