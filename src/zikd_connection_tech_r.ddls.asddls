@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Connection View CDS Data Model'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: {
    typeName: 'Connection',
    typeNamePlural: 'Connections'
}
define view entity zikd_connection_tech_r
  as select from /dmo/connection
  association [1..*] to ZIKD_Flight_tech_R as _flight on  $projection.CarrierId    = _flight.CarrierId
                                                      and $projection.ConnectionId = _flight.ConnectionId
{
      @UI.facet: [{
                    id: 'Connection',
                    purpose: #STANDARD,
                    type: #IDENTIFICATION_REFERENCE,
                    position: 10,
                    label: 'Connection Detail'},

                    { id: 'Flight',
                    purpose: #STANDARD,
                    type: #LINEITEM_REFERENCE,
                    position: 20,
                    label: 'Flights'}


                    ]

      @UI.lineItem: [{position: 10, label: 'Connection ID'}]
      @UI.identification: [{position: 10, label: 'Airline'}]
  key carrier_id      as CarrierId,
      @UI.identification: [{position: 20}]
      @UI.lineItem: [{position: 20}]
  key connection_id   as ConnectionId,
      @UI.identification: [{position: 30}]
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{position: 30}]
      airport_from_id as AirportFromId,
      @UI.identification: [{position: 40}]
      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{position: 40}]
      airport_to_id   as AirportToId,
      @UI.identification: [{position: 50}]
      @UI.lineItem: [{position: 50, label: 'Departure Time'}]
      departure_time  as DepartureTime,
      @UI.identification: [{position: 60}]
      @UI.lineItem: [{position: 60}]
      arrival_time    as ArrivalTime,
      //    distance as Distance,
      //    distance_unit as DistanceUnit
      //      -----> Associations
      _flight
}
