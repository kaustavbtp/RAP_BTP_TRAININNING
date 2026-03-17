@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity of Billing Header'
define root view entity ZKD_I_Bill_Header
  as select from zkd_bill_header
{
  key bill_id               as BillId,
      bill_type             as BillType,
      bill_date             as BillDate,
      customer_id           as CustomerId,
      @Semantics.amount.currencyCode : 'Currency'
      net_amount            as NetAmount,
      currency              as Currency,
      sales_org             as SalesOrg,
      @Semantics.user.createdBy: true
      createdby             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      createdat             as CreateDat,
      @Semantics.user.lastChangedBy: true
      lastchangedby         as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangeDat,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangeDat
}
