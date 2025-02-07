import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListSync<T> {
  final ValueNotifier<List<T>> _controller = ValueNotifier<List<T>>([]);
  List<T> _items = [];

  ValueListenable<List<T>> get listenable {
    return _controller;
  }

  void addItem(T item) {
    _items.add(item);
    _controller.value = List.from(_items);
    _controller.notifyListeners();
  }

  List<T> get list {
    return _items;
  }

  void replaceAt(int index, T item) {
    _items[index] = item;
    _controller.value = List.from(_items);
    _controller.notifyListeners();
  }

  void dispose() {
    _controller.dispose();
  }
}
