import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/galleryModel/category_gallery_model.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/image_view.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/portfolio_screen.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

class CategoryGalleryWidget extends StatefulWidget {
  final String categoryName;
  final double height;
  final bool showTitle;
  
  const CategoryGalleryWidget({
    super.key,
    required this.categoryName,
    this.height = 120,
    this.showTitle = true,
  });

  @override
  State<CategoryGalleryWidget> createState() => _CategoryGalleryWidgetState();
}

class _CategoryGalleryWidgetState extends State<CategoryGalleryWidget> {
  List<CategoryGalleryModel> galleryItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadGallery();
  }

  Future<void> loadGallery() async {
    try {
      final response = await SupabaseCRUDService.instance.getCategoryGallery(
        categoryName: widget.categoryName,
      );
      
      if (response != null) {
        setState(() {
          galleryItems = response
              .map((item) => CategoryGalleryModel.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showTitle && galleryItems.isEmpty && !isLoading) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Row(
            children: [
              Icon(
                Icons.photo_library,
                color: kPrimaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              MyText(
                text: "Gallery",
                size: 16,
                weight: FontWeight.w600,
                color: kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: 12),
        ],
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorderColor.withOpacity(0.5)),
            color: Colors.white,
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                    strokeWidth: 2,
                  ),
                )
              : galleryItems.isEmpty
                  ? _buildEmptyGallery()
                  : _buildGalleryContent(),
        ),
      ],
    );
  }

  Widget _buildEmptyGallery() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            color: kGreyColor1.withOpacity(0.6),
            size: 32,
          ),
          SizedBox(height: 8),
          MyText(
            text: "Gallery is empty",
            size: 14,
            color: kGreyColor1,
            textAlign: TextAlign.center,
          ),
          MyText(
            text: "No media available for this category",
            size: 12,
            color: kGreyColor1.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryContent() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemCount: galleryItems.length,
      itemBuilder: (context, index) {
        final item = galleryItems[index];
        return _buildGalleryItem(item, index);
      },
    );
  }

  Widget _buildGalleryItem(CategoryGalleryModel item, int index) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          if (item.isImage) {
            Get.to(() => ImageView(imageUrl: item.mediaUrl ?? ''));
          } else if (item.isVideo) {
            Get.to(() => VideoPlayerScreen(videoUrl: item.mediaUrl ?? ''));
          }
        },
        child: Container(
          width: 90,
          height: widget.height - 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: Stack(
            children: [
              // Media Content
              Container(
                width: 90,
                height: widget.height - 16,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: item.isImage
                    ? CommonImageView(
                        url: item.mediaUrl ?? '',
                        height: widget.height - 16,
                        width: 90,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.black87,
                        child: Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
              ),
              
              // Media Type Indicator
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    item.isImage ? Icons.image : Icons.videocam,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              
              // Gradient Overlay for better text visibility
              if (item.description != null && item.description!.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                    child: MyText(
                      text: item.description ?? '',
                      size: 10,
                      color: Colors.white,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 