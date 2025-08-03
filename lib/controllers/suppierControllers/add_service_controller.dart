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
  StreamSubscription<List<Map<String, dynamic>>>? servicesStream;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _updateExpiredAdvertisement(ServiceModel serviceModel) async {
  try {
    await SupabaseCRUDService.instance.updateDocument(
      tableName: SupabaseConstants().serviceTable,
      id: serviceModel.id ?? '',
      data: {
        'advertised': false,
        'advertised_from': null,
        'advertised_till': null,
      }
    );
  } catch (e) {
    log("Error updating expired advertisement: $e");
  }
}

  @override
  void onClose() {
    // Cancel stream subscription to prevent memory leaks
    servicesStream?.cancel();
    amountController.dispose();
    serviceDescController.dispose();
    locationController.value.dispose();
    super.onClose();
  }

  Future<void> _initializeController() async {
    await _waitForUserAuthentication();
    streamServices();
    _loadCities();
  }

  Future<void> _waitForUserAuthentication() async {
    // Wait for user to be authenticated
    int attempts = 0;
    while (SupabaseCRUDService.instance.getCurrentUser()?.id == null && attempts < 10) {
      await Future.delayed(Duration(milliseconds: 500));
      attempts++;
    }
  }

  void _loadCities() {
    Utils.loadRomanianCitiesFromCSV().then((cities) {
      romaniaCities.assignAll(cities);
      log('Loaded ${cities.length} cities');
    }).catchError((error) {
      log('Error loading cities: $error');
    });
  }

  clearFields() {
    selectedService.value = services.first;
    amountController.clear();
    serviceDescController.clear();
    imagePath.value = '';
    locationController.value.clear();
    perHour.value = false;
  }

  pickImage({bool isCamera = false}) async {
    Get.back();
    XFile? file;
    try {
      if (isCamera) {
        file = await ImagePickerService.instance.pickImageFromCamera();
      } else {
        file = await ImagePickerService.instance.pickSingleImageFromGallery();
      }

      if (file != null) {
        imagePath.value = file.path;
      }
    } catch (e) {
      log('Error picking image: $e');
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Failed to pick image"
      );
    }
  }

  uploadService() async {
    if (imagePath.isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Failed", 
        message: "Please select image"
      );
      return;
    }

    if (amountController.text.trim().isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Failed", 
        message: "Please enter amount"
      );
      return;
    }

    if (locationController.value.text.trim().isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Failed", 
        message: "Please select location"
      );
      return;
    }

    BuildContext context = globalNavKey.currentState!.context;

    try {
      DialogService.instance.showProgressDialog(context: context);
      
      // Upload image first
      String? imageUrl = await SupabaseStorageService.instance.uploadSingleImage(
        imgFilePath: imagePath.value,
        storageRef: 'services',
        storagePath: 'serviceImages'
      );

      if (imageUrl == null) {
        DialogService.instance.hideProgressDialog(context: context);
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Failed", 
          message: "Failed to upload image"
        );
        return;
      }

      // Ensure user is authenticated
      String? userId = SupabaseCRUDService.instance.getCurrentUser()?.id;
      if (userId == null) {
        await _waitForUserAuthentication();
        userId = SupabaseCRUDService.instance.getCurrentUser()?.id;
      }

      if (userId == null) {
        DialogService.instance.hideProgressDialog(context: context);
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Failed", 
          message: "User not authenticated"
        );
        return;
      }

      // Create service model
      ServiceModel serviceModel = ServiceModel(
        perHour: perHour.value,
        location: locationController.value.text.trim(),
        createdBy: userId,
        amount: amountController.text.trim(),
        serviceName: selectedService.value,
        createdAt: DateTime.now(),
        about: serviceDescController.text.trim(),
        serviceImage: imageUrl,
        advertised: false, // New services are not advertised by default
      );

      // Save to database
      bool isDocAdded = await SupabaseCRUDService.instance.createDocument(
        tableName: SupabaseConstants().serviceTable,
        data: serviceModel.toMap()
      );

      DialogService.instance.hideProgressDialog(context: context);

      if (isDocAdded) {
        clearFields();
        Get.back();
        
        // Small delay to ensure UI updates
        await Future.delayed(Duration(milliseconds: 200));
        
        CustomSnackBars.instance.showSuccessSnackbar(
          title: "Success", 
          message: "Service Added Successfully"
        );
        
        // Force refresh the stream if needed
        _refreshServicesStream();
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Failed", 
          message: "Failed to add service"
        );
      }
    } catch (e) {
      DialogService.instance.hideProgressDialog(context: context);
      log('Error uploading service: $e');
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "An error occurred while adding service"
      );
    }
  }

  updateService({required String value}) {
    selectedService.value = value;
  }

  streamServices() async {
    try {
      // Cancel existing stream if any
      await servicesStream?.cancel();
      
      String? userId = SupabaseCRUDService.instance.getCurrentUser()?.id;
      if (userId == null) {
        log("User not authenticated, waiting...");
        await _waitForUserAuthentication();
        userId = SupabaseCRUDService.instance.getCurrentUser()?.id;
      }

      if (userId == null) {
        log("Failed to get user ID for streaming services");
        return;
      }

      log("Starting services stream for user: $userId");
      
      servicesStream = SupabaseConstants()
          .supabase
          .from(SupabaseConstants().serviceTable)
          .stream(primaryKey: ['id'])
          .eq('created_by', userId)
          .listen(
            (services) {
              log("Services stream received ${services.length} services");
              _processServicesUpdate(services);
            },
            onError: (error) {
              log("Services stream error: $error");
            },
          );
    } catch (e) {
      log("Error setting up services stream: $e");
    }
  }

