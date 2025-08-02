import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/portfolioModel/portfolio_model.dart';
import 'package:event_connect/services/supabaseService/supabase_storage_service.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioController extends GetxController {
  RxString imagePath = ''.obs;

  RxList<String> images = <String>[].obs;
  Rx<PortfolioModel?> portfolioModel = Rx<PortfolioModel?>(null);

  @override
  void onInit() {
    super.onInit();
    readPortfolio(userId: userModelGlobal.value?.id ?? '');
  }

  readPortfolio({required String userId}) async {
    List<Map<String, dynamic>>? docs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
            tableName: SupabaseConstants().portfolioTable,
            filters: {'created_by': userId});

    if (docs != null && docs.isNotEmpty) {
      portfolioModel.value = PortfolioModel.fromJson(docs.first);
      images.value = portfolioModel.value?.images ?? [];
    }
  }

  pickImage({bool isCamera = true}) async {
    Get.back();
    XFile? file;

    if (isCamera) {
      file = await ImagePickerService.instance.pickImageFromCamera();
    } else {
      file = await ImagePickerService.instance.pickSingleImageFromGallery();
    }

    if (file != null) {
      DialogService.instance
          .showProgressDialog(context: globalNavKey.currentState!.context);
      String? url = await SupabaseStorageService.instance.uploadSingleImage(
          imgFilePath: file.path,
          storageRef: "portfolio",
          storagePath: userModelGlobal.value?.id ?? "");

      DialogService.instance
          .hideProgressDialog(context: globalNavKey.currentState!.context);

      if (url != null) {
        images.add(url);
      }

      if (portfolioModel.value != null) {
        SupabaseCRUDService.instance.updateDocument(
            tableName: SupabaseConstants().portfolioTable,
            id: '${portfolioModel.value?.id??""}',
            data: {
              'images':images,
              'updated_at':DateTime.now().toIso8601String()

            });
      } else {
        SupabaseCRUDService.instance.createDocument(
            tableName: SupabaseConstants().portfolioTable,
            data: PortfolioModel(
                    description: '',
                    createdBy: userModelGlobal.value?.id ?? "",
                    images: images,
                    videos: [],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now())
                .toJson());
      }
    }
  }
}
