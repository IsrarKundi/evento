import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/controllers/categoryControllers/category_controller.dart';
import 'package:event_connect/controllers/categoryControllers/schedule_booking_controller.dart';
import 'package:event_connect/controllers/notificationsController/notification_controller.dart';
import 'package:event_connect/controllers/suppierControllers/add_service_controller.dart';
import 'package:event_connect/controllers/suppierControllers/appointments_controller.dart';
import 'package:event_connect/controllers/suppierControllers/portfolio_controller.dart';
import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/controllers/userControllers/bookings_controller.dart';
import 'package:event_connect/controllers/userControllers/user_home_controller.dart';
import 'package:event_connect/main_packages.dart';

import '../../controllers/chatControllers/chat_controller.dart';
import '../../controllers/chatControllers/message_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController());
  }
}

class ProfileSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddServiceController());
    Get.put<ProfileSetupController>(ProfileSetupController());


  }
}

class CategoryBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<CategoryController>(CategoryController());
  }
}

class ScheduleBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ScheduleBookingController>(ScheduleBookingController());
  }
}

class UserHomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ProfileSetupController>(ProfileSetupController());

    Get.put(BookingsController());
    Get.put(UserHomeController());
    Get.lazyPut(() => ChatController());
  }
}

class SupplierHomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AddServiceController());
    Get.put<ProfileSetupController>(ProfileSetupController());


    Get.put(ChatController());
  }
}

class AppointmentsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppointmentsController());
  }
}

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageController());
  }
}


class PortfolioBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(PortfolioController());
  }

}


class NotificationsBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<NotificationController>(NotificationController());
  }

}
