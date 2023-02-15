import 'package:app_usage_tracker/app_usage_tracker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Usage Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'App Usage Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isUSED = false;

  checkUsed() async {
    bool isUsedEnough = await AppUsageTracker.isAppUsedEnough(
      minDayUsed: 0,
      minLaunches: 3,
      resetTracker: true,
    );
    if (isUsedEnough) {
      setState(() {
        isUSED = true;
      });
    } else {
      setState(() {
        isUSED = false;
      });
    }
  }

  @override
  void initState() {
    checkUsed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'App is Used For 1 Days and 3 Times: ',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isUSED ? 'TRUE' : ' FALSE',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
