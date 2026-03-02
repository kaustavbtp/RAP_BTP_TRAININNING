@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier detail'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity zikd_carrier_tech_r
  as select from /dmo/carrier
{
  key carrier_id    as CarrierId,
      @Semantics.text: true // Annotation to indicate that this field contains text that can be used for display purposes
      @Search.defaultSearchElement: true // Annotation to indicate that this field should be included in the default search
      @Search.fuzzinessThreshold: 0.8 // Annotation to specify the fuzziness threshold for search
      name          as Name,
      currency_code as CurrencyCode
}
