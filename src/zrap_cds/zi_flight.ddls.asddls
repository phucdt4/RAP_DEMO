@AbapCatalog.sqlViewName: 'ZI_FLIGHTV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flug'
define view ZI_Flight
  as select from /dmo/flight
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
{
  key carrier_id     as CarrierId,
  key connection_id  as ConnectionId,
  key flight_date    as FlightDate
   @<Semantics.systemDateTime.createdAt: true,
      price          as Price,

      @Semantics.currencyCode: true
      currency_code  as CurrencyCode,

      @UI.hidden: true
      @Semantics.eMail.address: true
      @Semantics.eMail.type: [#HOME]
      @Semantics.telephone.type: [#HOME, #WORK]
      plane_type_id  as PlaneTypeId,
      seats_max      as SeatsMax,
      seats_occupied as SeatsOccupied,
      _Currency
      //  _Currency[Currency = $parameters.P_TargetCurrency] as _TargetCurrency
}
