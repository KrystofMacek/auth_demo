import 'package:auth_demo/screens/initial/initial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/initial',
      routes: {
        '/initial': (context) => const InitialScreen(),
      },
    );
  }
}
