import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mask/repository/store_repository.dart';
import 'model/store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var stores = List<Store>.empty(
    growable: true,
  );
  var isLoading = false;
  final storeRepository = StoreRepository();
  @override
  void initState() {
    super.initState();
    storeRepository.fetch().then((value) {
      setState(() {
        stores = value;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${stores.where((element) {
          return element.remainStat == 'plenty' || element.remainStat == 'some' || element.remainStat == 'few';
        }).length}곳'),
        actions: [
          IconButton(
            onPressed: () {
              storeRepository.fetch().then((value) {
                setState(() {
                  stores = value;
                });
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? loadingWidget()
          : ListView(
              children: stores.where((element) {
                return element.remainStat == 'plenty' || element.remainStat == 'some' || element.remainStat == 'few';
              }).map((e) {
                return ListTile(
                  title: Text(e.name!),
                  subtitle: Text(e.addr!),
                  trailing: _buildRemainStatWidget(e),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;
    if (store.remainStat == 'plenty') {
      remainStat = '충분';
      description = '100개 이상';
      color = Colors.green;
    }

    switch(store.remainStat){
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
    }
    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: TextStyle(color: color),
        ),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
