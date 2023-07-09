@AbapCatalog.sqlViewName: 'ZI_FLIGHTDETAILV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck:#NOT_REQUIRED
@EndUserText.label: 'Flugdetails'
@Metadata.allowExtensions: true
@OData.publish: true
define view ZI_FlightDetail
  with parameters
    //  P_TargetCurrency :abap.cuky( 5 )
    P_TargetCurrency : waerk
  as select from ZI_Flight
  association [1] to /DMO/I_Carrier    as _Carrier    on  $projection.CarrierId = _Carrier.AirlineID
  association [1] to /DMO/I_Connection as _Connection on  $projection.ConnectionId = _Connection.ConnectionID
                                                      and $projection.CarrierId    = _Connection.AirlineID
{
  key CarrierId,
  key ConnectionId,
  key FlightDate,

      //  @EndUserText.label: 'Verfügbare Plätze'           //auslagern in metadata ext
      SeatsMax - SeatsOccupied as SeatsFree,
      //  @EndUserText.label: 'Flug ausgebucht'             //auslagern in metadata ext
      case SeatsOccupied
        when SeatsMax
          then 'X'
          else ''
        end                    as FlightOccupied,

      @Semantics.amount.currencyCode:'CurrencyCode'
      Price,
      @Semantics.currencyCode:true
      CurrencyCode,

      PlaneTypeId,
      SeatsMax,
      SeatsOccupied,

      @EndUserText.label: 'Wochentag des Fluges'
      @ObjectModel.readOnly: true
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy:
                  'ABAP:ZCL_FLIGHTDETAIL_CALC_EXIT'
      cast ( '' as langt )     as FlightDateWeekday,

      //  virtual FlightDateWeekday: langt,     //virtual Elements in Projection Views'

      @Semantics.amount.currencyCode:'TargetCurrency'
      currency_conversion(
        amount => Price,
        source_currency => CurrencyCode,
        round => 'X',
        target_currency => :P_TargetCurrency,
        exchange_rate_date => FlightDate
      )

                               as PriceInTargetCurrency,

      @Semantics.currencyCode:true
      cast(:P_TargetCurrency
        as vdm_v_target_currency
        preserving type)       as TargetCurrency,

      _Carrier,
      _Connection
}
//  where
//  FlightDate >= $session.system_date
