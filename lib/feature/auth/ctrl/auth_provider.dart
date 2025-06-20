// HiveDataSource provider (if not already created)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/local_db/hive_data_source.dart';

final hiveDataSourceProvider = Provider<HiveDataSource>((ref) {
  return HiveDataSource();
});