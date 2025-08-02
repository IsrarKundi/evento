import 'dart:developer';

import 'package:event_connect/controllers/suppierControllers/add_service_controller.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/enums/user_role.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supabase_storage_service.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  RxString imagePath = ''.obs;
  RxString profileImageUrl = dummyProfileUrl.obs;

  RxInt currentIndex = 1.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = userModelGlobal.value?.fullName ?? "";
    emailController.text = userModelGlobal.value?.email ?? "";
    phoneNoController.text = userModelGlobal.value?.completePhoneNo ?? "";
    languageController.text = userModelGlobal.value?.language ?? "";
    locationController.text = userModelGlobal.value?.location ?? "";
    profileImageUrl.value =
        userModelGlobal.value?.profileImage ?? dummyProfileUrl;
    bioController.text = userModelGlobal.value?.bio ?? "";


    ever(
      userModelGlobal,
      (userModel) {
        print("ever called = ${userModel?.toJson()}");
        nameController.text = userModel?.fullName ?? "";
        emailController.text = userModel?.email ?? "";
        phoneNoController.text = userModel?.completePhoneNo ?? "";
        languageController.text = userModel?.language ?? "";
        locationController.text = userModel?.location ?? "";
        profileImageUrl.value =
            userModel?.profileImage ?? dummyProfileUrl;
        bioController.text = userModel?.bio ?? "";

        if(userModelGlobal.value?.userType!=UserRole.user.name){



          if (Get.find<AddServiceController>().userServices.isNotEmpty) {
            currentIndex.value = 4;
          } else if (((userModelGlobal.value?.completePhoneNo ?? "")
              .isNotEmpty) &&
              (userModelGlobal.value?.bio ?? "").isNotEmpty) {
            currentIndex.value = 3;
          } else if (((userModelGlobal.value?.completePhoneNo ?? "")
              .isNotEmpty) ||
              (userModelGlobal.value?.bio ?? "").isNotEmpty) {
            currentIndex.value = 2;
          }

        }



      },
    );


    log("userModelGlobal.value? =${userModelGlobal.value?.toJson()}\n bool = ${(((userModelGlobal.value?.completePhoneNo ?? "").isNotEmpty) && (userModelGlobal.value?.bio ?? "").isNotEmpty)}");

  }

  selectImage({bool isCamera = false}) async {
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

  addProfile({required BuildContext context}) async {
    DialogService.instance.showProgressDialog(context: context);
    if (imagePath.isNotEmpty) {
      await SupabaseStorageService.instance.deleteStorageFolder(
          folderPath: userModelGlobal.value?.id ?? "", bucket: "profile");

      String? imageUrl = await SupabaseStorageService.instance
          .uploadSingleImage(
              imgFilePath: imagePath.value,
              storageRef: "profile",
              storagePath: userModelGlobal.value?.id ?? "profileImages");

      profileImageUrl.value = imageUrl ?? dummyProfileUrl;
      log("addProfile = $imageUrl");
    }

    log("userModelGlobal.value?.id add profile = ${userModelGlobal.value?.id}");

    bool isUpdated = await SupabaseCRUDService.instance.updateDocument(
        tableName: SupabaseConstants().usersTable,
        id: userModelGlobal.value?.id ?? "",
        data: {
          "language": languageController.text,
          "complete_phone_no": phoneNoController.text,
          "location": locationController.text,
          "full_name": nameController.text,
          'profile_image': profileImageUrl.value,
        });

    DialogService.instance.hideProgressDialog(context: context);
    if (isUpdated) {
      Get.back();
      CustomSnackBars.instance
          .showSuccessSnackbar(title: "Success", message: "Profile Added");
    }
  }

  addBio() async {
    BuildContext context = globalNavKey.currentState!.context;

    DialogService.instance.showProgressDialog(context: context);
    bool isDocUpdated = await SupabaseCRUDService.instance.updateDocument(
        tableName: SupabaseConstants().usersTable,
        id: SupabaseCRUDService.instance.getCurrentUser()?.id ?? "",
        data: {"bio": bioController.text});
    DialogService.instance.hideProgressDialog(context: context);
    FocusScope.of(context).unfocus();
    if (isDocUpdated) {

      Get.close(1);
      await Future.delayed(Duration(milliseconds: 100));
      CustomSnackBars.instance
          .showSuccessSnackbar(title: "Success", message: "Bio Added");
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    locationController.dispose();
    languageController.dispose();
    bioController.dispose();
  }
}
