import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../core/localization/app_localizations.dart';

class LawyerProfileScreen extends StatefulWidget {
  final UserModel lawyer;

  const LawyerProfileScreen({Key? key, required this.lawyer}) : super(key: key);

  @override
  _LawyerProfileScreenState createState() => _LawyerProfileScreenState();
}

class _LawyerProfileScreenState extends State<LawyerProfileScreen> {
  late DateTime _selectedDate;
  String? _selectedTimeSlot;

  final List<DateTime> _mockDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 2)),
  ];

  final List<String> _allTimeSlots = [
    "06:00 PM", "06:30 PM",
    "07:00 PM", "07:30 PM",
    "08:00 PM", "08:30 PM",
    "09:00 PM", "09:30 PM",
  ];

  // For visual demo matching the design, hardcode which slots are available
  // The design shows the right column and bottom row available.
  final List<String> _availableMockSlots = [
    "06:30 PM", "07:30 PM", "08:30 PM", "09:00 PM", "09:30 PM"
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = _mockDates[1]; // default select the middle one (like "TUE 23" in image)
  }

  String? _translateSpec(String? spec, AppLocalizations l10n) {
    if (spec == null) return null;
    switch (spec) {
      case 'Criminal Law': return l10n.translate('spec_criminal_law');
      case 'Family Law': return l10n.translate('spec_family_law');
      case 'Corporate Law': return l10n.translate('spec_corporate_law');
      case 'Real Estate Law': return l10n.translate('spec_real_estate_law');
      case 'Civil Rights': return l10n.translate('spec_civil_rights');
      case 'Immigration Law': return l10n.translate('spec_immigration_law');
      case 'Intellectual Property': return l10n.translate('spec_intellectual_property');
      case 'Other': return l10n.translate('spec_other');
      default: return spec;
    }
  }

  String _translateBio(UserModel lawyer, AppLocalizations l10n) {
    // Map known mock lawyer IDs to their bio localization keys
    switch (lawyer.id) {
      case '1': return l10n.translate('bio_ahmed');
      case '2': return l10n.translate('bio_layla');
      case '3': return l10n.translate('bio_mahmoud');
      default: return lawyer.bio ?? l10n.translate('bio_default');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black, // Dark background as per image
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Profile Card
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: widget.lawyer.photoPath != null
                            ? Image.network(widget.lawyer.photoPath!, width: 120, height: 120, fit: BoxFit.cover)
                            : Container(
                                width: 120,
                                height: 120,
                                color: Colors.black26,
                                child: const Icon(Icons.person, size: 60, color: AppTheme.primary),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.lawyer.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _translateSpec(widget.lawyer.specialization, l10n) ?? l10n.translate('senior_litigation_partner'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _translateBio(widget.lawyer, l10n),
                      style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 13),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Stats Capsules
              Row(
                children: [
                  Expanded(child: _buildStatCapsule(Icons.location_on, l10n.translate('office'), widget.lawyer.primaryCity ?? "Garden City,\nCairo")),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCapsule(Icons.money, l10n.translate('fee'), "${widget.lawyer.consultationFee ?? '2,500'}\nEGP")),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Contact Buttons
              // Contact Info (Static)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    _buildContactRow(
                      Icons.chat, 
                      l10n.translate('whatsapp'), 
                      widget.lawyer.whatsapp?.isNotEmpty == true ? widget.lawyer.whatsapp! : "+20 100 000 0000",
                      const Color(0xFF25D366),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Colors.white10, height: 1),
                    ),
                    _buildContactRow(
                      Icons.phone, 
                      l10n.translate('phone'), 
                      widget.lawyer.phone.isNotEmpty ? widget.lawyer.phone : "+20 100 000 0000",
                      const Color(0xFF4A90E2),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Location Text Block (replacing map)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.map_outlined, color: AppTheme.primary, size: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.translate('law_office_location'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(widget.lawyer.officeAddress ?? "123 Justice Avenue\nGarden City, Cairo", style: const TextStyle(color: Colors.white54, height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              // Consultation Schedule Container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_month, color: AppTheme.primary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.translate('consultation_schedule'),
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
                          ),
                        ),
                        Text(l10n.translate('cairo_time'), style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Dates Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _mockDates.map((date) => _buildDateSelector(date)).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Time Slots Grid
                    Wrap(
                      spacing: 12,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: _allTimeSlots.map((slot) => _buildTimeSlot(slot)).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Confirm Booking Button
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _selectedTimeSlot != null
                            ? () => _showConfirmationBottomSheet(context)
                            : null,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.translate('confirm_booking_for'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(
                              "${DateFormat('EEEE').format(_selectedDate)}, ${DateFormat('do').format(_selectedDate)}", 
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCapsule(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
          const SizedBox(height: 8),
          Text(value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(DateTime date) {
    bool isSelected = _selectedDate.day == date.day;
    String dayName = DateFormat('E').format(date).toUpperCase();
    String dayNum = DateFormat('dd').format(date);
    
    // Mock status based on design (Mon=Full, Tue=Today, Wed=Available)
    String status = "";
    if (date == _mockDates[0]) status = "FULL";
    else if (date == _mockDates[1]) status = "TODAY";
    else if (date == _mockDates[2]) status = "AVAILABLE";

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          _selectedTimeSlot = null; // reset time slot on date change
        });
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppTheme.primary : const Color(0xFF1E1E1E),
          boxShadow: isSelected ? [BoxShadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 15)] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dayName, style: TextStyle(color: isSelected ? Colors.black54 : Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
            Text(dayNum, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(status, style: TextStyle(color: isSelected ? Colors.black87 : (status == 'FULL' ? Colors.redAccent : AppTheme.primary), fontSize: 8, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) {
    final TextEditingController caseBriefController = TextEditingController();
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF121212),
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.translate('confirm_consultation'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.translate('review_request'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 48),
                      
                      // Selected Date & Time
                      Text(l10n.translate('selected_date_time'), style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.calendar_today, color: AppTheme.primary, size: 24),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${DateFormat('E, MMM d').format(_selectedDate)}th", 
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "at $_selectedTimeSlot (EET)",
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Counselor
                      Text(l10n.translate('counselor'), style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: widget.lawyer.photoPath != null
                                ? Image.network(widget.lawyer.photoPath!, width: 48, height: 48, fit: BoxFit.cover)
                                : Container(
                                    width: 48, height: 48, color: Colors.white.withOpacity(0.05),
                                    child: const Icon(Icons.person, color: AppTheme.primary, size: 24),
                                  ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Adv. ${widget.lawyer.name}",
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.lawyer.specialization ?? l10n.translate('sovereign_tier_specialist'),
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Case Brief
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${l10n.translate('tell_lawyer_about_case')} *",
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                            ),
                          ),
                          Text(l10n.translate('required_field'), textAlign: TextAlign.right, style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10, fontStyle: FontStyle.italic)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: caseBriefController,
                        maxLines: 5,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: l10n.translate('case_brief_hint'),
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 14),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.03),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
                          contentPadding: const EdgeInsets.all(24),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              
              // Footer
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text(l10n.translate('consultation_fee'), style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  Text(
                    "${widget.lawyer.consultationFee ?? '2,500'} EGP",
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (caseBriefController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.translate('provide_case_brief'))),
                        );
                        return;
                      }
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.teal,
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 12),
                              Text("${l10n.translate('booking_request_sent')} ${widget.lawyer.name}"),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text(l10n.translate('confirm_send_request'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    bool isAvailable = _availableMockSlots.contains(time);
    bool isSelected = _selectedTimeSlot == time;

    return GestureDetector(
      onTap: isAvailable ? () {
        setState(() {
          _selectedTimeSlot = time;
        });
      } : null,
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAvailable ? (isSelected ? AppTheme.primary : AppTheme.primary.withOpacity(0.5)) : Colors.white10,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: isSelected ? Colors.black : (isAvailable ? Colors.white : Colors.white24),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
