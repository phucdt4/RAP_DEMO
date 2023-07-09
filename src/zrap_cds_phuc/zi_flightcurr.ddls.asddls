@AbapCatalog.sqlViewName: 'ZI_FLIGHTCURRV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flug und Währung'
define view ZI_FlightCurr as select from ZI_Flight
{    
  key CarrierId,
  key ConnectionId,
  key FlightDate,
  
  CurrencyCode,    
  
 // _Currency.CurrencyISOCode,
  _Currency[Currency = 'EUR'] as _FlightCurrency        
}




