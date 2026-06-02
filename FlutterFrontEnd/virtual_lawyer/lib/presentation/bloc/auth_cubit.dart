import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../../data/models/user_model.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void signUp(UserModel user) {
    if (user.role == 'Lawyer') {
      emit(AuthenticatedLawyer(user));
    } else {
      emit(AuthenticatedUser(user));
    }
  }

  void updateUser(UserModel updatedUser) {
    if (state is AuthenticatedLawyer) {
      emit(AuthenticatedLawyer(updatedUser));
    } else if (state is AuthenticatedUser) {
      emit(AuthenticatedUser(updatedUser));
    }
  }

  void loginAsUser() {
    emit(AuthenticatedUser(UserModel(id: '1', name: 'Test User', email: 'user@test.com', phone: '1234567890', password: 'password', role: 'User')));
  }
  
  void loginAsLawyer() {
    emit(AuthenticatedLawyer(UserModel(id: '2', name: 'Test Lawyer', email: 'lawyer@test.com', phone: '0987654321', password: 'password', role: 'Lawyer')));
  }

  void continueAsGuest() => emit(GuestUser());
  void logout() => emit(AuthInitial());
}
