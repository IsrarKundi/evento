import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/models/chatModels/chat_thread_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/widget/chatWidgets/custom_chat_buble.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/chatControllers/chat_controller.dart';
import '../../../../controllers/chatControllers/message_controller.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../main_packages.dart';
import '../../../../models/chatModels/message_model.dart';
import '../../../../models/userModel/user_model.dart';

class MessageScreen extends StatelessWidget {
  final ChatThreadModel? chatThreadModel;

  MessageScreen({super.key, this.chatThreadModel});

  final MessageController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: MyText(
          text: chatThreadModel?.otherUserDetail?.fullName ?? "",
          color: kPrimaryColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Obx(
              () => (controller.chatThread.value.block == true &&
                      controller.chatThread.value.blockBy !=
                          userModelGlobal.value?.id)
                  ? SizedBox()
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'block') {
                          DialogService.instance.showConfirmationDialog(
                            context: context,
                            title: controller.chatThread.value.block == true
                                ? AppLocalizations.of(context)!.unblock
                                : AppLocalizations.of(context)!.blockUser,
                            message:
                                "${AppLocalizations.of(context)!.doYouWantTo} ${controller.chatThread.value.block == true ? AppLocalizations.of(context)!.unblock : AppLocalizations.of(context)!.block} ${chatThreadModel?.otherUserDetail?.fullName}",
                            onYes: () async {
                              if (controller.chatThread.value.block == false) {
                                log("chatThreadModel?.block==true called");

                                DialogService.instance
                                    .showProgressDialog(context: context);

                                await SupabaseCRUDService.instance
                                    .updateDocument(
                                        tableName: SupabaseCRUDService
                                            .instance.chatThreadsTable,
                                        id: controller.chatThread.value.id ??
                                            "",
                                        data: {
                                      "block": true,
                                      "block_by":
                                          userModelGlobal.value?.id ?? ''
                                    });

                                DialogService.instance
                                    .hideProgressDialog(context: context);
                              } else {
                                log("chatThreadModel?.block==true called");

                                DialogService.instance
                                    .showProgressDialog(context: context);
                                await SupabaseCRUDService.instance
                                    .updateDocument(
                                        tableName: SupabaseCRUDService
                                            .instance.chatThreadsTable,
                                        id: controller.chatThread.value.id ??
                                            "",
                                        data: {
                                      "block": false,
                                      "block_by": null
                                    });

                                DialogService.instance
                                    .hideProgressDialog(context: context);
                              }
                            },
                          );
                        }else if(value == "delete"){

                          DialogService.instance.showConfirmationDialog(context: context, title: AppLocalizations.of(context)!.deleteChat, message: AppLocalizations.of(context)!.doYouWantDeleteChat, onYes: () async {
                            DialogService.instance.showProgressDialog(context: context);
                            await SupabaseCRUDService.instance.deleteDocument(tableName: SupabaseConstants().chatThreadsTable, id: chatThreadModel?.id??'');
                            DialogService.instance.hideProgressDialog(context: context);
                            Get.find<ChatController>().allChats.removeWhere((element) => chatThreadModel!.id==element.id,);
                            Get.close(1);
                            await Future.delayed(Duration(milliseconds: 100));
                            CustomSnackBars.instance.showSuccessSnackbar(title: AppLocalizations.of(context)!.success, message: AppLocalizations.of(context)!.chatDeletedSuccessfully);
                            },);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'block',
                            child: Row(
                              children: [
                                Icon(Icons.block, color: Colors.red),
                                SizedBox(width: 10),
                                Obx(() => Text(
                                    controller.chatThread.value.block == true
                                        ? AppLocalizations.of(context)!.unblock
                                        : AppLocalizations.of(context)!.block)),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 10),
                                Text(AppLocalizations.of(context)!.deleteChat),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
            ),
          ),
        ],
        bottom:
            PreferredSize(preferredSize: Size.fromHeight(5), child: Divider()),
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 25),
        child: Column(children: [
          Obx(
            () => Expanded(
                child: controller.messages.isEmpty
                    ? Center(
                        child: MyText(
                          text: AppLocalizations.of(context)!.noMessagesYet,
                          color: Colors.grey,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          MessageModel message = controller.messages[index];
                          UserModel? otherUser =
                              chatThreadModel?.otherUserDetail;

                          return ChatBubble(
                            messageType: message.messageType,
                            isSender:
                                message.senderId == userModelGlobal.value?.id,
                            msg: message.message ?? "",
                            name: otherUser?.fullName ?? '',
                            isTime: true,
                            time: Utils.formatDateAndTime(message.sentAt, context),
                            receiverImg: chatThreadModel
                                    ?.otherUserDetail?.profileImage ??
                                dummyProfileUrl,
                          );
                        },
                      )),
          ),
          Obx(
            () => controller.chatThread.value.block == true
                ? Container(
                    height: 50,
                    child: Center(
                      child: MyText(
                        text: AppLocalizations.of(context)!.blocked,
                        color: Colors.red,
                        weight: FontWeight.w700,
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              ImagePickerService.instance
                                  .openProfilePickerBottomSheet(
                                context: context,
                                onCameraPick: () {
                                  controller.selectImage(context: context);
                                },
                                onGalleryPick: () {
                                  controller.selectImage(
                                      context: context, isCamera: false);
                                },
                              );
                            },
                            child: Icon(Icons.add)),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            child: CustomTextField(
                              controller: controller.messageController,
                              hintText: AppLocalizations.of(context)!.typeMessage,
                              top: 10,
                              bottom: 0,
                              isUseLebelText: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.messageController.text.isNotEmpty) {
                              Uuid uuid = Uuid();

                              MessageModel messageModel = MessageModel(
                                  message: controller.messageController.text,
                                  id: uuid.v4(),
                                  chatThreadId: chatThreadModel?.id ?? '',
                                  senderId: userModelGlobal.value?.id ?? '',
                                  sentAt: DateTime.now());

                              controller.sendMessage(
                                  messageModel: messageModel);
                              controller.messageController.clear();
                            }
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: kPrimaryColor),
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ]),
      ),


    );
  }
}
