import 'package:equatable/equatable.dart';
import '../../../data/models/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}
class ChatLoaded extends ChatState {
  final List<Message> messages;
  final List<List<Message>> history;
  const ChatLoaded(this.messages, {this.history = const []});
  @override
  List<Object> get props => [messages, history];
}
