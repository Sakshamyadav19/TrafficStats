import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Pollution, String>> seriesData;
  var data;
  var isButtonPressed = true;
  var isButtonPressed1 = false;
  var response1;
  var cat = "daily";

  change1(var x) {
    setState(() {
      cat = x;
    });
  }

  Future<List<dynamic>> call() async {
    String url = "https://eflask-app-api.herokuapp.com/";
    http.Response response = await http.get(url);
    setState(() {
      response1 = convert.jsonDecode(response.body);
    });
    return convert.jsonDecode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = call();
    seriesData = List<charts.Series<Pollution, String>>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Traffic Stats",
            style: TextStyle(
              fontWeight:FontWeight.bold,
              fontSize:30,
            ),
          ),
          centerTitle:true,
          backgroundColor: Colors.cyan),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                padding: EdgeInsets.all(15),
                color: isButtonPressed ? Colors.green : Colors.red,
                onPressed: () {
                  setState(() {
                    // isButtonPressed = !isButtonPressed;
                    isButtonPressed1 = false;
                    isButtonPressed = true;
                  });
                  change1("daily");
                },
                child: Text("Daily"),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  // side: BorderSide(color: Colors.red)
                ),
                padding: EdgeInsets.all(15),
                color: isButtonPressed1 ? Colors.green : Colors.red,
                onPressed: () {
                  setState(() {
                    // if(isButtonPressed1 = !isButtonPressed1)
                    isButtonPressed = false;
                    isButtonPressed1 = true;
                  });
                  change1("hourly");
                },
                child: Text("Hourly"),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // Padding(padding:EdgeInsets.all(5)),
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "2-Wheeler",
                  textAlign: TextAlign.center,
                ),
                width: 100,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(5),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Text(
                  "4-Wheeler",
                  textAlign: TextAlign.center,
                ),
                width: 100,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(5),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green,
                ),
                child: Text(
                  "Bus",
                  textAlign: TextAlign.center,
                ),
                width: 80,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(5),
              )
            ],
          ),
          Container(
            child: response1 == null
                ? CircularProgressIndicator()
                : Expanded(child: createChart(cat)),
          ),
        ],
      ),
    );
  }

  Widget createChart(var cat) {

    List<charts.Series<Pollution, String>> seriesList = [];

    for (int i = 0; i < 1; i++) {
      seriesList.add(createSeries('tom', i, cat, Colors.red));
      seriesList.add(createSeries('sam', i + 1, cat, Colors.blue));
      seriesList.add(createSeries('mike', i + 2, cat, Colors.green));
    }

    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.stacked,
      animate: true,
      animationDuration: Duration(seconds: 1),
    );
  }

  charts.Series<Pollution, String> createSeries(
      String id, int i, var cat, Color color) {
    if (cat == 'daily') {
      return charts.Series<Pollution, String>(
        id: id,
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        data: [
          Pollution('Mon', response1[0]['daily'][0]['Mon'][i]),
          Pollution('Tue', response1[0]['daily'][0]['Tue'][i]),
          Pollution('Wed', response1[0]['daily'][0]['Wed'][i]),
          Pollution('Thur', response1[0]['daily'][0]['Thu'][i]),
          Pollution('Fri', response1[0]['daily'][0]['Fri'][i]),
          Pollution('Sat', response1[0]['daily'][0]['Sat'][i]),
          Pollution('Sun', response1[0]['daily'][0]['Sun'][i]),
        ],
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(color),
      );
    } else {
      return charts.Series<Pollution, String>(
        id: id,
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        data: [
          Pollution('8am', response1[0][cat][0]['8am'][i]),
          Pollution('10am', response1[0][cat][0]['10am'][i]),
          Pollution('12am', response1[0][cat][0]['12am'][i]),
          Pollution('2pm', response1[0][cat][0]['2pm'][i]),
          Pollution('4pm', response1[0][cat][0]['4pm'][i]),
          Pollution('6pm', response1[0][cat][0]['6pm'][i]),
          Pollution('8pm', response1[0][cat][0]['8pm'][i]),
        ],
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(color),
      );
    }
  }
}

class Pollution {
  String place;
  int quantity;

  Pollution(this.place, this.quantity);
}
