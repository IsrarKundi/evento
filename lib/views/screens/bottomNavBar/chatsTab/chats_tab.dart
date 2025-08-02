import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/views/screens/bottomNavBar/chatsTab/message_Screen.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

import '../../../../controllers/chatControllers/chat_controller.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../main_packages.dart';
import '../../../../models/chatModels/chat_thread_model.dart';
import '../../../../services/supabaseService/supbase_crud_service.dart';

class ChatsTab extends StatefulWidget {
  final bool isSupplier;
  ChatsTab({super.key,  this.isSupplier=false});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  ChatController controller = Get.find<ChatController>();

  @override
  void initState() {

    super.initState();

    SupabaseCRUDService.instance.updateDocument(
        tableName: SupabaseConstants().usersTable,
        id: userModelGlobal.value?.id ?? "",
        data: {"unread_message": false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.isSupplier,
        title: MyText(text: AppLocalizations.of(context)!.chats),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 25),
            itemBuilder: (context, index) {
              ChatThreadModel chatThreadModel = controller.allChats[index];

              final currentUserId = userModelGlobal.value?.id ?? '';
              final isSender = currentUserId == chatThreadModel.senderId;
              final unreadCount = isSender
                  ? chatThreadModel.senderUnreadCount ?? 0
                  : chatThreadModel.receiverUnreadCount ?? 0;

              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                tileColor: unreadCount>0?Colors.grey.withOpacity(0.2):Colors.transparent,
                onTap: () {
                  Get.to(
                        () => MessageScreen(chatThreadModel: chatThreadModel),
                    binding: ChatBinding(),
                    arguments: chatThreadModel,
                  );
                },
                leading: CommonImageView(
                  radius: 100,
                  height: 50,
                  width: 50,
                  url: chatThreadModel.otherUserDetail?.profileImage ?? dummyProfileUrl,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        MyText(
                          text: chatThreadModel.otherUserDetail?.fullName ?? '',
                          size: 16,
                          weight: FontWeight.w400,
                        ),
                        const Spacer(),

                        if (unreadCount > 0)
                          Container(
                            height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: MyText(
                              text: unreadCount.toString(),
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    MyText(
                      text: chatThreadModel.lastMessage ?? '',
                      size: 12,
                      weight: FontWeight.w400,
                    ),
                  ],
                ),
              );

            },
            separatorBuilder: (context, index) => Divider(
                  thickness: 2,
                  color: kBorderColor,
                ),
            itemCount: controller.allChats.length),
      ),
    );
  }
}
