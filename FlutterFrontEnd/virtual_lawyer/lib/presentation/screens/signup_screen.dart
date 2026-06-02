import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/auth_cubit.dart';
import '../../../core/themes/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../core/localization/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = 'User';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _primaryCityController = TextEditingController();
  final _birthDateController = TextEditingController();
  
  // Lawyer specific
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _consultationFeeController = TextEditingController();
  final _bioController = TextEditingController();
  String? _selectedSpecialization;

  final List<String> _specializations = [
    'spec_criminal_law',
    'spec_family_law',
    'spec_corporate_law',
    'spec_real_estate_law',
    'spec_civil_rights',
    'spec_immigration_law',
    'spec_intellectual_property',
    'spec_other'
  ];
  
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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

    if (pickedDate != null) {
      setState(() {
        _birthDateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _primaryCityController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _officeAddressController.dispose();
    _consultationFeeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.surfaceVariant,
                    backgroundImage: _profileImage != null 
                        ? (kIsWeb ? NetworkImage(_profileImage!.path) : FileImage(File(_profileImage!.path))) as ImageProvider
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.add_a_photo_outlined, size: 40, color: AppTheme.primary)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.translate('create_account'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate('join_to_get_started'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Role Selection
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleSelector(l10n.translate('user'), Icons.person_outline, 'User'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRoleSelector(l10n.translate('lawyer'), Icons.gavel_outlined, 'Lawyer'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildTextField(l10n.translate('full_name'), Icons.badge_outlined, false, _nameController),
                const SizedBox(height: 16),
                _buildTextField(l10n.translate('email_address'), Icons.email_outlined, false, _emailController),
                const SizedBox(height: 16),
                _buildTextField(l10n.translate('password'), Icons.lock_outline, true, _passwordController),
                const SizedBox(height: 16),
                _buildTextField(l10n.translate('primary_city'), Icons.location_city_outlined, false, _primaryCityController),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: () => _selectBirthDate(context),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.translate('birth_date'),
                    hintStyle: const TextStyle(color: Colors.white24),
                    prefixIcon: const Icon(Icons.calendar_month_outlined, color: Colors.white54),
                    filled: true,
                    fillColor: AppTheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                if (selectedRole == 'Lawyer') ...[
                  const SizedBox(height: 16),
                  _buildTextField(l10n.translate('phone_number'), Icons.phone_outlined, false, _phoneController),
                  const SizedBox(height: 16),
                  _buildTextField(l10n.translate('whatsapp_line'), Icons.chat_outlined, false, _whatsappController),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedSpecialization,
                    dropdownColor: AppTheme.surfaceVariant,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.translate('select_specialization'),
                      hintStyle: const TextStyle(color: Colors.white24),
                      prefixIcon: const Icon(Icons.work_outline, color: Colors.white54),
                      filled: true,
                      fillColor: AppTheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: _specializations.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(l10n.translate(value)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSpecialization = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(l10n.translate('office_address'), Icons.location_on_outlined, false, _officeAddressController),
                  const SizedBox(height: 16),
                  _buildTextField(l10n.translate('consultation_fee_egp'), Icons.attach_money_outlined, false, _consultationFeeController, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildTextField(l10n.translate('professional_bio'), Icons.description_outlined, false, _bioController, maxLines: 4),
                ],

                const SizedBox(height: 32),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    final user = UserModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text.isNotEmpty ? _nameController.text : "New $selectedRole",
                      email: _emailController.text,
                      phone: selectedRole == 'Lawyer' ? _phoneController.text : '',
                      password: _passwordController.text,
                      photoPath: _profileImage?.path,
                      role: selectedRole,
                      primaryCity: _primaryCityController.text,
                      birthDate: _birthDateController.text,
                      whatsapp: selectedRole == 'Lawyer' ? _whatsappController.text : null,
                      specialization: selectedRole == 'Lawyer' ? _selectedSpecialization : null,
                      officeAddress: selectedRole == 'Lawyer' ? _officeAddressController.text : null,
                      consultationFee: selectedRole == 'Lawyer' ? _consultationFeeController.text : null,
                      bio: selectedRole == 'Lawyer' ? _bioController.text : null,
                    );
                    context.read<AuthCubit>().signUp(user);
                    context.go('/chat');
                  },
                  child: Text(l10n.translate('signup'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.translate('already_have_account'), style: const TextStyle(color: Colors.white54)),
                    TextButton(
                      onPressed: () => context.pushReplacement('/login'),
                      child: Text(l10n.translate('login'), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector(String displayLabel, IconData icon, String roleValue) {
    bool isSelected = selectedRole == roleValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = roleValue;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppTheme.primary : Colors.white54, size: 32),
            const SizedBox(height: 8),
            Text(
              displayLabel,
              style: TextStyle(
                color: isSelected ? AppTheme.primary : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, bool obscureText, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.white54) : Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Icon(icon, color: Colors.white54),
        ),
        filled: true,
        fillColor: AppTheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
