import 'dart:async';
import 'dart:developer';

import 'package:event_connect/services/supabaseService/supabase_auth_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../models/userModel/user_model.dart';
import '../snackbar_service/snackbar.dart';

class SupabaseCRUDService extends SupabaseAuthService {
  // Private constructor
  SupabaseCRUDService._privateConstructor() : super.protected();

  // Singleton instance
  static SupabaseCRUDService? _instance;

  // Getter to access the singleton instance
  static SupabaseCRUDService get instance {
    _instance ??= SupabaseCRUDService._privateConstructor();
    return _instance!;
  }

  /// Create Document
  Future<bool> createDocument({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await supabase.from(tableName).insert(data);
      log("Document created successfully: $response");
      return true;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      log("PostgrestException: $e");
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Read Single Document by ID
  Future<Map<String, dynamic>?> readSingleDocument({
    required String tableName,
    required String id,
  }) async {
    try {
      final response =
          await supabase.from(tableName).select().eq('id', id).maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return null;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return null;
    }
  }

  getUserDataStream({required String userId}) async {
    log("getUserDataStream called $userId");

    userStreamSubscription = supabase
        .from(usersTable)
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .listen((data) {
          log("data userModel = ${data.first}");
          if (data.isNotEmpty) {
            log("data.isNotEmpty");
            UserModel userModel = UserModel.fromJson(data.first);
            userModelGlobal.value = userModel;
            log('userModelGlobal in stream:${userModelGlobal.value?.toJson()}');
          } else {
            userModelGlobal.value = null;
          }
        });
  }

  void stopUserStream() {
    userStreamSubscription.cancel();
  }

  /// Read All Documents with Optional Filter
  Future<List<Map<String, dynamic>>?> readAllDocuments({
    required String tableName,
    String? fieldName,
    int? limit,
    dynamic fieldValue,
  }) async {
    try {
      var query = supabase.from(tableName).select();
      if (fieldName != null && fieldValue != null) {
        query = query.eq(fieldName, fieldValue);
      }

      var response =[];

      if(limit!=null){
        response = await query.limit(limit);
      }else{
        response = await query;
      }


      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      log("Unexpected response format: $response");
      return null;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return null;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return null;
    }
  }


  Future<List<Map<String, dynamic>>?> readAllDocumentsWithFilters({
    required String tableName,
    Map<String, dynamic>? filters, // new: pass multiple field filters
  }) async {
    try {
      var query = supabase.from(tableName).select();

      if (filters != null && filters.isNotEmpty) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query;

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }

      log("Unexpected response format: $response");
      return null;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return null;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return null;
    }
  }

  /// Read All Documents with Optional Filter
  Future<List<Map<String, dynamic>>?> readAllDocumentsWithJoin({
    required String tableName,
    required String joinQuery,
    String? fieldName,orderByField,
    dynamic fieldValue,
    int? limit,
  }) async {
    try {

        // query = supabase.from(tableName).select(joinQuery).order(orderByField);



      var  query = supabase.from(tableName).select(joinQuery);




      if (fieldName != null && fieldValue != null) {
        query = query.eq(fieldName, fieldValue);
      }




      var response;


      if(orderByField!=null){
        response =  await query.order(orderByField);
      }else {
        response = await query;
      }
      // if(limit!=null){
      //   response = await query.limit(limit);
      // }else{
      //   response = await query;
      // }

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      log("Unexpected response format: $response");
      return null;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);

      log("Error Message Exception = ${errorMessage}");
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return null;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return null;
    }
  }


  /// Paginated Read
  Future<List<Map<String, dynamic>>?> readWithPagination({
    required String tableName,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .range((page - 1) * limit, page * limit - 1);
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      log("Unexpected response format: $response");
      return null;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return null;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return null;
    }
  }

  /// Update Document
  Future<bool> updateDocument({
    required String tableName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await supabase.from(tableName).update(data).eq('id', id);
      log("Document updated successfully: $response");
      return true;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Delete Document
  Future<bool> deleteDocument({
    required String tableName,
    required String id,
  }) async {
    try {
      final response = await supabase.from(tableName).delete().eq('id', id);
      log("Document deleted successfully: $response");
      return true;
    } on PostgrestException catch (e) {
      final errorMessage = getSupabaseErrorMessage(e);
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Error", message: errorMessage);
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Realtime Stream
  Stream<List<Map<String, dynamic>>> getRealtimeStream({
    required String tableName,
  }) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['id']).map((event) => event);
  }

  /// Check if Document Exists
  Future<bool> isDocumentExist({
    required String tableName,
    required String id,
  }) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('id', id)
          .maybeSingle();
      return response != null;
    } catch (e, stackTrace) {
      log("Unexpected exception: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Error Message Handling
  String getSupabaseErrorMessage(PostgrestException e) {
    switch (e.code) {
      case '23505': // unique_violation
        return 'This record already exists.';
      case '23503': // foreign_key_violation
        return 'This operation violates database relationships.';
      case '42P01': // undefined_table
        return 'The requested table does not exist.';
      case '42703': // undefined_column
        return 'Invalid field name specified.';
      case '22001': // string_data_right_truncation
        return 'The data is too long for this field.';
      case '23502': // not_null_violation
        return 'Required field is missing.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}
