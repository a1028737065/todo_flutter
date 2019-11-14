import 'dart:async';
import './model/item.dart';

class ItemBloc {
  List<Item> _itemList = [];
  Map<int, int> _idMap = {};

  final StreamController<List<Item>> _itemListStream = StreamController();
  Stream<List<Item>> get itemListStream => _itemListStream.stream;

  ItemBloc() {
    _itemListStream.add(_itemList);
  }

  bool isEmpty() {
    return _itemList.isEmpty;
  }

  void addItem(List<Item> item) {
    List<Item> _temp = item;
    _temp.addAll(_itemList);
    _itemList = _temp;
    _itemListStream.sink.add(_itemList);
    _updateIdMap();
  }

  void removeItem(int index) {
    _itemList.removeAt(_idMap[index]);
    _itemListStream.sink.add(_itemList);
    _updateIdMap();
  }

  void updateItem(Item item) {
    _itemList[_idMap[item.id]] = item;
    _itemListStream.sink.add(_itemList);
    _updateIdMap();
  }

  void _updateIdMap() {
    _idMap = {};
    for (int _i = 0; _i < _itemList.length; _i++) {
      _idMap.putIfAbsent(_itemList[_i].id, () => _i);
    }
    
  }

  void dispose() {
    _itemListStream.close();
  }
}
