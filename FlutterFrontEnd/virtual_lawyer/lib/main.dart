import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/themes/app_theme.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/bloc/chat_cubit.dart';
import 'presentation/bloc/app_settings_cubit.dart';
import 'presentation/bloc/app_settings_state.dart';
import 'core/localization/app_localizations.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const VirtualLawyerApp());
}

class VirtualLawyerApp extends StatelessWidget {
  const VirtualLawyerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<ChatCubit>(create: (context) => ChatCubit()),
        BlocProvider<AppSettingsCubit>(create: (context) => AppSettingsCubit()),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Virtual Lawyer',
            theme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            locale: settings.locale,
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
