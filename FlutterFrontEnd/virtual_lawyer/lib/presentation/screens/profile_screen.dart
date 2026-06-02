import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/themes/app_theme.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../data/models/user_model.dart';
import '../../core/localization/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    'Criminal Law',
    'Family Law',
    'Corporate Law',
    'Real Estate Law',
    'Civil Rights',
    'Immigration Law',
    'Intellectual Property',
    'Other'
  ];
  
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isInitialized = false;

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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel? currentUser;
        if (state is AuthenticatedUser) {
          currentUser = state.user;
        } else if (state is AuthenticatedLawyer) {
          currentUser = state.user;
        }

        if (currentUser != null && !_isInitialized) {
          _nameController.text = currentUser.name;
          _emailController.text = currentUser.email;
          _passwordController.text = currentUser.password;
          _primaryCityController.text = currentUser.primaryCity ?? '';
          _birthDateController.text = currentUser.birthDate ?? '';
          
          if (currentUser.role == 'Lawyer') {
            _phoneController.text = currentUser.phone;
            _whatsappController.text = currentUser.whatsapp ?? '';
            _selectedSpecialization = currentUser.specialization;
            _officeAddressController.text = currentUser.officeAddress ?? '';
            _consultationFeeController.text = currentUser.consultationFee ?? '';
            _bioController.text = currentUser.bio ?? '';
          }
          
          if (currentUser.photoPath != null) {
            _profileImage = XFile(currentUser.photoPath!);
          }
          _isInitialized = true;
        }

        return Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            backgroundColor: Colors.black87,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
              onPressed: () => context.pop(),
            ),
            title: Text(l10n.translate('edit_profile'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 32),
                _buildField(l10n.translate('full_name'), l10n.translate('your_name'), _nameController),
                const SizedBox(height: 16),
                _buildField(l10n.translate('email_address'), "you@example.com", _emailController),
                const SizedBox(height: 16),
                _buildField(l10n.translate('password'), "********", _passwordController, obscureText: true),
                const SizedBox(height: 16),
                _buildField(l10n.translate('primary_city'), l10n.translate('primary_city'), _primaryCityController),
                const SizedBox(height: 16),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.translate('birth_date'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _birthDateController,
                      readOnly: true,
                      onTap: () => _selectBirthDate(context),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "YYYY-MM-DD",
                        hintStyle: const TextStyle(color: Colors.white24),
                        filled: true,
                        fillColor: AppTheme.surfaceVariant,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),

                if (currentUser?.role == 'Lawyer') ...[
                  const SizedBox(height: 16),
                  _buildField(l10n.translate('phone_number'), l10n.translate('phone_number'), _phoneController),
                  const SizedBox(height: 16),
                  _buildField(l10n.translate('whatsapp_line'), l10n.translate('whatsapp_line'), _whatsappController),
                  const SizedBox(height: 16),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.translate('specialization'), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSpecialization,
                        dropdownColor: AppTheme.surfaceVariant,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: l10n.translate('select_specialization'),
                          hintStyle: const TextStyle(color: Colors.white24),
                          filled: true,
                          fillColor: AppTheme.surfaceVariant,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _specializations.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSpecialization = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  _buildField(l10n.translate('office_address'), l10n.translate('office_address'), _officeAddressController),
                  const SizedBox(height: 16),
                  _buildField(l10n.translate('consultation_fee_egp'), "e.g. 500", _consultationFeeController, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _buildField(l10n.translate('professional_bio'), l10n.translate('professional_bio'), _bioController, maxLines: 4),
                  
                ],

                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    if (currentUser != null) {
                      final updatedUser = currentUser.copyWith(
                        name: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        photoPath: _profileImage?.path,
                        primaryCity: _primaryCityController.text,
                        birthDate: _birthDateController.text,
                        phone: currentUser.role == 'Lawyer' ? _phoneController.text : '',
                        whatsapp: currentUser.role == 'Lawyer' ? _whatsappController.text : null,
                        specialization: currentUser.role == 'Lawyer' ? _selectedSpecialization : null,
                        officeAddress: currentUser.role == 'Lawyer' ? _officeAddressController.text : null,
                        consultationFee: currentUser.role == 'Lawyer' ? _consultationFeeController.text : null,
                        bio: currentUser.role == 'Lawyer' ? _bioController.text : null,
                        availableTimeSlots: currentUser.role == 'Lawyer' ? currentUser.availableTimeSlots : null,
                      );
                      context.read<AuthCubit>().updateUser(updatedUser);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.translate('profile_updated'))),
                      );
                      context.pop();
                    }
                  },
                  child: Text(l10n.translate('save_changes'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {bool obscureText = false, int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: AppTheme.surfaceVariant,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
