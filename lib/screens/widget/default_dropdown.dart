import 'package:flutter/material.dart';

class DefaultDropDown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T) label;
  final ValueChanged<T> onChanged;

  final double height;
  final double width;
  final String hint;

  const DefaultDropDown({
    super.key,
    required this.items,
    required this.value,
    required this.label,
    required this.onChanged,
    this.height = 48,
    this.width = double.infinity,
    this.hint = "Select",
  });

  @override
  State<DefaultDropDown<T>> createState() => _DefaultDropDownState<T>();
}

class _DefaultDropDownState<T> extends State<DefaultDropDown<T>> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            height: widget.height,
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.value != null
                      ? widget.label(widget.value as T)
                      : widget.hint,
                  style: TextStyle(
                    color: widget.value != null
                        ? Colors.black
                        : Colors.grey.shade500,
                    fontSize: 14,
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: _open ? 0.5 : 0,
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),
        ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: _open ? (widget.items.length * 48) : 0,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: _open ? Border.all(color: Colors.grey.shade300) : null,
            boxShadow: _open
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.items.length,
              itemBuilder: (_, index) {
                final item = widget.items[index];
                final selected = item == widget.value;
                return InkWell(
                  onTap: () {
                    widget.onChanged(item);
                    setState(() => _open = false);
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    color: selected
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.white,
                    child: Text(
                      widget.label(item),
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
