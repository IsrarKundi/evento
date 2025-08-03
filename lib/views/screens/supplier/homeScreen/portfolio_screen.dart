import 'dart:developer';

import 'package:event_connect/controllers/suppierControllers/portfolio_controller.dart';
import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/image_view.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:video_player/video_player.dart';

import '../../../../controllers/suppierControllers/add_service_controller.dart';
import '../../../../core/bindings/bindings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../services/snackbar_service/snackbar.dart';
import 'home_screen.dart';

class PortfolioScreen extends StatelessWidget {
  final bool isProfileSetup;
  PortfolioScreen({super.key, this.isProfileSetup = false});

  final PortfolioController controller = Get.find<PortfolioController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.portfolio),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            // Media Display Section
            Card(
              elevation: 10,
              child: Container(
                height: 120,
                color: Colors.white,
                child: Obx(() => controller.allMedia.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.pleaseAddPortfolio,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.allMedia.length,
                        itemBuilder: (context, index) {
                          final mediaItem = controller.allMedia[index];
                          return _buildMediaItem(context, mediaItem, index);
                        },
                      )),
              ),
            ),
            SizedBox(height: 30),
            
            // Upload Options Section
            _buildUploadSection(context),
            
            Spacer(),
            
            // Next Button for Profile Setup
            if (isProfileSetup)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  onTap: () {
                    if (controller.hasAnyMedia) {
                      final ProfileSetupController profileSetupController =
                          Get.find();

                      log("profileSetupController.currentIndex.value = ${profileSetupController.currentIndex.value}");
                      SupabaseCRUDService.instance.updateDocument(
                          tableName: SupabaseConstants().usersTable,
                          id: userModelGlobal.value?.id ?? "",
                          data: {'is_profile_setup': true});
                      Get.offAll(() => const HomeScreen(),
                          binding: SupplierHomeBindings());
                    } else {
                      CustomSnackBars.instance.showInfoSnackbar(
                        title: AppLocalizations.of(context)!.pleaseAddPortfolio,
                        message: "",
                      );
                    }
                  },
                  buttonText: AppLocalizations.of(context)!.next,
                  radius: 100,
                  fontColor: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaItem(BuildContext context, MediaItem mediaItem, int index) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (mediaItem.type == MediaType.image) {
                Get.to(() => ImageView(imageUrl: mediaItem.url));
              } else if (mediaItem.type == MediaType.video) {
                Get.to(() => VideoPlayerScreen(videoUrl: mediaItem.url));
              }
            },
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: _buildMediaPreview(mediaItem),
            ),
          ),
          // Media type indicator
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _getMediaIcon(mediaItem.type),
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          // Delete button
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => controller.removeMedia(mediaItem),
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(MediaItem mediaItem) {
    switch (mediaItem.type) {
      case MediaType.image:
        return CommonImageView(
          height: 100,
          width: 100,
          url: mediaItem.url,
        );
      case MediaType.video:
        return Container(
          color: Colors.black,
          child: Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
    }
  }

  IconData _getMediaIcon(MediaType type) {
    switch (type) {
      case MediaType.image:
        return Icons.image;
      case MediaType.video:
        return Icons.videocam;
    }
  }

  Widget _buildUploadSection(BuildContext context) {
    return Column(
      children: [
        // Image Upload
        GestureDetector(
          onTap: () {
            ImagePickerService.instance.openProfilePickerBottomSheet(
              context: context,
              onCameraPick: () {
                controller.pickImage();
              },
              onGalleryPick: () {
                controller.pickImage(isCamera: false);
              },
            );
          },
          child: Container(
            height: 80,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
                color: Color(0xFFDFF6DA),
                border: DashedBorder.fromBorderSide(
                    side: BorderSide(color: kPrimaryColor), dashLength: 3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: Colors.green.shade400),
                SizedBox(width: 10),
                Text(
                  "Add Images",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Video Upload
        GestureDetector(
          onTap: () {
            _showVideoPickerBottomSheet(context);
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                border: DashedBorder.fromBorderSide(
                    side: BorderSide(color: Colors.blue), dashLength: 3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, color: Colors.blue.shade600),
                SizedBox(width: 10),
                Text(
                  "Add Videos",
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showVideoPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Video Source",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.pickVideo(isCamera: true);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.videocam,
                            size: 30,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Camera"),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.pickVideo(isCamera: false);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.video_library,
                            size: 30,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text("Gallery"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

// Video Player Screen
// Video Player Screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Video Player',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : _hasError
                ? Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error loading video',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _hasError = false;
                              });
                              _initializeVideo();
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height - 
                             MediaQuery.of(context).padding.top - 
                             kToolbarHeight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Video Player Section
                          Flexible(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                          ),
                          
                          // Controls Section
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Progress Indicator
                                  VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.blue,
                                      bufferedColor: Colors.grey,
                                      backgroundColor: Colors.white24,
                                    ),
                                  ),
                                  
                                  // Play/Pause Button
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                      });
                                    },
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 56,
                                    ),
                                  ),
                                  
                                  // Duration Text
                                  Text(
                                    '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
