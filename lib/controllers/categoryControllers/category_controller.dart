import 'dart:developer';

import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/availabilityModel/availability_model.dart';
import 'package:event_connect/models/portfolioModel/portfolio_model.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';

class CategoryController extends GetxController {
  final String title = Get.arguments;

  RxBool isLoading = false.obs;

  RxList<ServiceModel> serviceModels = <ServiceModel>[].obs;
  RxList<ServiceModel> advertisedModels = <ServiceModel>[].obs;
  RxList<PortfolioModel> portfolioModel = <PortfolioModel>[].obs;
  RxList<ServiceModel> filteredModels = <ServiceModel>[].obs;

  List<AvailabilityModel> availabilityModels = [];
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 1000.0.obs;

  Rx<DateTime> initialDate = DateTime.now().subtract(Duration(days: 365)).obs;
  Rx<DateTime> endDate = DateTime.now().add(Duration(days: 365)).obs;

  RxBool priceFilter = false.obs;

  RxBool filterApplied = false.obs;

  RxString selectedCity = 'all'.obs;

  applyFilters() {
    filteredModels.value = serviceModels
        .where(
          (service) =>
              double.parse(service.amount ?? '0') >= minPrice.value &&
              double.parse(service.amount ?? '0') <= maxPrice.value,
        )
        .where(
          (service) {
            log("Service availability = ${service.availability?.toMap()}");
            log("Service availability = ${(service.availability!.startDate
                .subtract(Duration(days: 1))
                .isAfter(initialDate.value))}");
            log("Service availability end = ${(service.availability!.endDate
                .add(Duration(days: 1))
                .isBefore(endDate.value))}");
            return
                (service.availability!.startDate
                    .subtract(Duration(days: 1))
                    .isAfter(initialDate.value)) &&
                (service.availability!.endDate
                    .add(Duration(days: 1))
                    .isBefore(endDate.value));
          },
        ).where((service) {
          if(selectedCity.value!='all'){
            return service.location==selectedCity.value;
          }else{
            return true;
          }
        },)
        .toList();

    filterApplied.value = true;
  }

  @override
  void onInit() {
    log("Title called $title");
    log("CategoryController init called");
    getCategoryEvents();
    super.onInit();
  }

  getCategoryEvents() async {
    isLoading(true);
    log("getCategoryEvents called");
    List<Map<String, dynamic>>? documents = await SupabaseCRUDService.instance
        .readAllDocumentsWithJoin(
            joinQuery: '*,user:users(*)',
            tableName: SupabaseConstants().serviceTable,
            fieldName: 'service_name',
            fieldValue: title);

    log("getCategoryEvents documents = ${documents}");
    if (documents != null) {
      for (var doc in documents) {
        doc.putIfAbsent(
          'availability',
          () => null,
        );

        log("doc['created_by'] = ${doc['created_by']}");

        if (availabilityModels.firstWhereOrNull(
              (element) => element.createdBy == doc['created_by'],
            ) ==
            null) {
          log("Null condition called");
          List<Map<String, dynamic>>? availDocs =
              await SupabaseCRUDService.instance.readAllDocuments(
                  tableName: SupabaseConstants().availabilityTable,
                  fieldName: 'created_by',
                  fieldValue: doc['created_by']);

          log("availDocs = ${availDocs}");

          if (availDocs != null && availDocs.isNotEmpty) {
            AvailabilityModel availabilityModel =
                AvailabilityModel.fromMap(availDocs.first);
            availabilityModels.add(availabilityModel);
            doc['availability'] = availDocs.first;
          }
        } else {
          log("Not Null condition called");
          doc['availability'] = availabilityModels
              .firstWhere(
                (element) => element.createdBy == doc['created_by'],
              )
              .toMap();
        }

        log("getCategoryEvents = ${doc}");
        if(doc['availability']!=null)
          {
            ServiceModel serviceModel = ServiceModel.fromMap(doc);
            serviceModels.add(serviceModel);
            if(serviceModel.advertised==true){
              advertisedModels.add(serviceModel);
            }
          }

      }
    }
    isLoading(false);
  }
}
