import 'package:equatable/equatable.dart';
import '../../../data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticatedUser extends AuthState {
  final UserModel user;
  const AuthenticatedUser(this.user);
  
  @override
  List<Object> get props => [user];
}

class AuthenticatedLawyer extends AuthState {
  final UserModel user;
  const AuthenticatedLawyer(this.user);
  
  @override
  List<Object> get props => [user];
}

class GuestUser extends AuthState {}
