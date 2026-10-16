@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Projection View Booking Entity'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@UI.headerInfo: { typeName: 'Booking',
                  typeNamePlural: 'Bookings',
                  title: { type: #STANDARD, value: 'BookingID' } }

define view entity YGDS_C_Booking_m
  as projection on YGDS_I_Booking_m

{
  key travel_id                 as TravelID,
  key booking_id                as BookingID,


      booking_date              as BookingDate,

      @ObjectModel.text.element: [ 'CustomerName' ]
      customer_id               as CustomerID,

      _Customer.LastName        as CustomerName,

      @ObjectModel.text.element: [ 'CarrierName' ]
      carrier_id                as CarrierID,

      _Carrier.Name             as CarrierName,


      connection_id             as ConnectionID,


      flight_date               as FlightDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price              as FlightPrice,


      currency_code             as CurrencyCode,

      @ObjectModel.text.element: [ 'BookingStatusText' ]
      booking_status            as BookingStatus,


      _BookingStatus._Text.Text as BookingStatusText : localized,


      last_changed_at           as LastChangedAt,


      /* Associations */
      _Travel         : redirected to parent YGDS_C_Travel_m,
      _BookingSupp : redirected to composition child YGDS_C_BookingSupp_m,

      _Customer,
      _Carrier,
      _BookingStatus
}
