import 'package:flutter/material.dart';
import '../../../core/themes/app_theme.dart';
import '../../core/localization/app_localizations.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({Key? key}) : super(key: key);

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  int _selectedDateIndex = 1; // Tue 23

  final List<Map<String, dynamic>> _dates = [
    {"day": "Mon", "date": "22", "status": "Full", "enabled": false},
    {"day": "Tue", "date": "23", "status": "Today", "enabled": true},
    {"day": "Wed", "date": "24", "status": "Available", "enabled": true},
    {"day": "Thu", "date": "25", "status": "Available", "enabled": true},
    {"day": "Fri", "date": "26", "status": "Closed", "enabled": false},
    {"day": "Sat", "date": "27", "status": "Available", "enabled": true},
    {"day": "Sun", "date": "28", "status": "Available", "enabled": true},
  ];

  final List<String> _timeSlots = [
    "06:00 PM", "06:30 PM", "07:00 PM", "07:30 PM",
    "08:00 PM", "08:30 PM", "09:00 PM", "09:30 PM"
  ];

  late Set<String> _activeSlots;

  @override
  void initState() {
    super.initState();
    _activeSlots = {
      "06:30 PM", "07:00 PM", "07:30 PM",
      "08:30 PM", "09:00 PM", "09:30 PM"
    };
  }

  Future<void> _addCustomTimeSlot() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              onPrimary: Colors.black,
              surface: AppTheme.surfaceVariant,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        final String formattedTime = pickedTime.format(context);
        if (!_timeSlots.contains(formattedTime)) {
          _timeSlots.add(formattedTime);
          _timeSlots.sort((a, b) => a.compareTo(b)); // Basic sort
        }
        _activeSlots.add(formattedTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.translate('my_availability'), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(l10n.translate('save'), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(l10n.translate('set_weekly_slots'), l10n.translate('manage_default_hours')),
            const SizedBox(height: 32),
            _buildDatePicker(),
            const SizedBox(height: 48),
            _buildSectionHeader(l10n.translate('time_slots'), l10n.translate('select_available_times')),
            const SizedBox(height: 24),
            _buildTimeGrid(),
            const SizedBox(height: 48),
            _buildActionButtons(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = _dates[index];
          final isSelected = _selectedDateIndex == index;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.1),
                ),
                boxShadow: isSelected ? [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 15, spreadRadius: 1)
                ] : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date["day"],
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date["date"],
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date["status"],
                    style: TextStyle(
                      color: isSelected ? Colors.black.withOpacity(0.6) : (date["enabled"] ? AppTheme.primary : Colors.redAccent.withOpacity(0.5)),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _timeSlots.length,
      itemBuilder: (context, index) {
        final time = _timeSlots[index];
        final isAvailable = _activeSlots.contains(time);
        
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isAvailable) {
                _activeSlots.remove(time);
              } else {
                _activeSlots.add(time);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isAvailable ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAvailable ? AppTheme.primary.withOpacity(0.5) : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isAvailable ? Colors.white : Colors.white.withOpacity(0.2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isAvailable ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: isAvailable ? AppTheme.primary : Colors.white.withOpacity(0.2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _addCustomTimeSlot,
          icon: const Icon(Icons.add),
          label: Text(l10n.translate('add_custom_time_slot')),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.surfaceVariant,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.block, size: 18),
          label: Text(l10n.translate('mark_day_closed')),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
        ),
      ],
    );
  }
}
