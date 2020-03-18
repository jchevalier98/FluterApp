import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:navigation_bar/util/graph_widget.dart';
import 'package:navigation_bar/util/item.dart';
import 'package:navigation_bar/util/separator.dart';

class MonthWidget extends StatefulWidget {

  final List<DocumentSnapshot> documents;
  final double total; 
  final List<double> perDay;
  final Map<String, double> categories;

  MonthWidget({Key key, this.documents}) : 
    total = documents
    .map((doc) => doc['amount'])
    .fold(0.0, (a,b) => a + b),
    perDay = List.generate(30, (int index) {
      return documents.where((doc) => doc['day'] == (index + 1))
        .map((doc) => doc['amount'])
        .fold(0.0, (a,b) => a + b);
    }),
    categories = documents.fold({}, (Map<String, double> map, document){
      if(!map.containsKey(document['category'])){
        map[document['category']] = 0;
      }

      map[document['category']] += document['amount'];
      return map;
    }), 
    super(key : key);

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {

  @override
  Widget build(BuildContext context) {

    print(widget.categories);
    return Expanded(
      child: Column(
        children: <Widget>[
          _expensas(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: _grafics(),
          ),
          Container(
            color: Colors.blueAccent.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Detalle de gastos",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.blueGrey
                  ),
                )
              ),
            ),
          ),
          _listData()
        ],
      )
    );
  }

  Widget _expensas() {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            "\$${widget.total.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 35.0,
            ),
          ),
        ),
        Center(
          child: Text(
            "Total de gastos",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blueGrey
            ),
          ),
        ),
      ],
    );
  }

  Widget _grafics() {
    return Container(
      height: 215,
      child: GraphWidget(data: widget.perDay),
    );
  }

  Widget _listData() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          return Item(
            icon : FontAwesomeIcons.shoppingCart, 
            name: key, 
            percent: 100 * data ~/ widget.total, 
            amount: data
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Separator(space: 3.0,);
        },
      ),
    );
  }
}