import 'package:characterbook/features/calendar/domain/custom_event_model.dart';

abstract class CustomEventRepository {
  Stream<List<CustomEvent>> watchAll();
  Future<List<CustomEvent>> getAll();
  Future<void> save(CustomEvent event);
  Future<void> delete(String id);
  Future<CustomEvent?> getById(String id);
}
