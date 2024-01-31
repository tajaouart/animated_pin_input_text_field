library animated_pin_input_text_field;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A `PinInputTextField` is a customisable widget that allows users
/// to enter pin numbers in a secure and user-friendly way. It typically
/// finds its use in authentication forms where pin or OTP inputs are required.
///
/// The field is presented as a series of boxes, each box representing a
/// single character in the pin. The number of boxes is defined by the `pinLength`.
///
/// The widget allows customization of various visual and functional aspects,
/// such as border styles, padding, text styles, and more.
///
/// Example usage:
/// ```dart
/// PinInputTextField(
///   pinLength: 4,
///   onChanged: (String pin) {
///     // Handle pin changed
///   },
/// )
/// ```
///
/// This widget must be given a `pinLength` and an `onChanged` callback.
/// Optionally, you can customize the appearance with the other available parameters.
class PinInputTextField extends StatefulWidget {
  /// Creates a PinInputTextField.
  ///
  /// The [pinLength] and [onChanged] parameters must not be null.
  /// The [obscuringCharacter] must have a length of 1.
  /// The [pinLength] must be greater than 0.
  /// The [focusBorderWidth] must be non-negative.
  ///
  /// The [borderRadius], [padding], [initialFocusDelay], [focusBorderColor],
  /// [borderColor], [obscuringCharacter], [fillColor], [focusBorderWidth],
  /// [automaticFocus], [borderWidth], [contentPadding], [filled], [aspectRatio],
  /// [focusBorder], [boxShape], and [textStyle] provide defaults that can be
  /// overridden by specifying a value.
  const PinInputTextField({
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    this.initialFocusDelay = const Duration(seconds: 1),
    this.focusBorderColor = Colors.blue,
    this.borderColor = Colors.black12,
    this.obscuringCharacter = '•',
    this.fillColor = Colors.white,
    this.focusBorderWidth = 2.0,
    this.automaticFocus = true,
    required this.onChanged,
    required this.pinLength,
    this.obscureText = false,
    this.borderWidth = 1.0,
    this.contentPadding,
    this.filled = true,
    this.aspectRatio,
    this.focusBorder,
    this.boxShape,
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: Colors.black,
      fontSize: 28,
    ),
    this.border,
    super.key,
  })  : assert(
          (focusBorder != null && focusBorderWidth == 2.0) ||
              focusBorder == null,
          'focusBorderWidth must be null when focusBorder is not.',
        ),
        assert(
          (border != null && borderWidth == 1.0) || border == null,
          'borderWidth must be null when border is not.',
        ),
        assert(obscuringCharacter.length == 1),
        assert(pinLength > 0),
        assert(focusBorderWidth >= 0);

  final ValueChanged<String> onChanged;
  final Duration initialFocusDelay;
  final EdgeInsets? contentPadding;
  final BorderRadius borderRadius;
  final String obscuringCharacter;
  final double focusBorderWidth;
  final Color focusBorderColor;
  final Border? focusBorder;
  final bool automaticFocus;
  final double? aspectRatio;
  final TextStyle textStyle;
  final double borderWidth;
  final EdgeInsets padding;
  final Color borderColor;
  final BoxShape? boxShape;
  final bool obscureText;
  final Color fillColor;
  final Border? border;
  final int pinLength;
  final bool filled;

  @override
  PinInputTextFieldState createState() => PinInputTextFieldState();
}

