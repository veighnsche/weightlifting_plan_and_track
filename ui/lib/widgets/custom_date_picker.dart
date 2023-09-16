import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onDateChanged;

  const CustomDatePicker(
      {super.key, this.initialDate, required this.onDateChanged});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? dateOfBirth;

  @override
  void initState() {
    super.initState();
    dateOfBirth = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[500]!),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 12.0),
        title: Text(
          dateOfBirth == null
              ? "Select Date of Birth"
              : "Date of Birth: ${DateFormat('dd-MM-yyyy').format(dateOfBirth!)}",
          style: TextStyle(color: Colors.grey[700]),
        ),
        leading: const Icon(Icons.calendar_today, color: Colors.blueGrey),
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            locale: Localizations.localeOf(context),
            initialDate: dateOfBirth ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: Colors.blueGrey,
                  colorScheme: const ColorScheme.light(primary: Colors.blueGrey),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.blueGrey),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (selectedDate != null) {
            setState(() {
              dateOfBirth = selectedDate;
            });
            widget.onDateChanged(selectedDate);
          }
        },
      ),
    );
  }
}
