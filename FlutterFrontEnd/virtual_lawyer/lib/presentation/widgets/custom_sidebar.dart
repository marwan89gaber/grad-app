import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'guest_action_wrapper.dart';
import '../../core/themes/app_theme.dart';
import '../bloc/chat_cubit.dart';
import '../bloc/chat_state.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../core/localization/app_localizations.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          GestureDetector(
            onTap: () {
              context.read<ChatCubit>().startNewChat();
              Navigator.pop(context);
              context.go('/chat');
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(l10n.translate('new_chat'), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GuestActionWrapper(
            onTap: () {
              Navigator.pop(context);
              context.push('/discovery');
            }, 
            child: ListTile(
              leading: const Icon(Icons.person_search, color: AppTheme.primary),
              title: Text(l10n.translate('find_lawyer'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
          ),
          GuestActionWrapper(
            onTap: () {
              Navigator.pop(context);
              context.push('/booking_requests');
            }, 
            child: ListTile(
              leading: const Icon(Icons.calendar_month, color: AppTheme.primary),
              title: Text(l10n.translate('booking_requests'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is AuthenticatedLawyer) {
                return GuestActionWrapper(
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/my_schedule');
                  },
                  child: ListTile(
                    leading: const Icon(Icons.schedule, color: AppTheme.primary),
                    title: Text(l10n.translate('my_schedule'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          GuestActionWrapper(
            onTap: () {
              Navigator.pop(context);
              context.push('/settings');
            }, 
            child: ListTile(
              leading: const Icon(Icons.settings, color: AppTheme.primary),
              title: Text(l10n.translate('settings'), style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
          ),
          const Divider(color: Colors.white24, height: 40),
          Text(l10n.translate('recent_history'), style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 10),
          
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state is ChatLoaded && state.history.isNotEmpty) {
                 return Column(
                   children: state.history.asMap().entries.map((entry) {
                      final index = entry.key;
                      final chatList = entry.value;
                      // Get the first user message as the title
                      String titleMessage = l10n.translate('new_conversation');
                      for (final msg in chatList) {
                        if (msg.isUser) {
                          titleMessage = msg.text;
                          break;
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          context.read<ChatCubit>().loadChat(index);
                          Navigator.pop(context);
                          context.go('/chat');
                        },
                        child: ListTile(
                          leading: Icon(Icons.chat_bubble_outline, color: AppTheme.primary.withOpacity(0.5), size: 18),
                          title: Text(
                            titleMessage,
                            style: const TextStyle(color: AppTheme.textOnSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(l10n.translate('archived'), style: TextStyle(color: AppTheme.textOnSurface.withOpacity(0.5), fontSize: 10)),
                        ),
                      );
                   }).toList(),
                 );
              }
              // Empty state
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    l10n.translate('new_conversation'),
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
