import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ConsultaDropdown extends StatefulWidget {
  final String text;
  final Widget child;

  const ConsultaDropdown({required this.text, required this.child, super.key});

  @override
  State<ConsultaDropdown> createState() => _ConsultaDropdownState();
}

class _ConsultaDropdownState extends State<ConsultaDropdown> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(_controller);
  }

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Row(
              children: [
                AutoSizeText(
                  widget.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline
                  ),
                  maxLines: 1,
                  minFontSize: 18,
                ),
                RotationTransition(
                  turns: _arrowAnimation,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn,
          ),
          axisAlignment: 1.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 4,right: 10,bottom: 6),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
