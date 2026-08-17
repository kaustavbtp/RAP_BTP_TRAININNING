@EndUserText.label: 'Approver Projection Travel'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true



@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
        type: #STANDARD,
        label: 'Travel',
        value: 'TravelId'
    }
}
@Search.searchable: true


define root view entity ZC_TRAVEL_APPROVER_KDAS_M
  provider contract transactional_query
  as projection on ZI_TRAVEL_KDAS_M
{
      @UI.facet: [{
            id: 'Travel',
            purpose: #STANDARD,
            position: 10 ,
            label: 'Travel',
            type: #IDENTIFICATION_REFERENCE
        },
        {
            id: 'Booking',
            purpose: #STANDARD,
            position: 20 ,
            label: 'Booking',
            type: #LINEITEM_REFERENCE,
            targetElement: '_Booking'
        }
        ]

      @UI: { lineItem: [ { position: 10, importance: #HIGH  } ],
             identification: [ { position: 10  } ]
             }
      @Search.defaultSearchElement: true
  key TravelId,
      @UI: { lineItem: [{ position: 20 }],
             selectionField: [{ position: 20 }],
             identification: [{ position: 20 }]
           }
      // we are given value help definition for agency and customer,
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency',
                                           element: 'AgencyID'
      } }]
      @ObjectModel.text.element: ['AgencyName']
      @Search.defaultSearchElement: true
      AgencyId,
      _Agency.Name       as AgencyName,
      @UI: { lineItem: [{ position: 30 }],
       selectionField: [{ position: 30 }],
        identification: [{ position: 30 }]
      }
      @Search.defaultSearchElement: true
      // we are given value help definition for agency and customer,
      @Consumption.valueHelpDefinition: [{ entity: {
          name: '/DMO/I_Customer',
          element: 'CustomerID'
      } }]
      @ObjectModel.text.element: ['CustomerName']
      CustomerId,
      _Customer.LastName as CustomerName,
      @UI: {
      identification: [{ position: 40 }]
      }
      BeginDate,
      @UI: {
      identification: [{ position: 41 }]
      }
      EndDate,
      @UI: { lineItem: [ { position: 42, importance: #MEDIUM  } ],
       identification: [ { position: 42  } ]
       }
      @Semantics.amount.currencyCode: 'CurrencyCode'
      BookingFee,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI: { lineItem: [ { position: 43, importance: #MEDIUM  } ],
            identification: [ { position: 43, label: 'Total Price'  } ]
      }
      TotalPrice,
      CurrencyCode,
      @UI: { lineItem: [ { position: 45, importance: #MEDIUM  } ],
       identification: [ { position: 45  } ]
       }
      Description,
      @UI: { lineItem: [{ position: 15 , importance: #HIGH},
          { type: #FOR_ACTION, dataAction: 'AcceptTravel', label: 'Accept Travel' },
          { type: #FOR_ACTION, dataAction: 'RejectTravel' , label: 'Reject Travel' }],

          identification: [{ position: 15 , importance: #HIGH},
          { type: #FOR_ACTION, dataAction: 'AcceptTravel', label: 'Accept Travel' },
          { type: #FOR_ACTION, dataAction: 'RejectTravel' , label: 'Reject Travel' }],

            selectionField: [{ position: 90 }],
            textArrangement: #TEXT_ONLY
            }
      @EndUserText.label: 'Overall Status'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: '/DMO/I_overall_status_VH' , element: 'OverallStatus'}  }]
      OverallStatus,
      @UI.hidden: true
      CreatedBy,
      @UI.hidden: true
      CreatedAt,
      @UI.hidden: true
      LastChangedBy,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child ZC_BOOKING_APPROVER_KDAS_M,
      _Currency,
      _Customer,
      _Status
}

