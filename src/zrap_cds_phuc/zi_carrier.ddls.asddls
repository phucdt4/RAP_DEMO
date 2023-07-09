@AbapCatalog.sqlViewName: 'ZI_CARRIERV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluggesellschaft'
define view ZI_Carrier as select from /DMO/I_Carrier 
 association [0..*] to /DMO/I_Connection as _Connection
 on $projection.AirlineID = _Connection.AirlineID
{
  key AirlineID,
  _Connection.DepartureAirport
}

//where _Connection.DepartureAirport = 'FRA'
