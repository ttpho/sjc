import 'package:flutter/material.dart';
import 'package:sjc/gold.dart';
import 'package:sjc/list_gold_view_model.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'SJC',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ListGoldViewModel _viewModel = ListGoldViewModelIml();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SJC"),
      ),
      body: FutureBuilder(
          future: _viewModel.listCity,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final Gold gold = snapshot.data;
                final List<Widget> columns = List();
                columns.add(_header(gold));

                gold.listCity.forEach((city) {
                  columns.add(_widgetCity(city));
                });

                return Container(
                  child: SingleChildScrollView(
                    child: Column(children: columns),
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
                return _centerView(const Text("no internet connection"));
              } else {
                return _centerView(const Text("empty"));
              }
            } else {
              return _centerView(const CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // empty event to reload widget
          });
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _header(Gold gold) => Column(
        children: <Widget>[
          Container(
            height: 68,
            child: _centerView(Text("Cập nhật: ${gold.updated}\n${gold.unit}",
                textAlign: TextAlign.center)),
          ),
          Container(
            height: 68,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text("LOẠI VÀNG", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("MUA VÀO", textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Text("BÁN RA", textAlign: TextAlign.center),
                ),
              ],
            ),
          )
        ],
      );

  Widget _widgetCity(City city) {
    final List<Widget> rows = List();
    city.listItem.forEach((element) {
      rows.add(Container(
          height: 68,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(element.type, textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text(element.sell, textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text(element.buy, textAlign: TextAlign.center),
              ),
            ],
          )));
    });

    return Column(children: <Widget>[
      Container(
        height: 40,
        color: Colors.blueAccent,
        child: Center(
          child: Text(
            city.name,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      Column(children: rows)
    ]);
  }

  Widget _centerView(final Widget widget) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget,
          ],
        ),
      );
}
