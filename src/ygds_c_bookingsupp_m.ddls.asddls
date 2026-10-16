@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Projection View Booking Supplement Entity'

@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@UI.headerInfo: { typeName: 'Booking Supplement',
                  typeNamePlural: 'Booking Supplements',
                  title: { type: #STANDARD, label: 'Booking Supplement', value: 'BookingSupplementID' } }

define view entity YGDS_C_BookingSupp_m
  as projection on YGDS_I_BookingSupp_m

{
  key travel_id                   as TravelID,
  key booking_id                  as BookingID,
  key booking_supplement_id       as BookingSupplementID,


      @ObjectModel.text.element: [ 'SupplementDescription' ]
      supplement_id               as SupplementID,

      _SupplementText.Description as SupplementDescription : localized,


      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                       as Price,


      currency_code               as CurrencyCode,


      last_changed_at             as LastChangedAt,

      /* Associations */
      _Travel  : redirected to YGDS_C_Travel_m,
      _Booking : redirected to parent YGDS_C_Booking_m,

      _Product
}
