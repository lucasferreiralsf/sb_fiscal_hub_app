import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sb_fiscal_hub_app/models/inventario_model.dart';
import 'package:sb_fiscal_hub_app/utils/functions/fetched_data.dart';

Widget CustomList(BuildContext context, FetchedData<Inventario> snapshot) {
  return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      itemCount: snapshot.data.total,
      itemBuilder: (context, index) {
        return Center(
//          Text(snapshot.data.data[index.toInt()]['data'].toString())
          child: Card(
            elevation: 5.0,
            child: Container(
              height: 100.0,
              width: double.maxFinite,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 10.0,
                      left: 15.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'ID: ${snapshot.data.data[index.toInt()]['id']}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: <Widget>[
                              Chip(
                                backgroundColor: snapshot.data
                                            .data[index.toInt()]['parcial'] ==
                                        true
                                    ? Colors.yellow[600]
                                    : Colors.blue[700],
                                label: Text(snapshot.data.data[index.toInt()]
                                            ['parcial'] ==
                                        true
                                    ? 'Parcial'
                                    : 'Total'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                              ),
                              Chip(
                                backgroundColor:
                                    snapshot.data.data[index.toInt()]
                                                ['confirmado'] ==
                                            true
                                        ? Theme.of(context).primaryColor
                                        : Colors.yellow[600],
                                label: Text(snapshot.data.data[index.toInt()]
                                            ['confirmado'] ==
                                        true
                                    ? 'Confirmado'
                                    : 'Pendente'),
                              ),
                            ],
                          )
                        ],
                      )),
                  Positioned(
                    top: 10.0,
                    right: 15.0,
                    child: Text(
                      _resolveDate(snapshot.data.data[index.toInt()]['data']),
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    right: 15.0,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.done),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

_resolveDate(data) {
  return DateFormat('dd-MM-yyyy').format(DateTime.parse(data));
}
