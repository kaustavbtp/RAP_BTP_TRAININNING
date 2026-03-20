@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Supp Projection View Manged'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BOOKSUPPL_KDAS_M as projection on ZI_BOOKSUPPL_KDAS_M

{
  key TravelId,
  key BookingId,
  key BookingSupplementId,
      @ObjectModel.text.element: [ 'SupplemenDesc' ]
      SupplementId,
      _SupplementText.Description as SupplemenDesc : localized,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,
      LastChangedAt,
      /* Associations */
      _Travel  : redirected to ZC_TRAVEL_KDAS_M,
      _Booking : redirected to parent ZC_BOOKING_KDAS_M,
      _Supplement,
      _SupplementText
}
