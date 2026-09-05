import 'package:flutter/material.dart';

class FormatFilterBar extends StatelessWidget {
  final List<String> formats;
  final String selectedFormat;
  final ValueChanged<String> onFormatSelected;

  const FormatFilterBar({
    Key? key,
    required this.formats,
    required this.selectedFormat,
    required this.onFormatSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: formats.length,
        itemBuilder: (context, index) {
          final format = formats[index];
          final isSelected = format == selectedFormat;
          final isAdult = format == 'Série Porno' || format == 'Film Porno' || format == 'Hentai' || format == 'Adultes (18+)';

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                format,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isAdult ? Colors.redAccent : Colors.black87),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              selectedColor: isAdult ? Colors.red[900] : Theme.of(context).primaryColor,
              backgroundColor: isAdult ? Colors.red.withOpacity(0.1) : Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : (isAdult ? Colors.redAccent.withOpacity(0.5) : Colors.grey[300]!),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  onFormatSelected(format);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
