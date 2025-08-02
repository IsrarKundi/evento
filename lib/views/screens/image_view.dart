import 'package:event_connect/main_packages.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  const ImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ""),
      body: Container(
        height: Get.height,
        width: Get.width,
        child: CommonImageView(
          fit: BoxFit.contain,
          url: imageUrl,
        ),
      ),
    );
  }
}
