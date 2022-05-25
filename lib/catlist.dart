import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatList extends StatefulWidget {
  @override
  State<CatList> createState() => _CatListState();
}

class _CatListState extends State<CatList> {
  Future<List> pegarConteudo() async {
    var url = Uri.parse('https://api.thecatapi.com/v1/breeds');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao carregar dados do servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumindo uma API'),
      ),
      body: FutureBuilder<List>(
          future: pegarConteudo(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar os dados.'),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]['name']),
                    subtitle: Text(snapshot.data![index]['temperament']),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
