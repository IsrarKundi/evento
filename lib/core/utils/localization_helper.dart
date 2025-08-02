import 'package:event_connect/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LocalizationHelper {
  static List<String> getLocalizedServices(BuildContext context) {
    return [
      AppLocalizations.of(context)!.serviceArtists,
      AppLocalizations.of(context)!.serviceEventSpaces,
      AppLocalizations.of(context)!.serviceCateringCompanies,
      AppLocalizations.of(context)!.serviceInteriorDecorators,
      AppLocalizations.of(context)!.serviceCarRental,
      AppLocalizations.of(context)!.servicePhotographers,
      AppLocalizations.of(context)!.serviceMakeup,
      AppLocalizations.of(context)!.serviceHairdressing,
      AppLocalizations.of(context)!.servicePodiumLighting,
      AppLocalizations.of(context)!.serviceTentRental,
      AppLocalizations.of(context)!.serviceWeddingGifts,
      AppLocalizations.of(context)!.serviceTailoringFashion,
      AppLocalizations.of(context)!.serviceAlcoholSuppliers,
      AppLocalizations.of(context)!.serviceFlowersBouquets,
      AppLocalizations.of(context)!.serviceOthers,
    ];
  }

  static String getLocalizedServiceByKey(BuildContext context, String key) {
  final localizations = AppLocalizations.of(context)!;

  final map = {
    'artists': localizations.serviceArtists,
    'eventSpaces': localizations.serviceEventSpaces,
    'cateringCompanies': localizations.serviceCateringCompanies,
    'interiorDecorators': localizations.serviceInteriorDecorators,
    'carRental': localizations.serviceCarRental,
    'photographers': localizations.servicePhotographers,
    'makeup': localizations.serviceMakeup,
    'hairdressing': localizations.serviceHairdressing,
    'podiumLighting': localizations.servicePodiumLighting,
    'tentRental': localizations.serviceTentRental,
    'weddingGifts': localizations.serviceWeddingGifts,
    'tailoringFashion': localizations.serviceTailoringFashion,
    'alcoholSuppliers': localizations.serviceAlcoholSuppliers,
    'flowersBouquets': localizations.serviceFlowersBouquets,
    'others': localizations.serviceOthers,
  };

  return map[key] ?? key; // fallback to the original key if not found
}


  static String getLocalizedServiceName(BuildContext context, String serviceKey) {
    final services = getLocalizedServices(context);
    const originalServices = [
      "Artists",
      "Event Spaces",
      "Catering Companies",
      "Interior Decoration Companies",
      "Car Rental Companies",
      "Photographers",
      "Makeup",
      "Hairdressing/Barber",
      "Podium/Lighting Setup Companies",
      "Tent Rental Companies",
      "Wedding Gifts, Presents, Favors",
      "Tailoring Workshops, Fashion, etc",
      "Alcohol Suppliers, Cigars, Bars",
      "Flowers, Bouquets",
      "Others",
    ];

    final index = originalServices.indexOf(serviceKey);
    return index != -1 ? services[index] : serviceKey;
  }
} 