import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> displayLoadingModal() async {
    await showFutureLoadingDialog(
      context: context,
      future: () => Future.delayed(const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
          child: ElevatedButton(
              child: const Text("Press me"), onPressed: displayLoadingModal)),
    );
  }
}
