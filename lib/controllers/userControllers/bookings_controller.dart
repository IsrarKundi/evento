import 'dart:developer';

import 'package:event_connect/core/enums/enums.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';

import '../../core/constants/supabase_constants.dart';
import '../../core/utils/utils.dart';
import '../../services/supabaseService/supabase_auth_service.dart';
import '../../services/supabaseService/supbase_crud_service.dart';

class BookingsController extends GetxController {
  RxList<BookingModel> upcomingBookings = <BookingModel>[].obs;
  RxList<BookingModel> otherBookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllBookings();
    log("getAllBookings called");
  }

  getAllBookings() async {
    upcomingBookings.clear();
    otherBookings.clear();



    log("getCurrentUser()?.id = ${SupabaseAuthService.instance.getCurrentUser()?.id}");

    var docs = await SupabaseCRUDService.instance.readAllDocumentsWithJoin(
        fieldName: 'booked_by',
        fieldValue: SupabaseAuthService.instance.getCurrentUser()?.id ?? "",
        tableName: SupabaseConstants().bookingsTable,
        joinQuery: '''
  *,
  service_model:services!fk_bookings_service_id (*),
  user_model:users!fk_bookings_booked_by (*),
  supplier_model:users!fk_bookings_supplier_id (*)
''');
    log("Docs getAllBookings = ${docs}");

    if(docs!=null){
      for(var doc in docs){
        BookingModel bookingModel = BookingModel.fromMap(doc);

        if(bookingModel.bookingStatus==BookingStatus.upcoming.name){
          DateTime bookingDate = Utils.combineManual(bookingModel.selectedDate, bookingModel.selectedTime);


          if(bookingDate.add(Duration(minutes: 30)).isBefore(DateTime.now())) {
            await SupabaseCRUDService.instance.updateDocument(
                tableName: SupabaseConstants().bookingsTable,
                id: bookingModel.id ?? "",
                data: {
                  "booking_status": BookingStatus.completed.name
                });
            otherBookings.add(bookingModel);
            continue;
          }
          upcomingBookings.add(bookingModel);
        }else{
          otherBookings.add(bookingModel);
        }
      }
    }
  }
}
