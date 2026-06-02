import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_sidebar.dart';
import '../widgets/guest_action_wrapper.dart';
import '../bloc/chat_cubit.dart';
import '../bloc/chat_state.dart';
import '../../../core/themes/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../../../data/models/user_model.dart';
import '../../core/localization/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      drawer: const CustomSidebar(),
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.gavel, color: AppTheme.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(AppLocalizations.of(context).translate('app_title'), style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          GuestActionWrapper(
            onTap: () => context.push('/profile'),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  UserModel? user;
                  if (state is AuthenticatedUser) user = state.user;
                  if (state is AuthenticatedLawyer) user = state.user;
                  
                  return CircleAvatar(
                    backgroundColor: AppTheme.surfaceVariant,
                    backgroundImage: (user?.photoPath != null) 
                        ? (kIsWeb ? NetworkImage(user!.photoPath!) : FileImage(File(user!.photoPath!))) as ImageProvider
                        : null,
                    child: (user?.photoPath == null) 
                        ? const Icon(Icons.person, color: AppTheme.textOnSurface)
                        : null,
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Background watermark
          const Center(
            child: Icon(Icons.balance, size: 300, color: Colors.white10),
          ),
          Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final msg = state.messages[index];
                          return Align(
                            alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              decoration: BoxDecoration(
                                color: msg.isUser ? AppTheme.userMessage : AppTheme.aiMessage,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: Radius.circular(msg.isUser ? 16 : 0),
                                  bottomRight: Radius.circular(msg.isUser ? 0 : 16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: msg.isAttachment
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.picture_as_pdf, color: AppTheme.primary),
                                        const SizedBox(width: 8),
                                        Flexible(child: Text(msg.attachmentName ?? "Document", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                      ],
                                    )
                                  : Text(msg.text, style: const TextStyle(color: Colors.white, height: 1.5)),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
          // Input specific to engine (can be used by guests!)
          Positioned(
            bottom: 0, // Adjusted to screen bottom
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 24, offset: Offset(0, 10))],
              ),
              child: Row(
                children: [
                  GuestActionWrapper(
                    onTap: () {
                      context.read<ChatCubit>().sendAttachment("Contract_Review_Draft.pdf");
                    },
                    child: const Icon(Icons.attachment, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).translate('chat_hint'),
                        hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      radius: 18,
                      child: Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                    ),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        context.read<ChatCubit>().sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
