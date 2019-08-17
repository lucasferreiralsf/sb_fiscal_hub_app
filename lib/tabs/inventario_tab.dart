import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sb_fiscal_hub_app/models/inventario_model.dart';
import 'package:sb_fiscal_hub_app/repository/inventario_repository.dart';
import 'package:sb_fiscal_hub_app/utils/functions/fetched_data.dart';
import 'package:sb_fiscal_hub_app/widgets/custom_list.dart';

class InventarioTab extends StatefulWidget {
  @override
  _InventarioTabState createState() => _InventarioTabState();
}

class _InventarioTabState extends State<InventarioTab> {
  Future<FetchedData<Inventario>> inventario;

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
//            gradient: LinearGradient(colors: [
//              Color.fromARGB(255, 0, 137, 56),
//              Color.fromARGB(255, 0, 91, 37)
//            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            color: Colors.grey[100],
          ),
        );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        FutureBuilder<FetchedData<Inventario>>(
          future: inventario,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError)
                  return Text("${snapshot.error}");
                else if (snapshot.data.error == true) {
                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: SvgPicture.asset('assets/icons/empty.svg'),
                    ),
                  );
                } else {
                  return CustomList(context, snapshot.data);
                }
            }
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    inventario = fetchInventario();
  }
}
