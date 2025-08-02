import 'package:event_connect/core/utils/localization_helper.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';

import '../../../main_packages.dart';

Widget buildBookingCard({
  required bool isPerhour,
   String? imagePath,
  String? url,
  String price = "50",
  bool showBook = true,
  bool showChat = false,
  Function()? onBookTap,
  Function()? onChatTap,
  required String title,
  required String location,
required  context,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child:
          imagePath!=null?

          Image.asset(
            imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ):CommonImageView(

            url: url,
            height: 100,
            width: 100,
            fit: BoxFit.cover,

          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                    LocalizationHelper.getLocalizedServiceName(context, title),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    if(showChat)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                          onTap: onChatTap,
                          child: Icon(Icons.chat,color: kPrimaryColor,)),
                    ),


                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                 Row(
                  children: [
                    // const Icon(Icons.star, color: Colors.orange, size: 16),
                    // const Icon(Icons.star, color: Colors.orange, size: 16),
                    // const Icon(Icons.star, color: Colors.orange, size: 16),
                    // const Icon(Icons.star, color: Colors.orange, size: 16),
                    // const Icon(Icons.star_half, color: Colors.orange, size: 16),
                    //
                    const SizedBox(width: 8),
                    Text(
                      "${price} LEI${isPerhour?"/hr":""} ",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if(showBook)
                    GestureDetector(
                      onTap: onBookTap,
                      child: const Text(
                        "Book Again",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}
