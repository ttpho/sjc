import 'dart:async';

import 'package:sjc/gold.dart';
import 'package:sjc/sjc_service.dart';

abstract class ListGoldViewModel {
  Future<Gold> get listCity;
}

class ListGoldViewModelIml extends ListGoldViewModel {
  var sjcService = SJCServiceIml();

  @override
  Future<Gold> get listCity => sjcService.fetch();
}
