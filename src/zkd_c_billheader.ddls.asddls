@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View of Bill doc header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZKD_C_BillHeader
  provider contract transactional_query
  as projection on ZKD_I_Bill_Header
{
  key BillId,
      BillType,
      BillDate,
      CustomerId,
      @Semantics.amount.currencyCode: 'Currency'
      NetAmount,
      Currency,
      SalesOrg,
      CreatedBy,
      CreateDat,
      LastChangedBy,
      LastChangeDat,
      LocalLastChangeDat
}
