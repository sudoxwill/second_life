import "package:flutter/material.dart";

class RequiredFieldLabel extends StatelessWidget {
  const RequiredFieldLabel({
    required this.label,
    this.isRequired = true,
    this.textStyle,
    super.key,
  });

  final String label;
  final bool isRequired;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
        children: [
          if (isRequired)
            TextSpan(
              text: " *",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}
