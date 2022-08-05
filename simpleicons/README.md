# HeroIcons

[heroicons](https://heroicons.com/) port to Flutter. This package renders the icons as SVG 
pictures.

## Usage

```dart
class MyExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HeroIcon(
      HeroIcons.calendar,
      solid: false, // Outlined icons are used by default.
      color: Colors.red,
      size: 30,
    );
  }
}
```

## Install

Add `heroicons` package into your `pubspec.yaml`.

```yaml
dependencies:
  heroicons: # Latest version
```

You can also run `flutter pub add heroicons` to quickly add latest version from your CLI.

## Development

Run source code generation to create `heroicons.dart` file with named constructor for every icon.

```
dart tool/generator.dart
```