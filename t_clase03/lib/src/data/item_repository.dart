import '../models.dart';

abstract class ItemRepository {
  Future<List<CrudItem>> listItems();
  Future<CrudItem> createItem(CrudItem item);
  Future<CrudItem> updateItem(CrudItem item);
  Future<void> deleteItem(int id);
}
