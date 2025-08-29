import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

class ReportDialog extends StatefulWidget {
  final String serviceId;
  
  const ReportDialog({
    super.key,
    required this.serviceId,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _reportController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    if (userModelGlobal.value?.id == null) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "User not logged in",
      );
      return;
    }

    DialogService.instance.showProgressDialog(context: context);

    try {
      bool success = await SupabaseCRUDService.instance.createReport(
        reportedBy: userModelGlobal.value!.id!,
        reportedService: widget.serviceId,
        reportNote: _reportController.text.trim(),
      );

      DialogService.instance.hideProgressDialog(context: context);

      if (success) {
        CustomSnackBars.instance.showSuccessSnackbar(
          title: AppLocalizations.of(context)?.success ?? "Success",
          message: "Report submitted successfully",
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      DialogService.instance.hideProgressDialog(context: context);
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Failed to submit report",
      );
    }
  }

    @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: isKeyboardVisible ? 20 : 60,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: isKeyboardVisible 
            ? MediaQuery.of(context).size.height * 0.6
            : MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              kGreyColor2.withOpacity(0.1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon and title
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.report_problem,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: MyText(
                          text: "Report Service",
                          size: 20,
                          weight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: kGreyColor2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18,
                            color: kGreyColor1,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Description text
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: kPrimaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: kPrimaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: MyText(
                          text: "Please describe why you're reporting this service. Your report will help us maintain a safe and reliable platform for all users.",
                          size: 14,
                          color: kGreyColor1,
                          lineHeight: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Text field with better styling
                CustomTextField(
                  controller: _reportController,
                  labelText: "Report Reason",
                  hintText: "Enter your reason for reporting...",
                  height: isKeyboardVisible ? 80 : 120,
                  radius: 12,
                  backgroundColor: kGreyColor2.withOpacity(0.3),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a reason for reporting";
                    }
                    if (value.trim().length < 10) {
                      return "Reason must be at least 10 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                
                // Buttons with better styling
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyButton(
                        onTap: () => Navigator.of(context).pop(),
                        buttonText: "Cancel",
                        backgroundColor: kGreyColor2,
                        fontColor: kBlackColor1,
                        radius: 12,
                        height: 48,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.red.shade700,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: MyButton(
                          onTap: _submitReport,
                          buttonText: "Submit Report",
                          backgroundColor: Colors.transparent,
                          fontColor: Colors.white,
                          radius: 12,
                          height: 48,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 