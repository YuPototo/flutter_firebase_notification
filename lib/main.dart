import 'package:flutter/material.dart';
import './firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  FirebaseService.onBackgroundMessage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging Example App',
      theme: ThemeData.dark(),
      routes: {
        '/': (context) => const ScreenOne(),
        '/screen_2': (context) => const ScreenTwo(),
      },
    );
  }
}

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  String deviceToken = "";

  @override
  void initState() {
    super.initState();

    FirebaseService.onMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen One'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/screen_2');
              },
              child: const Text('Go to Screen 2'),
            ),
            Text('Token: $deviceToken'),
            ElevatedButton(
              onPressed: () async {
                var deviceToken = await FirebaseService.getDeviceToken();
                if (deviceToken != null) {
                  print(deviceToken);
                  setState(() {
                    this.deviceToken = deviceToken;
                  });
                }
              },
              child: const Text('Get Token'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenTwo extends StatelessWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen Two'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          child: const Text('Go To Screen 1'),
        ),
      ),
    );
  }
}
