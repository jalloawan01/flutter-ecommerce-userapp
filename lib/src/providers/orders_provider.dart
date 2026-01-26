import 'package:supabase_flutter/supabase_flutter.dart';

class OrdersProvider {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> userOrders(String userId) {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }
}
