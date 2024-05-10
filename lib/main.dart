import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/Controller/branchController.dart';
import 'package:untitled3/Data/localDataSource.dart';
import 'package:untitled3/View/Screens/branchScreen.dart';

void main()async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => BranchScreen()),
      ],
      home: BranchScreen(),
      // Initialize your controllers here
      initialBinding: BindingsBuilder(() {
        Get.put(BranchController());
      }),
    );
  }
}


