
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConstants {

  final supabase = Supabase.instance.client;
   late StreamSubscription<List<Map<String, dynamic>>> userStreamSubscription;


  final usersTable = 'users';
  final serviceTable = 'services';
  final notificationsTable = 'notifications';
  final portfolioTable = 'portfolio';
  final availabilityTable = 'availability';
  final bookingsTable = 'bookings';
  final chatThreadsTable = 'chat_threads';
  final communityThreadsTable = 'community_chat_threads';
  final reportsTable = 'reports';
  final categoryGalleryTable = 'category_gallery';

  final messagesTable = 'messages';
  final communityMessagesTable = 'community_messages';
  final chatParticipantsTable = 'chat_participants';
  final communityChatParticipantsTable = 'community_chat_participants';

}