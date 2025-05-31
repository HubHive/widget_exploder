import 'package:flutter/material.dart';
import 'package:widget_dissolver/widget_exploder.dart';

void main() {
  runApp(const WidgetExploderDemoApp());
}

class WidgetExploderDemoApp extends StatelessWidget {
  const WidgetExploderDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Widget Dissolver Demo',
      home: DemoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  final _controller = ExploderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Exploder Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Exploder(
              controller: _controller,
              duration: const Duration(seconds: 3),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Explode Me!',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _controller.trigger ? null : _controller.dissolve,
              child: const Text('Trigger Explosion'),
            ),
            ElevatedButton(
              onPressed: _controller.resetDissolver,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
