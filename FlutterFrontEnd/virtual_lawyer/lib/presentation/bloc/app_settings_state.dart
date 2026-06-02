import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettingsState extends Equatable {
  final Locale locale;

  const AppSettingsState({
    required this.locale,
  });

  factory AppSettingsState.initial() {
    return const AppSettingsState(
      locale: Locale('ar'),
    );
  }

  AppSettingsState copyWith({
    Locale? locale,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale];
}
