@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Booking Supplement Entity'

@Metadata.ignorePropagatedAnnotations: true

define view entity YGDS_I_BookingSupp_m
  as select from ygds_booking_sup

  association        to parent YGDS_I_Booking_m      as _Booking
    on  $projection.booking_id = _Booking.booking_id
    and $projection.travel_id  = _Booking.travel_id

  association [1..1] to        YGDS_I_Travel_m       as _Travel
    on $projection.travel_id = _Travel.travel_id

  association [1..1] to        /DMO/I_Supplement     as _Product
    on $projection.supplement_id = _Product.SupplementID

  association [1..*] to        /DMO/I_SupplementText as _SupplementText
    on $projection.supplement_id = _SupplementText.SupplementID

{
  key travel_id,
  key booking_id,
  key booking_supplement_id,

      supplement_id,

      @Semantics.amount.currencyCode: 'currency_code'
      price,

      currency_code,

      @Semantics.systemDate.localInstanceLastChangedAt: true
      last_changed_at,

      /* Associations */
      _Travel,
      _Booking,
      _Product,
      _SupplementText
}
