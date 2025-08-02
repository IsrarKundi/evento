import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/app_lists.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/bottomNavBar/homeScreen/filtered_service_screen.dart';

import '../../core/utils/utils.dart';
import '../../models/availabilityModel/availability_model.dart';

class UserHomeController extends GetxController {
  RxMap<String, dynamic> advertisedServices = <String, dynamic>{}.obs;

  String selectedCity = '';
  String selectedEvent = '';
  DateTime? selectedDate = null;

  RxList<ServiceModel> filteredServices = <ServiceModel>[].obs;

  onApplyFilter(BuildContext context) async {
    filteredServices.value = [];
    DialogService.instance.showProgressDialog(context: context);
    List<Map<String, dynamic>>? documents = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(filters: {
      'location': selectedCity,
      "service_name": selectedEvent,
    }, tableName: SupabaseConstants().serviceTable);
    if (documents != null) {
      for (var doc in documents) {
        ServiceModel serviceModel = ServiceModel.fromMap(doc);
        List<Map<String, dynamic>>? availDocs =
            await SupabaseCRUDService.instance.readAllDocumentsWithFilters(
                tableName: SupabaseConstants().availabilityTable,
                filters: {"created_by": serviceModel.createdBy});
        log("Avail Logs = ${availDocs}");
        if (availDocs != null && availDocs.isNotEmpty) {

          log("Avail Logs Not Empty = ${availDocs.length} selectedDate=  ${selectedDate}");
          AvailabilityModel availabilityModel =
              AvailabilityModel.fromMap(availDocs.first);

          if (selectedDate!.isAfter(availabilityModel.startDate

                  .subtract(Duration(days: 1))) &&
              selectedDate!.isBefore(
                  availabilityModel.endDate.add(Duration(days: 1)))) {
            serviceModel =
                serviceModel.copyWith(availability: availabilityModel);
            log("Service Model = ${serviceModel.toMap()}");
            filteredServices.add(serviceModel);
          }
        }
      }
      DialogService.instance.hideProgressDialog(context: context);

      Get.to(() =>
          FilteredServiceScreen(filteredServices: filteredServices.value));
    }
  }

  @override
  void onInit() {
    super.onInit();
    Utils.loadRomanianCitiesFromCSV().then((cities) {
      romaniaCities.assignAll(cities);
      print('Loaded ${cities.length} cities');
    });
    for (String service in services) {
      advertisedServices.putIfAbsent(
        service,
        () => null,
      );
      // advertisedServices.add({service: null});
    }
    getAllServices();
  }

  getAllServices() async {
    List<Map<String, dynamic>>? serviceDocs = await SupabaseCRUDService.instance
        .readAllDocumentsWithJoin(
            fieldName: 'advertised',
            fieldValue: true,
            joinQuery: '*,user:users(*)',
            tableName: SupabaseConstants().serviceTable,
            limit: 5);
    if (serviceDocs != null && serviceDocs.isNotEmpty) {
      for (var doc in serviceDocs) {
        ServiceModel serviceModel = ServiceModel.fromMap(doc);
        if (advertisedServices[serviceModel.serviceName ?? ""] == null) {
          advertisedServices[serviceModel.serviceName ?? ""] = [];
        }
        (advertisedServices[serviceModel.serviceName ?? ""] as List)
            .add(serviceModel);
      }
    }
  }
}
