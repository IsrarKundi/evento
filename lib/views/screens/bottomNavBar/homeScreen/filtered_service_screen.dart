import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';

import '../../../../controllers/userControllers/user_home_controller.dart';
import '../../../widget/bookingCards/booking_card.dart';
import '../../categoryScreens/category_detail_screen.dart';

class FilteredServiceScreen extends StatelessWidget {
  final List<ServiceModel> filteredServices;

   FilteredServiceScreen({super.key, required this.filteredServices});

  UserHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Services"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
        child: ListView.builder(

          itemCount: controller.filteredServices.length,
          itemBuilder: (context, index) {
            ServiceModel serviceModel = controller.filteredServices[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => CategoryDetailScreen(
                  serviceModel: serviceModel));
            },
            child: buildBookingCard(
                isPerhour: serviceModel.perHour??false,
                showBook: false,
                title: "${serviceModel.serviceName}",
                context: context,
                location:
                serviceModel.location ?? "",
                url: serviceModel.serviceImage,
                price: serviceModel.amount ?? ""),
          );
        },),
      ),
    );
  }
}
