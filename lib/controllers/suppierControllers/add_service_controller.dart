import 'dart:async';
import 'dart:developer';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/app_lists.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supabase_storage_service.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/utils.dart';

class AddServiceController extends GetxController {
  RxString selectedService = services.first.obs;
  TextEditingController amountController = TextEditingController();
  TextEditingController serviceDescController = TextEditingController();
  RxString imagePath = ''.obs;
  RxBool isAdvertisedSelected = false.obs;
  RxBool perHour = false.obs;

  RxList<ServiceModel> userServices = <ServiceModel>[].obs;
  RxList<ServiceModel> generalServices = <ServiceModel>[].obs;
  RxList<ServiceModel> advertisedServices = <ServiceModel>[].obs;
  Rx<TextEditingController> locationController = TextEditingController().obs;
  late StreamSubscription<List<Map<String, dynamic>>> servicesStream;

  @override
  void onInit() {
    super.onInit();
    streamServices();
    Utils.loadRomanianCitiesFromCSV().then((cities) {
      romaniaCities.assignAll(cities);
      print('Loaded ${cities.length} cities');
    });
  }

  clearFields() {
    selectedService.value = services.first;
    amountController.text = "";
    serviceDescController.text = "";
    imagePath.value = '';
  }

  pickImage({bool isCamera = false}) async {
    Get.back();
    XFile? file;
    if (isCamera) {
      file = await ImagePickerService.instance.pickImageFromCamera();
    } else {
      file = await ImagePickerService.instance.pickSingleImageFromGallery();
    }

    if (file != null) {
      imagePath.value = file.path;
    }
  }

  uploadService() async {
    if (imagePath.isEmpty) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: "Please select image");
      return;
    }
    BuildContext context = globalNavKey.currentState!.context;

    DialogService.instance.showProgressDialog(context: context);
    String? imageUrl = await SupabaseStorageService.instance.uploadSingleImage(
        imgFilePath: imagePath.value,
        storageRef: 'services',
        storagePath: 'serviceImages');

    if (SupabaseCRUDService.instance.getCurrentUser()?.id == null) {
      await Future.delayed(Duration(seconds: 2));
    }

    if (imageUrl != null) {
      ServiceModel serviceModel = ServiceModel(
        perHour: perHour.value,
          location: locationController.value.text,
          createdBy: SupabaseCRUDService.instance.getCurrentUser()?.id,
          amount: amountController.text,
          serviceName: selectedService.value,
          createdAt: DateTime.now(),
          about: serviceDescController.text,
          serviceImage: imageUrl);

      bool isDocAdded = await SupabaseCRUDService.instance.createDocument(
          tableName: SupabaseConstants().serviceTable,
          data: serviceModel.toMap());
      DialogService.instance.hideProgressDialog(context: context);

      if (isDocAdded) {
        clearFields();
        Get.close(1);
        await Future.delayed(Duration(milliseconds: 100));
        CustomSnackBars.instance
            .showSuccessSnackbar(title: "Success", message: "Service Added");

      }
    } else {
      DialogService.instance.hideProgressDialog(context: context);
      Get.back();
    }
  }

  updateService({required String value}) {
    selectedService.value = value;
  }

  streamServices() async {
    if (SupabaseCRUDService.instance.getCurrentUser()?.id == null) {
      await Future.delayed(Duration(seconds: 2));
    }
    log("streamServices called = ${SupabaseCRUDService.instance.getCurrentUser()?.id}");
    servicesStream = SupabaseConstants()
        .supabase
        .from(SupabaseConstants().serviceTable)
        .stream(primaryKey: ['id'])
        .eq('created_by', SupabaseCRUDService.instance.getCurrentUser()!.id)
        .listen(
          (services) {
            log("servicesStream called");
            List<ServiceModel> tempServices = [];
            List<ServiceModel> tempGeneralServices = [];
            List<ServiceModel> tempAdvertisedServices = [];

            for (var service in services) {
              log("Service = $service");
              ServiceModel serviceModel = ServiceModel.fromMap(service);
              tempServices.add(serviceModel);
              if (serviceModel.advertised == true) {
                log("Service advertised= $service");
                tempAdvertisedServices.add(serviceModel);
              } else {
                log("Service general= $service");

                tempGeneralServices.add(serviceModel);
              }
            }
            userServices.assignAll(tempServices);
            generalServices.assignAll(tempGeneralServices);
            advertisedServices.assignAll(tempAdvertisedServices);
            log("generalServices = ${generalServices.length}");
          },
        );
  }

  advertiseTheService(
      {required ServiceModel serviceModel,
      required BuildContext context}) async {
    DateTime now = DateTime.now();

    DialogService.instance.showProgressDialog(context: context);
    bool isUpdated = await SupabaseCRUDService.instance.updateDocument(
        tableName: SupabaseConstants().serviceTable,
        id: serviceModel.id ?? '',
        data: {
          'advertised': true,
          'advertised_from': now.toIso8601String(),
          'advertised_till':
              DateTime(now.year, now.month, now.day + 7).toIso8601String(),
        });
    DialogService.instance.hideProgressDialog(context: context);
    if (isUpdated) {
      Get.close(2);
      CustomSnackBars.instance
          .showSuccessSnackbar(title: "Success", message: "Service Advertised");
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failed", message: "Failed in Advertising");
    }
  }
}
