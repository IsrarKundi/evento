import 'dart:developer';

import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/enums/enums.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';
import 'package:event_connect/services/supabaseService/supabase_auth_service.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';

class AppointmentsController extends GetxController {

  RxList<BookingModel> allAppointments = <BookingModel>[].obs;
  RxList<BookingModel> upcomingAppointments = <BookingModel>[].obs;
  RxList<BookingModel> completedAppointments = <BookingModel>[].obs;
  RxList<BookingModel> cancelAppointments = <BookingModel>[].obs;


  @override
  void onInit() {
    getAllAppointments();
    super.onInit();
  }

  getAllAppointments() async {
    var docs = await SupabaseCRUDService.instance.readAllDocumentsWithJoin(
      fieldName: 'supplier_id',
        fieldValue: SupabaseAuthService.instance.getCurrentUser()?.id??"",
        tableName: SupabaseConstants().bookingsTable, joinQuery: '* , user_model:users(*),service_model:services!fk_bookings_service_id(*)');
  log("Docs getAllAppointments = ${docs}");

  if(docs!=null){

    for(var doc in docs){
      BookingModel bookingModel = BookingModel.fromMap(doc);
      allAppointments.add(bookingModel);


      DateTime bookingDate = Utils.combineManual(bookingModel.selectedDate, bookingModel.selectedTime);


      if(bookingDate.add(Duration(minutes: 30)).isBefore(DateTime.now())){

        await SupabaseCRUDService.instance.updateDocument(tableName: SupabaseConstants().bookingsTable, id: bookingModel.id??"", data: {
          "booking_status":BookingStatus.completed.name
        });
        completedAppointments.add(bookingModel);
        continue;
      }
      if(bookingModel.bookingStatus==BookingStatus.upcoming.name){
        upcomingAppointments.add(bookingModel);
      }else if(bookingModel.bookingStatus==BookingStatus.completed.name){
        completedAppointments.add(bookingModel);
      }else if(bookingModel.bookingStatus==BookingStatus.cancel.name){
        cancelAppointments.add(bookingModel);
      }
    }
  }



  }
}
