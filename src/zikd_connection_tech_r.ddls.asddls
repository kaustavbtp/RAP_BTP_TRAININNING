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
define view entity zikd_connection_tech_r as select from /dmo/connection
{
    @UI.lineItem: [{position: 10}]
    key carrier_id as CarrierId,
    @UI.lineItem: [{position: 20}]
    key connection_id as ConnectionId,
    @UI.lineItem: [{position: 30}]
    airport_from_id as AirportFromId,
    @UI.lineItem: [{position: 40}]
    airport_to_id as AirportToId,
    @UI.lineItem: [{position: 50, label: 'Departure Time'}]
    departure_time as DepartureTime,
    @UI.lineItem: [{position: 70}]
    arrival_time as ArrivalTime
//    distance as Distance,
//    distance_unit as DistanceUnit
}
