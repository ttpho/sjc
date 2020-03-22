import 'package:sjc/gold.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:convert';

abstract class SJCService {
  Future<Gold> fetch();
}

class SJCServiceIml implements SJCService {
  static String _baseUrl = "http://sjc.com.vn/xml/tygiavang.xml";

  @override
  Future<Gold> fetch() async {
    final response = await http.get(_baseUrl);
    return _parseXML(utf8.decode(response.bodyBytes));
  }

  Gold _parseXML(String response) {
    final Gold gold = Gold();
    final List<City> listItem = List();
    final document = xml.parse(response);
    final info = document.findAllElements("ratelist").toList()[0];
    gold.updated = info.getAttribute("updated");
    gold.unit = info.getAttribute("unit");

    info.findAllElements("city").forEach((element) {
      final name = element.getAttribute("name");
      print(name);
      final List<GoldPrice> golds = List();
      element.findElements("item").forEach((elementGold) {
        final gold = GoldPrice();
        gold.buy = elementGold.getAttribute("buy");
        gold.sell = elementGold.getAttribute("sell");
        gold.type = elementGold.getAttribute("type");
        golds.add(gold);

        print(gold.buy);
        print(gold.sell);
        print(gold.type);
      });
      var city = City();
      city.name = name;
      city.listItem = golds;

      listItem.add(city);
    });
    gold.listCity = listItem;
    return gold;
  }
}
