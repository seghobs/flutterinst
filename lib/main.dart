import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/comment_provider.dart';
import 'providers/cookie_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CookieProvider()),
        ChangeNotifierProxyProvider<CookieProvider, CommentProvider>(
          create: (context) => CommentProvider(
            cookieProvider: context.read<CookieProvider>(),
          ),
          update: (context, cookieProvider, previous) => 
              previous ?? CommentProvider(cookieProvider: cookieProvider),
        ),
      ],
      child: MaterialApp(
        title: 'Instagram Yorum Kontrolü',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF6366F1),
          scaffoldBackgroundColor: const Color(0xFF111827),
          textTheme: GoogleFonts.manropeTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6366F1),
            secondary: Color(0xFF8B5CF6),
            surface: Color(0xFF1F2937),
            background: Color(0xFF111827),
            error: Color(0xFFEF4444),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
