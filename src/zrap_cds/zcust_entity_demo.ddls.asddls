@EndUserText.label: 'CDS Custom Entity Demo'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CUST_ENTITY_DEMO'
define custom entity zcust_entity_demo
// with parameters parameter_name : parameter_type
{
// Element list, Element annotations
      @UI.selectionField: [{position: 10}]
      @UI.lineItem: [{position: 10}]
  key UserName  : xubname;
      @UI.lineItem: [{position: 20}]  
      FirstName : ad_namefir;
      @UI.lineItem: [{position: 30}]       
      LastName  : ad_namelas;
      FullName  : ad_namtext;      
}




