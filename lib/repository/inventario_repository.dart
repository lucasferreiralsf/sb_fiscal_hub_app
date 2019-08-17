import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sb_fiscal_hub_app/models/inventario_model.dart';
import 'package:sb_fiscal_hub_app/utils/functions/fetched_data.dart';
import 'package:sb_fiscal_hub_app/utils/functions/httpClient.dart';

Future<FetchedData<Inventario>> fetchInventario() async {
  final currentCompany =
      json.decode(await FlutterSecureStorage().read(key: 'currentCompany'));
  String _currentCompanyId = '${currentCompany["id"]}';
  try {
    final response = await httpGet<Inventario>(
        url: 'inventario/GetByIdData/1/10/null/0/${currentCompany["id"]}',
        headersList: {'companyId': _currentCompanyId});

    if (response.statusCode == 200) {
      return FetchedData(
          error: false,
          statusCode: 200,
          message: 'OK',
          data: Inventario.fromJson(json.decode(response.body)));
    } else {
      return FetchedData(
          error: true,
          statusCode: response.statusCode,
          message: response.body,
          data: json.decode(response.body));
    }
  } catch (e) {
    return FetchedData(
        error: true,
        statusCode: 500,
        message: 'Erro interno, tente novamente.',
        data: e);
  }
}
