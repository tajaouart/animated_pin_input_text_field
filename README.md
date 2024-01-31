# PinInputTextField Package

`PinInputTextField` is a Flutter widget designed for inputting PINs
or OTPs in a user-friendly and secure manner. This package's features and customization options make
it ideal for applications requiring secure entry, such as authentication forms.

<img src="https://raw.githubusercontent.com/tajaouart/animated_pin_input_text_field/master/animated_pin_input_text_field.gif" height="600"/>

## Short Description

The `PinInputTextField` widget provides a customizable and easy-to-use PIN or OTP input field
focusing on security and usability. It is perfect for forms where secure input is needed, such as
authentication forms.

## Features

- **Customizable Length**: Easily set the pin length to suit your application's needs.
- **Obscured Input**: Option to obscure the input with a customizable character for added security.
- **Auto-focus**: Automatic focusing on the next field for a smoother user experience.
- **Customizable Appearance**: Adjust the border radius, padding, colors, and more to fit the look
  and feel of your app.
- **Flexible Box Shapes**: Choose from different box shapes for your PIN input fields, enhancing the
  visual appeal.

## Getting Started

To start using the `PinInputTextField` package in your Flutter project, add it to
your `pubspec.yaml` file:

```yaml
dependencies:
  pin_input_text_field: any
```

Then, run `flutter pub get` in your terminal to install the package.

## Usage

Here's a simple example to get you started with `PinInputTextField`:

```dart
import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: PinInputTextField(
            pinLength: 4,
            onChanged: (pin) {
              print('Pin changed to: $pin');
            },
          ),
        ),
      ),
    );
  }
}
```

For more examples, see the `/example` folder in the package.

## Additional Information

For more information on the `PinInputTextField` package, including how to contribute, file issues,
or if you need support, please visit
our [GitHub repository](https://github.com/tajaouart/animated_pin_input_text_field).

Contributions are welcome!

For any questions or issues, feel free to file an issue on the GitHub repository, and we'll respond
as soon as possible.
