import 'dart:io';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/utils/app_lists.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supabase_storage_service.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:file_picker/file_picker.dart';

class CategoryGalleryUploadScreen extends StatefulWidget {
  const CategoryGalleryUploadScreen({super.key});

  @override
  State<CategoryGalleryUploadScreen> createState() => _CategoryGalleryUploadScreenState();
}

class _CategoryGalleryUploadScreenState extends State<CategoryGalleryUploadScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  String? _selectedFilePath;
  String? _selectedMediaType;
  bool _isUploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      ImagePickerService.instance.openProfilePickerBottomSheet(
        context: context,
        onCameraPick: () async {
          final file = await ImagePickerService.instance.pickImageFromCamera();
          if (file != null) {
            setState(() {
              _selectedFilePath = file.path;
              _selectedMediaType = 'image';
            });
          }
        },
        onGalleryPick: () async {
          final file = await ImagePickerService.instance.pickSingleImageFromGallery();
          if (file != null) {
            setState(() {
              _selectedFilePath = file.path;
              _selectedMediaType = 'image';
            });
          }
        },
      );
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Failed to pick image: $e"
      );
    }
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFilePath = result.files.single.path!;
          _selectedMediaType = 'video';
        });
      }
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Failed to pick video: $e"
      );
    }
  }

  Future<void> _uploadMedia() async {
    if (_selectedCategory == null) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Please select a category"
      );
      return;
    }

    if (_selectedFilePath == null || _selectedMediaType == null) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Please select a file"
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    DialogService.instance.showProgressDialog(context: context);

    try {
      // Upload media to storage
      final mediaUrl = await SupabaseStorageService.instance.uploadCategoryGalleryMedia(
        filePath: _selectedFilePath!,
        mediaType: _selectedMediaType!,
      );

      if (mediaUrl != null) {
        // Save to database
        final success = await SupabaseCRUDService.instance.addCategoryGalleryItem(
          categoryName: _selectedCategory!,
          mediaUrl: mediaUrl,
          mediaType: _selectedMediaType!,
          description: _descriptionController.text.trim().isEmpty 
              ? null 
              : _descriptionController.text.trim(),
        );

        if (success) {
          // Clear form
          setState(() {
            _selectedCategory = null;
            _selectedFilePath = null;
            _selectedMediaType = null;
          });
          _descriptionController.clear();

          CustomSnackBars.instance.showSuccessSnackbar(
            title: "Success", 
            message: "Media uploaded successfully!"
          );
        }
      }
    } catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error", 
        message: "Upload failed: $e"
      );
    } finally {
      DialogService.instance.hideProgressDialog(context: context);
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: "Upload Category Gallery",
          size: 18,
          weight: FontWeight.w600,
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Message
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 12),
                  Expanded(
                    child: MyText(
                      text: "This is a test screen for uploading gallery content. Remove this screen after testing.",
                      size: 14,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Category Selection
            MyText(
              text: "Select Category *",
              size: 16,
              weight: FontWeight.w600,
              color: kPrimaryColor,
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: kBorderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  hint: MyText(text: "Choose a category", color: kGreyColor1),
                  isExpanded: true,
                  items: services.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: MyText(text: category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),

            // File Selection
            MyText(
              text: "Select Media *",
              size: 16,
              weight: FontWeight.w600,
              color: kPrimaryColor,
            ),
            SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedMediaType == 'image' 
                              ? kPrimaryColor 
                              : kBorderColor,
                          width: _selectedMediaType == 'image' ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: kPrimaryColor,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          MyText(
                            text: "Pick Image",
                            size: 14,
                            weight: FontWeight.w500,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickVideo,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedMediaType == 'video' 
                              ? Colors.blue 
                              : kBorderColor,
                          width: _selectedMediaType == 'video' ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam,
                            color: Colors.blue,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          MyText(
                            text: "Pick Video",
                            size: 14,
                            weight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Selected File Display
            if (_selectedFilePath != null) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kGreyColor2.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _selectedMediaType == 'image' ? Icons.image : Icons.videocam,
                      color: _selectedMediaType == 'image' ? kPrimaryColor : Colors.blue,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: MyText(
                        text: "Selected: ${File(_selectedFilePath!).path.split('/').last}",
                        size: 14,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilePath = null;
                          _selectedMediaType = null;
                        });
                      },
                      child: Icon(Icons.close, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24),

            // Description Field
            CustomTextField(
              controller: _descriptionController,
              labelText: "Description (Optional)",
              hintText: "Enter media description...",
              height: 100,
              radius: 12,
            ),
            SizedBox(height: 32),

            // Upload Button
            MyButton(
              onTap: _isUploading ? () {} : () => _uploadMedia(),
              buttonText: _isUploading ? "Uploading..." : "Upload Media",
              radius: 12,
              backgroundColor: kPrimaryColor,
              isLoading: _isUploading,
            ),
          ],
        ),
      ),
    );
  }
} 