import 'package:flutter/foundation.dart';
import 'package:flutter_mask/repository/store_repository.dart';

class StoreViewModel with ChangeNotifier{
  final _storeRepository = StoreRepository();

  Future fetch() {
    return _storeRepository.fetch();
  }
}