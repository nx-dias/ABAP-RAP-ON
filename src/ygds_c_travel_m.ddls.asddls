@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Projection View Travel Entity'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true



define root view entity YGDS_C_Travel_m
provider contract transactional_query
  as projection on YGDS_I_Travel_m

{
  key travel_id                 as TravelID,

      @ObjectModel.text.element: [ 'AgencyName' ]
      agency_id                 as AgencyID,

      _Agency.Name              as AgencyName,

      @ObjectModel.text.element: [ 'CustomerName' ]
      customer_id               as CustomerID,

      _Customer.LastName        as CustomerName,


      begin_date                as BeginDate,


      end_date                  as EndDate,


      @Semantics.amount.currencyCode: 'CurrencyCode'
      booking_fee               as BookingFee,

      @Semantics.amount.currencyCode: 'CurrencyCode'

      total_price               as TotalPrice,


      currency_code             as CurrencyCode,

      @ObjectModel.text.element: [ 'OverallStatusText' ]
      overall_status            as OverallStatus,


      _OverallStatus._Text.Text as OverallStatusText : localized,


      description               as Description,


      last_changed_at           as LastChangedAt,

      /* Associations */
      _Booking : redirected to composition child YGDS_C_Booking_m,

      _Agency,
      _Customer,
      _OverallStatus
}
