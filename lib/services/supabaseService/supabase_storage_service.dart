import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_constants.dart';
import '../snackbar_service/snackbar.dart';

class SupabaseStorageService extends SupabaseConstants {
  // Private constructor
  SupabaseStorageService._privateConstructor();

  // Singleton instance variable
  static SupabaseStorageService? _instance;

  // This code ensures that the singleton instance is created only when it's accessed for the first time.
  // Subsequent calls to SupabaseStorageService.instance will return the same instance.
  static SupabaseStorageService get instance {
    _instance ??= SupabaseStorageService._privateConstructor();
    return _instance!;
  }

  // Method to upload a single image to Supabase Storage
  Future<String?> uploadSingleImage({
    required String imgFilePath,
    String storageRef = "profile",
    String storagePath = "profileImages",
  }) async {
    try {

      int timeNow = DateTime.now().millisecondsSinceEpoch;
      final filePath = path.basename(imgFilePath);
      final storage = Supabase.instance.client.storage.from(storageRef);
      final file = File(imgFilePath);

      // Check if file exists
      if (!file.existsSync()) {
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Upload Failed",
          message: "File does not exist at path: $imgFilePath",
        );
        return null;
      }

      // Check file size (Limit: 10MB)
      final fileSize = await file.length();
      if (fileSize > 10 * 1024 * 1024) {
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Upload Failed",
          message: "File size exceeds 10MB. Please upload a smaller file.",
        );
        return null;
      }


      // Upload file
      await storage
          // .upload('$storagePath/${DateTime.now().millisecondsSinceEpoch}_$filePath', file)
          .upload('$storagePath/${timeNow}/$filePath', file)
          .timeout(const Duration(seconds: 60), onTimeout: () {

        throw TimeoutException("Upload took too long. Please try again.");
      });

      // Get public URL
      final publicUrl = storage.getPublicUrl('$storagePath/${timeNow}/$filePath');
      log("publicUrl = ${publicUrl}");
      // Show success snackbar
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Upload Successful",
        message: "Your image has been uploaded successfully.",
      );

      return publicUrl;
    } catch (e) {
      log("Error in uploadSingleImage: $e");

      String errorMessage = "Something went wrong. Please try again.";

      if (e is TimeoutException) {
        errorMessage = "Upload timed out. Please check your internet connection.";
      } else if (e.toString().contains("403")) {
        errorMessage = "You don't have permission to upload files.";
      } else if (e.toString().contains("StorageException")) {
        errorMessage = "Storage error occurred while uploading.";
      }

      // Show failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Upload Failed",
        message: errorMessage,
      );

      return null;
    }
  }

  Future<void> deleteStorageFolder({
    required String bucket,
    required String folderPath,
  }) async {
    final storage = Supabase.instance.client.storage.from(bucket);

    // List all files in the folder
    final files = await storage.list(path: folderPath);

    // Get all file paths
    final filePaths = files.map((file) => "$folderPath/${file.name}").toList();

    // Delete files if any
    if (filePaths.isNotEmpty) {
      final result = await storage.remove(filePaths);
      log("Deleted ${result.length} files from $folderPath");
    } else {
      log("No files found in $folderPath to delete.");
    }
  }


  Future<String?> uploadAssetToSupabase(String assetPath) async {

    final Uint8List imageData = await getAssetImageAsBytes(assetPath);

    final String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      await supabase.storage.from('profile_images').uploadBinary(
        fileName,
        imageData,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      // Get Public URL
      final publicUrl = supabase.storage.from('profile_images').getPublicUrl(fileName);
      print("Uploaded Successfully: $publicUrl");

      return publicUrl;
    } catch (error) {
      print("Upload Failed: $error");
      return null;
    }
  }
  // Method to upload multiple images to Supabase Storage
  Future<List<String>> uploadMultipleImages({
    required List<String> imagesPaths,
    String storageRef = "images",
  }) async {
    try {
      final storage = Supabase.instance.client.storage.from(storageRef);

      final futureList = imagesPaths.map((element) async {
        final filePath = path.basename(element);

        await storage
            .upload(filePath, File(element),
            fileOptions: FileOptions(upsert: true))
            .timeout(Duration(seconds: 30));

        final publicUrl = storage.getPublicUrl(filePath);
        return publicUrl;
      }).toList();

      final downloadURLs = await Future.wait(futureList);
      return downloadURLs;
    } catch (e) {
      Get.back();
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return [];
    }
  }

  // Method to delete a file from Supabase Storage
  Future<void> deleteFileFromStorage(String fileUrl, String storageRef) async {
    try {
      final fileName = path.basename(fileUrl); // Extract file name from URL
      final storage = Supabase.instance.client.storage.from(storageRef);

      await storage.remove([fileName]);
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
    }
  }

  Future<Uint8List> getAssetImageAsBytes(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  // Method to upload category gallery media (images/videos)
  Future<String?> uploadCategoryGalleryMedia({
    required String filePath,
    required String mediaType, // 'image' or 'video'
    String storageRef = "profile", // Use default bucket
  }) async {
    try {
      int timeNow = DateTime.now().millisecondsSinceEpoch;
      final fileName = path.basename(filePath);
      final storage = Supabase.instance.client.storage.from(storageRef);
      final file = File(filePath);

      // Check if file exists
      if (!file.existsSync()) {
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Upload Failed",
          message: "File does not exist at path: $filePath",
        );
        return null;
      }

      // Check file size (Limit: 50MB for videos, 10MB for images)
      final fileSize = await file.length();
      final sizeLimit = mediaType == 'video' ? 50 * 1024 * 1024 : 10 * 1024 * 1024;
      
      if (fileSize > sizeLimit) {
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Upload Failed",
          message: "File size exceeds ${mediaType == 'video' ? '50MB' : '10MB'}. Please upload a smaller file.",
        );
        return null;
      }

      // Upload file with media type in path for category gallery
      final uploadPath = 'category_gallery/$mediaType/${timeNow}/$fileName';
      await storage
          .upload(uploadPath, file)
          .timeout(const Duration(seconds: 120), onTimeout: () {
        throw TimeoutException("Upload took too long. Please try again.");
      });

      // Get public URL
      final publicUrl = storage.getPublicUrl(uploadPath);
      log("Category gallery media uploaded: $publicUrl");

      // Show success snackbar
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Upload Successful",
        message: "Your ${mediaType} has been uploaded successfully.",
      );

      return publicUrl;
    } catch (e) {
      log("Error in uploadCategoryGalleryMedia: $e");

      String errorMessage = "Something went wrong. Please try again.";

      if (e is TimeoutException) {
        errorMessage = "Upload timed out. Please check your internet connection.";
      } else if (e.toString().contains("403")) {
        errorMessage = "You don't have permission to upload files.";
      } else if (e.toString().contains("StorageException")) {
        errorMessage = "Storage error occurred while uploading.";
      }

      CustomSnackBars.instance.showFailureSnackbar(
        title: "Upload Failed",
        message: errorMessage,
      );

      return null;
    }
  }
}