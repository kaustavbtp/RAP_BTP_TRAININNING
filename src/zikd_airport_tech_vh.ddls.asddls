@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for Airport'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity zikd_airport_tech_vh
  as select from /dmo/airport
{
      @Search.defaultSearchElement: true
  key airport_id as AirportId,
      @Search.defaultSearchElement: true
      name       as Name,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      city       as City,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      country    as Country
}
