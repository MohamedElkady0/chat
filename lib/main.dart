import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat/core/theme/themes_app.dart';
import 'package:my_chat/fetcher/domian/auth/auth_cubit.dart';
import 'package:my_chat/fetcher/domian/theme/theme_cubit.dart';
import 'package:my_chat/fetcher/presentation/views/Introduction/page_view.dart';
import 'package:my_chat/fetcher/presentation/views/auth/view/welcome_page.dart';
import 'package:my_chat/fetcher/presentation/views/splach/splash_view.dart';
import 'package:my_chat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChatMy());
}

class ChatMy extends StatelessWidget {
  const ChatMy({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),

        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit()..checkAppState(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            themeMode: themeState.themeMode,
            theme: ThemesApp.light,
            darkTheme: ThemesApp.dark,
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is ShowOnboardingState) {
                  return PageViewMyChat();
                } else if (authState is AuthUnauthenticated) {
                  return WelcomeScreen();
                } else if (authState is AuthAuthenticated) {
                  return SplashView();
                } else {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
