import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/core/enums/user_role.dart';
import 'package:event_connect/views/screens/supplier/membership/memborship_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/main_profile_setup_screen.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utils/validators.dart';
import '../../../main_packages.dart';
import '../../widget/custom_textfield.dart';
import '../bottomNavBar/bottom_nav_screen.dart';

class SelectUserTypeScreen extends StatefulWidget {

  final bool isSocial;
  const SelectUserTypeScreen({super.key,  this.isSocial = false});

  @override
  State<SelectUserTypeScreen> createState() => _SelectUserTypeScreenState();
}

class _SelectUserTypeScreenState extends State<SelectUserTypeScreen> {
  String selectedRole = 'Supplier';
  AuthController controller = Get.find<AuthController>();

  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.selectWhatAreYou),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.areYou,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Radio<String>(
                  value: 'User',
                  groupValue: selectedRole,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.user),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Supplier',
                  groupValue: selectedRole,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.supplier),
              ],
            ),
            if(widget.isSocial==true)
              ...[
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: CustomTextField(

                    controller: controller.fullNameController,
                    validator: (value) => ValidationService.instance.emptyValidator(value, context),
                    isRequired: true,
                    labelText: AppLocalizations.of(context)!.fullName,
                    hintText: AppLocalizations.of(context)!.enterName,
                    radius: 100,
                    outlineBorderColor: kPrimaryColor,
                  ),
                )
              ],

            const Spacer(),
            MyButton(
                radius: 100,
                height: 55,
                fontColor: kBlackColor1,
                onTap: () {

                  if(widget.isSocial){
                    if(!_formKey.currentState!.validate()){
                      return;
                    }
                  }
                  if(selectedRole=="Supplier"){

                    controller.updateUserRole(userRole: UserRole.supplier,isSocial: widget.isSocial);

                  }else{
                    controller.updateUserRole(userRole: UserRole.user,isSocial: widget.isSocial);
                  }

                },
                buttonText: AppLocalizations.of(context)!.continueButton),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
