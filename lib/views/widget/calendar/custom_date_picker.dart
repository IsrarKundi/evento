import 'package:event_connect/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final String? label;
  final List<DateTime> selectedDates;

  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    required this.selectedDates,
    this.initialDate,
    this.label,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? _selectedDay;

  Future<void> _showCustomCalendarDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.6,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                return TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _selectedDay ?? DateTime.now(),
                  selectedDayPredicate: (day) =>
                  _selectedDay != null && isSameDay(day, _selectedDay),
                  enabledDayPredicate: (day) =>
                      widget.selectedDates.any((d) => isSameDay(d, day)),
                  onDaySelected: (selectedDay, focusedDay) {
                    setDialogState(() {
                      _selectedDay = selectedDay;
                    });
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                    Navigator.of(context).pop();
                    widget.onDateSelected(selectedDay);
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  calendarStyle: const CalendarStyle(
                    isTodayHighlighted: false,
                    disabledTextStyle: TextStyle(color: Colors.grey),
                    outsideTextStyle: TextStyle(color: Colors.grey),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final isEnabled = widget.selectedDates.any((d) => isSameDay(d, day));
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isEnabled ? Colors.black : Colors.grey,
                            fontWeight: isEnabled ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final isEnabled = widget.selectedDates.any((d) => isSameDay(d, day));
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: isEnabled ? Colors.black : Colors.grey,
                              fontWeight: isEnabled ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue, // Your primary color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final formatted = _selectedDay != null
        ? Utils.formatDateTimeSimple(_selectedDay!,context)
        : "Select Date";

    return GestureDetector(
      onTap: () => _showCustomCalendarDialog(context),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Text(formatted),
            const Spacer(),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
