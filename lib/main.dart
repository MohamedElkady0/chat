import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_chat/core/theme/save_theme.dart';
import 'package:my_chat/core/theme/themes_app.dart';
import 'package:my_chat/fetcher/presentation/views/home/home.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ChatMy(),
    ),
  );
}

class ChatMy extends StatelessWidget {
  const ChatMy({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
          theme: ThemesApp.light,
          darkTheme: ThemesApp.dark,
          themeMode: themeProvider.themeMode,
          home: HomePage(),
        );
      },
    );
  }
}