// Update the _processServicesUpdate method to handle expired advertisements
void _processServicesUpdate(List<Map<String, dynamic>> services) {
  try {
    List<ServiceModel> tempServices = [];
    List<ServiceModel> tempGeneralServices = [];
    List<ServiceModel> tempAdvertisedServices = [];

    for (var service in services) {
      try {
        ServiceModel serviceModel = ServiceModel.fromMap(service);
        tempServices.add(serviceModel);
        
        // Check if service is advertised and not expired
        bool isAdvertised = serviceModel.advertised == true;
        if (isAdvertised && serviceModel.advertisedTill != null) {
          // Check if advertisement has expired
          if (serviceModel.advertisedTill!.isBefore(DateTime.now())) {
            isAdvertised = false;
            // Optionally update the database to mark as not advertised
            _updateExpiredAdvertisement(serviceModel);
          }
        }
        
        if (isAdvertised) {
          tempAdvertisedServices.add(serviceModel);
        } else {
          tempGeneralServices.add(serviceModel);
        }
      } catch (e) {
        log("Error processing service: $e");
      }
    }

    // Update observable lists
    userServices.assignAll(tempServices);
    generalServices.assignAll(tempGeneralServices);
    advertisedServices.assignAll(tempAdvertisedServices);
    
    log("Services updated - Total: ${tempServices.length}, General: ${tempGeneralServices.length}, Advertised: ${tempAdvertisedServices.length}");
  } catch (e) {
    log("Error processing services update: $e");
  }
}

void _updateLocalServiceModel(String serviceId, Map<String, dynamic> updates) {
  try {
    // Find and update the service in userServices
    int userServiceIndex = userServices.indexWhere((service) => service.id == serviceId);
    if (userServiceIndex != -1) {
      ServiceModel updatedService = userServices[userServiceIndex];
      
      // Create updated service model
      ServiceModel newService = ServiceModel(
        id: updatedService.id,
        perHour: updatedService.perHour,
        location: updatedService.location,
        createdBy: updatedService.createdBy,
        amount: updatedService.amount,
        serviceName: updatedService.serviceName,
        createdAt: updatedService.createdAt,
        about: updatedService.about,
        serviceImage: updatedService.serviceImage,
        advertised: updates['advertised'] ?? updatedService.advertised,
        advertisedFrom: updates['advertised_from'] != null 
            ? DateTime.parse(updates['advertised_from']) 
            : updatedService.advertisedFrom,
        advertisedTill: updates['advertised_till'] != null 
            ? DateTime.parse(updates['advertised_till']) 
            : updatedService.advertisedTill,
      );
      
      // Update the service in userServices
      userServices[userServiceIndex] = newService;
      
      // Move service between lists based on advertisement status
      if (newService.advertised == true) {
        // Remove from general services if it exists there
        generalServices.removeWhere((service) => service.id == serviceId);
        
        // Add to advertised services if not already there
        if (!advertisedServices.any((service) => service.id == serviceId)) {
          advertisedServices.add(newService);
        } else {
          // Update existing advertised service
          int advertisedIndex = advertisedServices.indexWhere((service) => service.id == serviceId);
          if (advertisedIndex != -1) {
            advertisedServices[advertisedIndex] = newService;
          }
        }
      } else {
        // Remove from advertised services if it exists there
        advertisedServices.removeWhere((service) => service.id == serviceId);
        
        // Add to general services if not already there
        if (!generalServices.any((service) => service.id == serviceId)) {
          generalServices.add(newService);
        } else {
          // Update existing general service
          int generalIndex = generalServices.indexWhere((service) => service.id == serviceId);
          if (generalIndex != -1) {
            generalServices[generalIndex] = newService;
          }
        }
      }
      
      log("Local service model updated for service: $serviceId");
    }
  } catch (e) {
    log("Error updating local service model: $e");
  }
}
  void _refreshServicesStream() {
    // Force refresh by restarting the stream
    streamServices();
  }

advertiseTheService({
  required ServiceModel serviceModel,
  required BuildContext context
}) async {
  try {
    DateTime now = DateTime.now();
    DateTime advertisedTill = DateTime(now.year, now.month, now.day + 7);

    DialogService.instance.showProgressDialog(context: context);
    
    bool isUpdated = await SupabaseCRUDService.instance.updateDocument(
      tableName: SupabaseConstants().serviceTable,
      id: serviceModel.id ?? '',
      data: {
        'advertised': true,
        'advertised_from': now.toIso8601String(),
        'advertised_till': advertisedTill.toIso8601String(),
      }
    );
    
    DialogService.instance.hideProgressDialog(context: context);
    
    if (isUpdated) {
      // Update the local service model immediately for instant UI feedback
      _updateLocalServiceModel(serviceModel.id!, {
        'advertised': true,
        'advertised_from': now.toIso8601String(),
        'advertised_till': advertisedTill.toIso8601String(),
      });
      
      Get.close(2);
      
      // Small delay to ensure UI updates
      await Future.delayed(Duration(milliseconds: 100));
      
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Success", 
        message: "Service Advertised Successfully"
      );
      
      // Force refresh to ensure consistency with database
      _refreshServicesStream();
    } else {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Failed", 
        message: "Failed to advertise service"
      );
    }
  } catch (e) {
    DialogService.instance.hideProgressDialog(context: context);
    log('Error advertising service: $e');
    CustomSnackBars.instance.showFailureSnackbar(
      title: "Error", 
      message: "An error occurred while advertising service"
    );
  }
}
  // Method to manually refresh services if needed
  void refreshServices() {
    _refreshServicesStream();
  }
}