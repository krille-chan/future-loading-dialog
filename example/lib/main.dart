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

  Future<void> displayLoadingModalWithError() async {
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await Future.delayed(const Duration(seconds: 1));
        throw Exception("hehe, i'm gonna kill your app");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                child: const Text("Future loading"),
                onPressed: displayLoadingModal),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                child: const Text("FutureLoadingWithError"),
                onPressed: displayLoadingModalWithError),
          ],
        ),
      ),
    );
  }
}
