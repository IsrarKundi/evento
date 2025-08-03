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

enum MediaType { image, video }

class MediaItem {
  final String url;
  final MediaType type;
  final String? fileName;

  MediaItem({required this.url, required this.type, this.fileName});
}

class PortfolioController extends GetxController {
  RxString imagePath = ''.obs;

  RxList<String> images = <String>[].obs;
  RxList<String> videos = <String>[].obs;
  RxList<MediaItem> allMedia = <MediaItem>[].obs;
  
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
      videos.value = portfolioModel.value?.videos ?? [];
      
      _updateAllMediaList();
    }
  }

  void _updateAllMediaList() {
    allMedia.clear();
    
    // Add images
    for (String imageUrl in images) {
      allMedia.add(MediaItem(url: imageUrl, type: MediaType.image));
    }
    
    // Add videos
    for (String videoUrl in videos) {
      allMedia.add(MediaItem(url: videoUrl, type: MediaType.video));
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
      await _uploadAndSaveMedia(file.path, MediaType.image);
    }
  }

  pickVideo({bool isCamera = true}) async {
    Get.back();
    XFile? file;

    if (isCamera) {
      file = await ImagePicker().pickVideo(source: ImageSource.camera);
    } else {
      file = await ImagePicker().pickVideo(source: ImageSource.gallery);
    }

    if (file != null) {
      await _uploadAndSaveMedia(file.path, MediaType.video);
    }
  }

  Future<void> _uploadAndSaveMedia(String filePath, MediaType mediaType) async {
    DialogService.instance
        .showProgressDialog(context: globalNavKey.currentState!.context);

    String storageFolder;
    switch (mediaType) {
      case MediaType.image:
        storageFolder = "portfolio/images";
        break;
      case MediaType.video:
        storageFolder = "portfolio/videos";
        break;
    }

    String? url = await SupabaseStorageService.instance.uploadSingleImage(
        imgFilePath: filePath,
        storageRef: storageFolder,
        storagePath: userModelGlobal.value?.id ?? "");

    DialogService.instance
        .hideProgressDialog(context: globalNavKey.currentState!.context);

    if (url != null) {
      switch (mediaType) {
        case MediaType.image:
          images.add(url);
          break;
        case MediaType.video:
          videos.add(url);
          break;
      }
      
      _updateAllMediaList();
      await _savePortfolio();
    }
  }

  Future<void> _savePortfolio() async {
    Map<String, dynamic> data = {
      'images': images,
      'videos': videos,
      'updated_at': DateTime.now().toIso8601String()
    };

    if (portfolioModel.value != null) {
      await SupabaseCRUDService.instance.updateDocument(
          tableName: SupabaseConstants().portfolioTable,
          id: '${portfolioModel.value?.id ?? ""}',
          data: data);
    } else {
      await SupabaseCRUDService.instance.createDocument(
          tableName: SupabaseConstants().portfolioTable,
          data: PortfolioModel(
                  description: '',
                  createdBy: userModelGlobal.value?.id ?? "",
                  images: images,
                  videos: videos,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now())
              .toJson());
    }
  }

  void removeMedia(MediaItem mediaItem) {
    switch (mediaItem.type) {
      case MediaType.image:
        images.remove(mediaItem.url);
        break;
      case MediaType.video:
        videos.remove(mediaItem.url);
        break;
    }
    
    _updateAllMediaList();
    _savePortfolio();
  }

  bool get hasAnyMedia => images.isNotEmpty || videos.isNotEmpty;
}