@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface View Manged'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_BOOKING_KDAS_M as select from ZBOOKING_KDAS_M
 association        to parent ZI_TRAVEL_KDAS_M  as _Travel         on  $projection.TravelId = _Travel.TravelId
  composition [0..*] of ZI_BOOKSUPPL_KDAS_M      as _Bookingsuppl
  association [1..1] to /DMO/I_Carrier           as _Carrier        on  $projection.CarrierId = _Carrier.AirlineID
  association [1..1] to /DMO/I_Customer          as _Customer       on  $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Connection        as _Connection     on  $projection.CarrierId    = _Connection.AirlineID
                                                                    and $projection.ConnectionId = _Connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _Booking_Status on  $projection.BookingStatus = _Booking_Status.BookingStatus

{
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
       //the persistent field last_changed_at plays a special role as a field ETag.
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at as LastChangedAt,
      _Bookingsuppl,
      _Travel,
      _Carrier,
      _Customer,
      _Connection,
      _Booking_Status
}
