import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../bloc/app_settings_cubit.dart';
import '../bloc/app_settings_state.dart';
import '../../core/localization/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, settings) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.black87,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.primaryColor),
              onPressed: () => context.pop(),
            ),
            title: Text(
              l10n.translate('settings'),
              style: TextStyle(color: theme.textTheme.displayLarge?.color, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.translate('refine_legal_agency').split('.')[0] + '.',
                  style: TextStyle(color: theme.textTheme.displayLarge?.color, fontSize: 32, fontWeight: FontWeight.w800, height: 1.1),
                ),
                const SizedBox(height: 40),

                _buildCard(
                  context, 
                  Icons.person, 
                  l10n.translate('profile'), 
                  l10n.translate('view_personal_details'), 
                  onTap: () => context.push('/profile'),
                ),
                const SizedBox(height: 12),
                
                _buildToggleCard(
                  context,
                  Icons.language, 
                  l10n.translate('language'), 
                  settings.locale.languageCode == 'ar' ? "العربية" : "English", 
                  settings.locale.languageCode == 'ar',
                  onChanged: (val) {
                    context.read<AppSettingsCubit>().setLocale(val ? const Locale('ar') : const Locale('en'));
                  },
                ),
                const SizedBox(height: 12),
                
                _buildCard(
                  context, 
                  Icons.calendar_month, 
                  l10n.translate('booking_requests'), 
                  l10n.translate('manage_appointments'),
                  onTap: () => context.push('/booking_requests'),
                ),
                
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    if (authState is AuthenticatedLawyer) {
                      return Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildCard(
                            context, 
                            Icons.schedule, 
                            l10n.translate('my_schedule'), 
                            l10n.translate('manage_availability'),
                            onTap: () => context.push('/my_schedule'),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                
                const SizedBox(height: 12),
                _buildCard(context, Icons.smart_toy, l10n.translate('about'), l10n.translate('about_project')),
                
                const SizedBox(height: 60),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.dividerColor),
                    foregroundColor: theme.textTheme.bodyLarge?.color,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    context.go('/');
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                  label: Text(l10n.translate('logout')),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "${l10n.translate('version')} 2.4.0 • ${l10n.translate('app_title').toUpperCase()}", 
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.3), fontSize: 10, letterSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: theme.primaryColor.withOpacity(0.1), child: Icon(icon, color: theme.primaryColor)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: TextStyle(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleCard(BuildContext context, IconData icon, String title, String subtitle, bool currentVal, {required ValueChanged<bool> onChanged}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: theme.primaryColor.withOpacity(0.1), child: Icon(icon, color: theme.primaryColor)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: currentVal, 
            onChanged: onChanged, 
            activeColor: theme.primaryColor, 
            inactiveTrackColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
