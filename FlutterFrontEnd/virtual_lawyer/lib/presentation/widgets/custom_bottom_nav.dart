import 'package:flutter/material.dart';
import 'guest_action_wrapper.dart';
import '../../core/themes/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.surface.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 48,
            offset: const Offset(0, -24),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GuestActionWrapper(
            onTap: () {},
            child: const _NavItem(icon: Icons.account_balance, label: "Gateway", isActive: false),
          ),
          const _NavItem(icon: Icons.smart_toy, label: "Engine", isActive: true),
          GuestActionWrapper(
            onTap: () {},
            child: const _NavItem(icon: Icons.person_search, label: "Discovery", isActive: false),
          ),
          GuestActionWrapper(
            onTap: () {}, 
            child: const _NavItem(icon: Icons.dashboard_customize, label: "Vault", isActive: false),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({Key? key, required this.icon, required this.label, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? AppTheme.background : AppTheme.textOnSurface.withOpacity(0.6)),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? AppTheme.background : AppTheme.textOnSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
