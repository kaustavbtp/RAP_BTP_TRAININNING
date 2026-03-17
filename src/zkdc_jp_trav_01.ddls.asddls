@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Travel'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@UI:{ headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
        type: #STANDARD,
        value: 'TravelID'
    }
} }
define root view entity ZKDC_JP_TRAV_01
  as projection on ZKD_JP_TRAV_01
{

  key TravelId,

      @Consumption.valueHelpDefinition: [{

          entity: {
              name: '/DMO/I_Agency',
              element: 'AgencyID'
          }}]
      @ObjectModel.text.element: ['AgencyName']
      @Search.defaultSearchElement: true
      AgencyId,
      _Agency.Name        as AgencyName,

      @Consumption.valueHelpDefinition: [{

               entity: {
                   name: '/DMO/I_Customer',
                   element: 'CustomerID'
               }}]
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true

      CustomerId,
      _Customer.FirstName as CustomerName,

      BeginDate, 
      EndDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,

      @Consumption.valueHelpDefinition: [{

             entity: {
                 name: 'I_Currency',
                 element: 'Currency'
             }}]
      @Search.defaultSearchElement: true
      CurrencyCode,
      Description,
      Status,
      LastChangedAt,
      _Agency,
      _Booking : redirected to composition child ZKDC_JP_BOOK_01,
      _Currency,
      _Customer
}
