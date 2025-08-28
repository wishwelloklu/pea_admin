import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_palace_admin/core/func/date_formatter.dart';
import 'package:prayer_palace_admin/providers/registration_notifier.dart';

class RegistrationFilter extends StatelessWidget {
  const RegistrationFilter({
    super.key,
    required this.currentDate,
    required this.ref,
  });

  final String currentDate;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Row(
        children: [
          Text(
            currentDate.contains('all')
                ? 'All'
                : formatSmartDate(DateTime.parse(currentDate)),
          ),
          Icon(Icons.filter_list),
        ],
      ),
      surfaceTintColor: Colors.white,
      onSelected: (value) async {
        if (value == 'Today') {
          ref.read(regDateProvider.notifier).state = DateTime.now()
              .toIso8601String()
              .split("T")
              .first;
        } else if (value == 'Yesterday') {
          ref.read(regDateProvider.notifier).state = DateTime.now()
              .subtract(Duration(days: 1))
              .toIso8601String()
              .split("T")
              .first;
          debugPrint('Selected Yesterday');
        } else if (value == 'Choose date') {
          final d = await showDatePicker(
            context: context,
            initialDate: currentDate.contains('all')
                ? DateTime.now()
                : DateTime.parse(currentDate),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (d != null)
            ref.read(regDateProvider.notifier).state = d
                .toIso8601String()
                .split("T")
                .first;
          // }
        } else {
          ref.invalidate(regDateProvider);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(value: 'All', child: Text('All')),
          const PopupMenuItem<String>(value: 'Today', child: Text('Today')),
          const PopupMenuItem<String>(
            value: 'Yesterday',
            child: Text('Yesterday'),
          ),
          const PopupMenuItem<String>(
            value: 'Choose date',
            child: Text('Choose date'),
          ),
        ];
      },
    );
  }
}
