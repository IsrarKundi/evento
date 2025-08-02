import 'package:event_connect/controllers/suppierControllers/add_service_controller.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CheckoutScreen extends StatelessWidget {

  final ServiceModel serviceModel;
   CheckoutScreen({super.key, required this.serviceModel});

  final AddServiceController controller = Get.find<AddServiceController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyText(text: AppLocalizations.of(context)!.payment),),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 30,horizontal: 24),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(text: AppLocalizations.of(context)!.checkout,size: 18,weight: FontWeight.w700,),

                MyText(text: "\$149.92",color: kPrimaryColor,weight: FontWeight.w500,size: 18,)
              ],
            ),
            Spacer(),
            MyButton(onTap: (){
              controller.advertiseTheService(serviceModel: serviceModel, context: context);

            }, buttonText: AppLocalizations.of(context)!.payForAdvertisement),
            SizedBox(height: 30,)
          ],
        ),
        ),
      ),
    );
  }
}
