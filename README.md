# Widget Exploder

A Flutter package for exploding widgets into tiny pieces.


## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  widget_exploder: ^0.0.2
```

## Usage

```dart
import 'package:widget_exploder/widget_exploder.dart';

final _controller = ExploderController();

Column(
    children: [
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
        ElevatedButton(
            onPressed: _controller.trigger ? null : _controller.dissolve,
            child: const Text('Trigger Explosion'),
        ),
    ]
)
```