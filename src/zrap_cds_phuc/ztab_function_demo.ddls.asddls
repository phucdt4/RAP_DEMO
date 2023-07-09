@EndUserText.label: 'CDS Table Function Demo'
define table function ZTAB_FUNCTION_DEMO
  with parameters
    @Environment.systemField: #CLIENT
    P_Client : abap.clnt,
    @Environment.systemField: #SYSTEM_LANGUAGE
    P_Spras  : spras
returns
{
  Client          : abap.clnt;
  ProductionOrder : aufnr;
  Material        : matnr;
  Status          : char200;
}
implemented by method
  zcl_tab_function_demo=>get_order_data;
