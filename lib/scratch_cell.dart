
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class ScratchCell extends StatelessWidget {
  final Widget child;
  final VoidCallback onReveal;
  final bool highlight;
  final String scratchKeyId;

  const ScratchCell({
    super.key,
    required this.child,
    required this.onReveal,
    required this.scratchKeyId,
    this.highlight=false
  });

  @override
  Widget build(BuildContext context){
    return AnimatedContainer(
      duration: const Duration(milliseconds:400),
      decoration: BoxDecoration(
        border: Border.all(color: highlight? Colors.yellow: Colors.white, width:3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Scratcher(
        key: ValueKey(scratchKeyId),
        brushSize:40,
        threshold:50,
        color: Colors.grey,
        onThreshold: onReveal,
        child: Container(color: Colors.green.shade700, child: Center(child: child)),
      ),
    );
  }
}
