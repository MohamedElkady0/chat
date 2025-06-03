import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_chat/fetcher/presentation/views/auth/view/welcome_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatMy());
}

ColorScheme lightColorScheme = const ColorScheme.light(
  primary: Color(0xFF6200EE),
  onPrimary: Colors.white,
  secondary: Color(0xFF03DAC6),
  onSecondary: Colors.black,
  surface: Colors.yellow,
  onSurface: Colors.grey,
);

ColorScheme darkColorScheme = const ColorScheme.dark(
  primary: Color(0xFFBB86FC),
  onPrimary: Colors.black,
  secondary: Color(0xFF03DAC6),
  onSecondary: Colors.black,
  surface: Colors.grey,
  onSurface: Colors.white,
);

class ChatMy extends StatelessWidget {
  const ChatMy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system,
      home: WelcomeScreen(),
    );
  }
}
