*&---------------------------------------------------------------------*
*& Report zrap_eml_test
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrap_eml_test.

DATA gv_key TYPE sysuuid_x16.

PARAMETERS pa_matnr TYPE matnr DEFAULT 'RAP_001'.
PARAMETERS pa_stat TYPE zbc_status.

START-OF-SELECTION.

* UUId ermitteln
  SELECT SINGLE CertUUID
  FROM ZI_Certificate
  WHERE Material = @pa_matnr
  INTO @gv_key.

* Read Entities für die gefundene UUID ausführen
  READ ENTITIES OF zi_certificate
  ENTITY certificate
  ALL FIELDS
  WITH VALUE #( ( %tky-CertUUID = gv_key ) )
  RESULT DATA(lt_certificates).

* Testweise Statusupdate auf Transaktionspuffer machen
  MODIFY ENTITY zi_certificate
     UPDATE FIELDS ( CertificationStatus ) WITH VALUE #( (
            %tky-CertUUID          = gv_key
            CertificationStatus = pa_stat ) )
  FAILED   DATA(ls_failed)
  REPORTED DATA(ls_reported).

* Daten in der Datenbank veruchen
  IF ls_failed IS INITIAL.
    COMMIT ENTITIES RESPONSE of zi_certificate
        FAILED data(failed)
        REPORTED data(reported).
  ENDIF.
