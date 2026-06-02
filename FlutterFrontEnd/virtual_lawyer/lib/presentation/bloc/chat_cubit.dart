import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/message.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  static final List<Message> _welcomeMessage = [
    Message(text: "Greetings, Advocate. I have indexed the latest Egyptian Statutes and relevant Judicial Archives. How may I assist your litigation preparation today?", isUser: false),
  ];

  ChatCubit() : super(ChatLoaded(List.from(_welcomeMessage)));

  void sendMessage(String text) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final newMessages = List<Message>.from(currentState.messages);
      newMessages.add(Message(text: text, isUser: true));
      emit(ChatLoaded(newMessages, history: currentState.history));
      
      // Simulate AI response
      await Future.delayed(const Duration(seconds: 1));
      
      final aiMessages = List<Message>.from(newMessages);
      aiMessages.add(Message(text: "Based on the latest indexed statutes, here is a preliminary analysis concerning your query about: '$text'.", isUser: false));
      emit(ChatLoaded(aiMessages, history: currentState.history));
    }
  }

  void sendAttachment(String fileName) async {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final newMessages = List<Message>.from(currentState.messages);
      newMessages.add(Message(text: "Sent attachment", isUser: true, isAttachment: true, attachmentName: fileName));
      emit(ChatLoaded(newMessages, history: currentState.history));
      
      await Future.delayed(const Duration(seconds: 1));
      
      final aiMessages = List<Message>.from(newMessages);
      aiMessages.add(Message(text: "I have successfully analyzed '$fileName'. What specific insights are you looking for from this document?", isUser: false));
      emit(ChatLoaded(aiMessages, history: currentState.history));
    }
  }

  void startNewChat() {
    final currentState = state;
    if (currentState is ChatLoaded) {
      final newHistory = List<List<Message>>.from(currentState.history);
      // Only save to history if user actually sent something
      if (currentState.messages.length > 1) {
        newHistory.insert(0, List<Message>.from(currentState.messages));
      }
      emit(ChatLoaded(List<Message>.from(_welcomeMessage), history: newHistory));
    }
  }

  void loadChat(int historyIndex) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      if (historyIndex >= 0 && historyIndex < currentState.history.length) {
        final newHistory = List<List<Message>>.from(currentState.history);
        final chatToLoad = newHistory.removeAt(historyIndex);
        
        // Save current chat to history if it has user messages
        if (currentState.messages.length > 1) {
          newHistory.insert(0, List<Message>.from(currentState.messages));
        }
        
        emit(ChatLoaded(List<Message>.from(chatToLoad), history: newHistory));
      }
    }
  }
}
