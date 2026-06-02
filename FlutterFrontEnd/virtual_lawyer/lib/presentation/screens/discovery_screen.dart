import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../core/localization/app_localizations.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({Key? key}) : super(key: key);

  @override
  _DiscoveryScreenState createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  // Internal keys for filtering (match lawyer.specialization values)
  final List<String> _specKeys = [
    'All',
    'Criminal Law',
    'Family Law',
    'Corporate Law',
    'Real Estate Law',
    'Civil Rights',
    'Immigration Law',
    'Intellectual Property',
    'Other'
  ];

  // Maps internal key to localization key
  String _specLocaleKey(String specKey) {
    switch (specKey) {
      case 'All': return 'spec_all';
      case 'Criminal Law': return 'spec_criminal_law';
      case 'Family Law': return 'spec_family_law';
      case 'Corporate Law': return 'spec_corporate_law';
      case 'Real Estate Law': return 'spec_real_estate_law';
      case 'Civil Rights': return 'spec_civil_rights';
      case 'Immigration Law': return 'spec_immigration_law';
      case 'Intellectual Property': return 'spec_intellectual_property';
      case 'Other': return 'spec_other';
      default: return specKey;
    }
  }

  final List<UserModel> _mockLawyers = [
    UserModel(
      id: '1',
      name: 'Adv. Ahmed El-Sayed',
      email: 'ahmed@example.com',
      phone: '01012345678',
      password: '',
      role: 'Lawyer',
      specialization: 'Criminal Law',
      consultationFee: '500',
      bio: 'Senior Criminal Litigator with 15 years of experience in high-profile cases.',
      availableTimeSlots: ['2023-11-20 10:00', '2023-11-20 14:00'],
      primaryCity: 'Cairo',
      officeAddress: '123 Justice St, Cairo',
    ),
    UserModel(
      id: '2',
      name: 'Adv. Layla Fathy',
      email: 'layla@example.com',
      phone: '01087654321',
      password: '',
      role: 'Lawyer',
      specialization: 'Corporate Law',
      consultationFee: '1200',
      bio: 'Corporate & Commercial Law expert, handling mergers and acquisitions.',
      availableTimeSlots: ['2023-11-21 09:00', '2023-11-21 16:00'],
      primaryCity: 'Alexandria',
      officeAddress: '45 Business Blvd, Alexandria',
    ),
    UserModel(
      id: '3',
      name: 'Adv. Mahmoud Kamel',
      email: 'mahmoud@example.com',
      phone: '01122334455',
      password: '',
      role: 'Lawyer',
      specialization: 'Family Law',
      consultationFee: '750',
      bio: 'Family & Civil Specialist dedicated to peaceful dispute resolutions.',
      availableTimeSlots: ['2023-11-22 11:00', '2023-11-22 15:00'],
      primaryCity: 'Giza',
      officeAddress: '78 Pyramids Ave, Giza',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Filter the lawyers
    final filteredLawyers = _mockLawyers.where((lawyer) {
      final matchesFilter = _selectedFilter == 'All' || lawyer.specialization == _selectedFilter;
      final matchesSearch = lawyer.name.toLowerCase().contains(_searchController.text.toLowerCase()) || 
                            (lawyer.primaryCity?.toLowerCase().contains(_searchController.text.toLowerCase()) ?? false);
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.translate('find_your_counsel'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Search text field
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_search, color: Colors.white54),
                  hintText: l10n.translate('search_by_name_city'),
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Horizontal Chips - localized
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _specKeys.map((specKey) => _buildChip(specKey, l10n)).toList(),
              ),
            ),
            const SizedBox(height: 32),
            // Lawyer Cards
            Expanded(
              child: filteredLawyers.isEmpty
                  ? Center(child: Text(l10n.translate('no_lawyers_found'), style: const TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      itemCount: filteredLawyers.length,
                      itemBuilder: (context, index) {
                        return _buildLawyerCard(filteredLawyers[index], l10n);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String specKey, AppLocalizations l10n) {
    bool isActive = _selectedFilter == specKey;
    final displayLabel = l10n.translate(_specLocaleKey(specKey));
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = specKey;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          displayLabel,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLawyerCard(UserModel lawyer, AppLocalizations l10n) {
    // Translate the specialization for display
    final displaySpec = l10n.translate(_specLocaleKey(lawyer.specialization ?? ''));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30, 
                backgroundColor: Colors.black26, 
                backgroundImage: lawyer.photoPath != null ? NetworkImage(lawyer.photoPath!) : null,
                child: lawyer.photoPath == null ? const Icon(Icons.person, color: AppTheme.primary) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lawyer.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(displaySpec, style: const TextStyle(color: AppTheme.primary, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("4.9 (124 ${l10n.translate('reviews')})", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.translate('consultation'), style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
                  Text("${lawyer.consultationFee ?? 'N/A'} EGP", style: const TextStyle(color: AppTheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  context.push('/lawyer_profile', extra: lawyer);
                },
                child: Text(l10n.translate('view_profile'), style: const TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }
}
