# Widget Exploder

A Flutter package for [your package description].

## Features

- Feature 1
- Feature 2
- Feature 3

## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  widget_exploder: ^0.0.1
```

## Usage

```dart
import 'package:widget_exploder/widget_exploder.dart';

final _controller = ExploderController();

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
```