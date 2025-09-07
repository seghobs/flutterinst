import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/comment_provider.dart';
import 'success_screen.dart';
import 'error_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String postUrl;
  
  const LoadingScreen({
    super.key,
    required this.postUrl,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _startChecking();
  }

  Future<void> _startChecking() async {
    final provider = context.read<CommentProvider>();
    await provider.checkComments(widget.postUrl);
    
    if (!mounted) return;
    
    if (provider.error != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF111122),
              Color(0xFF191933),
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<CommentProvider>(
            builder: (context, provider, child) {
              final progress = (provider.loadingProgress * 100).round();
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'Yorum Kontrol Yükleniyor...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lütfen bekleyin, yorumlar analiz ediliyor.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 80),
                  
                  // Circular Progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: provider.loadingProgress,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF9292C9),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$progress%',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Tamamlandı',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // Linear Progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: provider.loadingProgress,
                            minHeight: 10,
                            backgroundColor: Colors.grey.shade800,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF9292C9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tahmini kalan süre: ${_getRemainingTime(provider.loadingProgress)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getRemainingTime(double progress) {
    if (progress >= 1.0) return '0 saniye';
    if (progress >= 0.75) return '1 dakika';
    if (progress >= 0.5) return '2 dakika';
    return '3 dakika';
  }
}
