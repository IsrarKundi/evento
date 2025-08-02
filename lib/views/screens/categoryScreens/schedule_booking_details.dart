import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/views/widget/bookingCards/booking_card.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../controllers/categoryControllers/schedule_booking_controller.dart';
import '../../../main_packages.dart';
import '../../widget/my_button.dart';

class ScheduleBookingDetails extends StatelessWidget {
  final ServiceModel serviceModel;

  final String date,time;

   ScheduleBookingDetails({super.key, required this.serviceModel, required this.date, required this.time});
  final ScheduleBookingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    print("time here ${time}");
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBookingCard(
              isPerhour: serviceModel.perHour??false,
              context: context,
                title: serviceModel.serviceName ?? "", location: serviceModel.location??"",
            url: serviceModel.serviceImage??dummyProfileUrl,showBook: false,price: serviceModel.amount??"0",
            ),
            SizedBox(height: 30,),
            MyText(text: AppLocalizations.of(context)!.bookingDateTime,weight: FontWeight.w700,size: 18,),
            SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kGreyColor3.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  ListTile(
                     leading: MyText(text: AppLocalizations.of(context)!.date,weight: FontWeight.w600,size: 16,),
                     trailing: MyText(text: "$date",weight: FontWeight.w600,),

                  ),

                  ListTile(
                    leading: MyText(text: AppLocalizations.of(context)!.time,weight: FontWeight.w600,size: 16,),
                    trailing: MyText(text:   Utils.convertTo24Hour(time),weight: FontWeight.w600,),

                  ),
                ],
              ),
            ),
            Spacer(),
            MyButton(
                radius: 100,
                onTap: () {
                  controller.checkBooking(context: context);
                },
                buttonText: AppLocalizations.of(context)!.scheduleBooking)

          ],
        ),
      ),
    );
  }
}
