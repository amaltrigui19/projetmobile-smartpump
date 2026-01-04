import 'package:flutter/material.dart';

/// Widget that rebuilds its child when locale changes
class LocaleRebuilder extends StatefulWidget {
  final Widget child;
  const LocaleRebuilder({super.key, required this.child});

  @override
  State<LocaleRebuilder> createState() => _LocaleRebuilderState();
}

class _LocaleRebuilderState extends State<LocaleRebuilder> {
  @override
  Widget build(BuildContext context) {
    // Listen to locale changes
    final locale = Localizations.localeOf(context);
    return KeyedSubtree(
      key: ValueKey(locale.toString()),
      child: widget.child,
    );
  }
}

