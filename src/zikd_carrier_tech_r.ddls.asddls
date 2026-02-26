@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Carrier detail'
@Metadata.ignorePropagatedAnnotations: true
define view entity zikd_carrier_tech_r
  as select from /dmo/carrier
{
  key carrier_id    as CarrierId,
      name          as Name,
      currency_code as CurrencyCode
}
