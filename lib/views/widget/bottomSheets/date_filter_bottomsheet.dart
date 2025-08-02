import 'package:event_connect/core/constants/app_colors.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DateFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime? start, DateTime? end) onApply;

  const DateFilterBottomSheet({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    required this.onApply,
  });

  @override
  State<DateFilterBottomSheet> createState() => _DateFilterBottomSheetState();
}

class _DateFilterBottomSheetState extends State<DateFilterBottomSheet> {
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialStartDate ?? DateTime.now();
    _rangeStart = widget.initialStartDate ??DateTime.now();
    _rangeEnd = widget.initialEndDate??DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Date Range',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildCalendar(),
          const SizedBox(height: 20),


          MyButton(onTap: () {
            Navigator.pop(context);
            widget.onApply(_rangeStart, _rangeEnd);
          }, buttonText: "Apply Filter"),

        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rangeSelectionMode: RangeSelectionMode.toggledOn,
        calendarFormat: CalendarFormat.month,
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
              _rangeStart = selectedDay;
              _rangeEnd = null;
            } else if (_rangeStart != null && _rangeEnd == null) {
              if (selectedDay.isBefore(_rangeStart!)) {
                _rangeEnd = _rangeStart;
                _rangeStart = selectedDay;
              } else {
                _rangeEnd = selectedDay;
              }
            }
            _focusedDay = focusedDay;
          });
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          rangeHighlightColor: kPrimaryColor.withOpacity(0.15),
          rangeStartDecoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: const BoxDecoration(
            color: kPrimaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
void showDateFilterSheet(BuildContext context, {
  DateTime? initialStart,
  DateTime? initialEnd,
  required void Function(DateTime? start, DateTime? end) onApply,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => DateFilterBottomSheet(
      initialStartDate: initialStart,
      initialEndDate: initialEnd,
      onApply: onApply,
    ),
  );
}
