import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../views/widget/custom_dialog_widget.dart';
import '../../views/widget/my_button.dart';
import '../../views/widget/my_text_widget.dart';




class DialogService {
  // Private constructor
  DialogService._privateConstructor();

  // Singleton instance variable
  static DialogService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to DialogService.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static DialogService get instance {
    _instance ??= DialogService._privateConstructor();
    return _instance!;
  }



  void showProgressDialog({required BuildContext context}) {
    //showing progress indicator
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const PopScope(
            canPop: false,
            child: Center(child: CircularProgressIndicator())));
  }


  void hideProgressDialog({required BuildContext context}){
    Navigator.pop(context);

}

  quitAppDialogue({required VoidCallback onTap,required BuildContext context}) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: AppLocalizations.of(context)!.areYouSureQuitApp,
            size: 15,
            weight: FontWeight.w700,
            textAlign: TextAlign.center,
            paddingTop: 32,
            paddingBottom: 16,
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyButton(
                    buttonText: AppLocalizations.of(context)!.no,
                    // bgColor: Colors.green,
                    // weight: FontWeight.w500,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MyButton(
                    buttonText: AppLocalizations.of(context)!.yes,

                    onTap: onTap,

                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //confirmation dialog
  Widget confirmationDialog(
      {required VoidCallback onConfirm, required String title,BuildContext,context}) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: title,
            size: 15,
            weight: FontWeight.w700,
            textAlign: TextAlign.center,
            paddingTop: 32,
            paddingBottom: 16,
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MyButton(
                    buttonText: AppLocalizations.of(context)!.no,
                    // bgColor:Colors.green,
                    // weight: FontWeight.w500,
                    onTap: () {
                     Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MyButton(
                    buttonText: AppLocalizations.of(context)!.yes,

                    onTap: onConfirm,

                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onYes,
    VoidCallback? onNo,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
          alignment: Alignment.center,
          title: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
          content: Text(message, textAlign: TextAlign.center),
          actions: [

            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //     if (onNo != null) onNo();
            //   },
            //   child: Text(AppLocalizations.of(context)!.no),
            // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                SizedBox(
            height: 34,
            width: 106,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                backgroundColor: Colors.green,
                elevation: 0,
                
                // side: const BorderSide(color: Colors.green, width: 1.5),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(8),
                // ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (onNo != null) onNo();
              },
              child: Text(
                AppLocalizations.of(context)!.no,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
            SizedBox(
              height: 34,
              width: 106,
              child: ElevatedButton(
                
                style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                  backgroundColor: Colors.red,
                ),
              
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onYes(); // Call the Yes action
                },
                child: Text(AppLocalizations.of(context)!.yes,style: TextStyle(color: Colors.white),),
              ),
            ),
          
            ],
          )
          ],
        );
      },
    );
  }

}
