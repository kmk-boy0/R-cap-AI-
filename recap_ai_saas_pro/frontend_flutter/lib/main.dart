import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const RecapAiApp());
}

class RecapAiApp extends StatelessWidget {
  const RecapAiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recap AI SaaS Pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