class PinInputTextFieldState extends State<PinInputTextField> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _rawKeyboardFocusNodes = [];
  final List<FocusNode> _textFocusNodes = [];

  @override
  void initState() {
    super.initState();
    List.generate(widget.pinLength, (_) {
      _textFocusNodes.add(FocusNode()..addListener(_focusNodeListener));
      _rawKeyboardFocusNodes.add(FocusNode()..addListener(_focusNodeListener));
      _controllers.add(TextEditingController());
      for (final ctr in _controllers) {
        ctr.addListener(() {
          ctr.selection = TextSelection.fromPosition(
            TextPosition(offset: ctr.text.length),
          );
        });
      }
    });

    if (widget.automaticFocus) {
      Future.delayed(widget.initialFocusDelay).then((_) {
        if (mounted) {
          setState(() {
            _requestFocus(0);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.aspectRatio == null
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.pinLength,
        (index) {
          Widget textField = AnimatedContainer(
            key: Key('AnimatedContainer${_controllers[index].hashCode}'),
            duration: const Duration(microseconds: 200),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.fillColor,
              border: border(index),
              borderRadius:
                  widget.boxShape == null ? widget.borderRadius : null,
              shape: widget.boxShape ?? BoxShape.rectangle,
            ),
            child: AbsorbPointer(
              absorbing: _absorbing(index),
              child: RawKeyboardListener(
                focusNode: _rawKeyboardFocusNodes[index],
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      _onChanged(index, '');
                    }
                  }
                },
                child: TextField(
                  key: Key('TextField${_controllers[index].hashCode}'),
                  onChanged: (value) => _onChanged(index, value),
                  obscuringCharacter: widget.obscuringCharacter,
                  keyboardType: TextInputType.number,
                  focusNode: _textFocusNodes[index],
                  controller: _controllers[index],
                  obscureText: widget.obscureText,
                  mouseCursor: MouseCursor.defer,
                  textAlign: TextAlign.center,
                  style: widget.textStyle,
                  onTap: _onTap,
                  decoration: InputDecoration(
                    contentPadding: widget.aspectRatio != null
                        ? EdgeInsets.zero
                        : widget.contentPadding,
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          );

          // Wrap with AspectRatio if aspectRatio is provided
          if (widget.aspectRatio != null) {
            textField = AspectRatio(
              aspectRatio: widget.aspectRatio!,
              child: textField,
            );
          }

          return Flexible(
            child: Padding(
              padding: widget.padding,
              child: textField,
            ),
          );
        },
      ),
    );
  }

  int get index {
    return _textFocusNodes.isNotEmpty
        ? _textFocusNodes.indexWhere((element) => element.hasFocus)
        : 0;
  }

  String get getPin => _controllers.map((controller) => controller.text).join();

  bool _absorbing(int index) {
    if (_textFocusNodes.any((element) => element.hasFocus)) {
      return !_textFocusNodes[index].hasFocus;
    }
    if (getPin.length == widget.pinLength) {
      return index < widget.pinLength - 1;
    }
    return index != 0;
  }

  void _onChanged(int index, String value) {
    if (index < 0) return;

    value.trim();
    if (value.isEmpty) {
      if (index > 0) {
        if (_controllers[index].value.text.isEmpty) {
          _requestFocus(index - 1);
        } else {
          _requestFocus(index);
        }
      }
    } else if (value.length == 1) {
      if (index < widget.pinLength - 1) {
        _requestFocus(index + 1);
      } else {
        _unFocus(index);
      }
    } else if (value.length > 1) {
      int nextIndex = index;
      final charList = value.split('');
      for (final char in charList) {
        if (nextIndex < widget.pinLength) {
          _controllers[nextIndex].text = char;
          nextIndex++;
        } else {
          break; // Exit the loop when we've reached the end of the TextFields
        }
      }
      if (nextIndex < widget.pinLength) {
        _requestFocus(nextIndex);
      } else {
        _unFocus();
      }
    }
    widget.onChanged.call(getPin);

    setState(() {});
  }

  void _requestFocus(int index) {
    _textFocusNodes[index].requestFocus();
  }

  void _unFocus([int? index]) {
    if (index == null) {
      for (final element in _textFocusNodes) {
        element.unfocus();
      }
    } else {
      _textFocusNodes[index].unfocus();
    }
  }

  void _onTap() {
    setState(() {
      _requestFocus(index);
    });
  }

  void _focusNodeListener() {
    setState(() {});
  }

  Border border(int index) {
    return _textFocusNodes[index].hasFocus
        ? (widget.focusBorder ??
            Border.all(
              color: widget.focusBorderColor,
              width: widget.focusBorderWidth,
            ))
        : (widget.border ??
            Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ));
  }

  @override
  void dispose() {
    for (var i = 0; i < widget.pinLength; i++) {
      _rawKeyboardFocusNodes[i].removeListener(_focusNodeListener);
      _rawKeyboardFocusNodes[i].dispose();
      _textFocusNodes[i].removeListener(_focusNodeListener);
      _textFocusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }
}
