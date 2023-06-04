import 'package:flutter/material.dart';
class WidgetRoundedTextButton extends StatelessWidget
{
  late final String text;
  late final Color color;
  final void Function()? onPressed;
  late final int? width;
  late final int? height;
  late final TextStyle textStyle;
  late final double roundnessRadius;
  late final EdgeInsets paddingEdgeInsets;
  late final Border? borderLine;


  WidgetRoundedTextButton
  (
    {
      required this.text,
      required this.color,
      Function()? this.onPressed,
      this.width,
      this.height,
      double? roundnessRadius,
      EdgeInsets? paddingEdgeInsets,
      TextStyle? textStyle,
      Border? borderLine,
      bool? borderless,
      super.key,
    }
  )
  {
    this.roundnessRadius = roundnessRadius ?? 10;
    this.paddingEdgeInsets 
      = paddingEdgeInsets ?? const EdgeInsets.fromLTRB(8.0,3.0,8.0,6.0);
    this.textStyle 
      = textStyle ?? const TextStyle(fontSize: 16,color: Colors.black);
    this.borderLine 
      = borderLine ?? 
        ((borderless ?? false) ? null :Border.all(color:Colors.black));
  }
  @override
  Widget build(BuildContext context) {
    return 
    Container
    (
      decoration: BoxDecoration
      (
        color: color,
        border: borderLine,
        borderRadius: BorderRadius.all(Radius.circular(roundnessRadius))
      ),
      child: TextButton
      (
        onPressed: onPressed,
        child: Padding(
          padding: paddingEdgeInsets,
          child: Text
          (
            text,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ),
      )
    );
  }
}