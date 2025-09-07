import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cookie_provider.dart';
import '../models/cookie.dart';

class CookiesScreen extends StatefulWidget {
  const CookiesScreen({super.key});

  @override
  State<CookiesScreen> createState() => _CookiesScreenState();
}

class _CookiesScreenState extends State<CookiesScreen> {
  final _cookieController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cookieController.dispose();
    super.dispose();
  }

  Future<void> _saveCookies() async {
    if (_cookieController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen çerez bilgilerini girin!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    final provider = context.read<CookieProvider>();
    final success = await provider.saveCookies(_cookieController.text);
    
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Çerezler başarıyla kaydedildi!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      _cookieController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geçersiz JSON formatı! Lütfen doğru formatta girin.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _clearCookies() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: const Text(
          'Emin misiniz?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Tüm çerezler silinecektir.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<CookieProvider>().clearCookies();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Çerezler temizlendi!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              'Sil',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F1A),
              Color(0xFF151526),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F1A).withOpacity(0.8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Çerezler',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cookie Settings Input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Instagram Çerezleri (JSON Format)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.help_outline,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF1F2937),
                                  title: const Text(
                                    'Nasıl Kullanılır?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      '1. Chrome/Firefox\'ta Instagram\'a giriş yapın\n'
                                      '2. F12 ile Developer Tools\'u açın\n'
                                      '3. Application/Storage > Cookies bölümüne gidin\n'
                                      '4. instagram.com çerezlerini JSON olarak export edin\n'
                                      '5. JSON array\'i buraya yapıştırın\n\n'
                                      'Örnek Format:\n[{"name": "sessionid", "value": "...", ...}]',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Tamam'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade700.withOpacity(0.5),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _cookieController,
                          maxLines: 10,
                          style: TextStyle(
                            color: Colors.grey.shade200,
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                          decoration: InputDecoration(
                            hintText: '[\n  {\n    "name": "sessionid",\n    "value": "...",\n    "domain": ".instagram.com"\n  }\n]',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                              fontFamily: 'monospace',
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Save and Clear Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: _clearCookies,
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text(
                              'Temizle',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _saveCookies,
                              icon: _isLoading 
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.save, size: 20),
                              label: Text(
                                _isLoading ? 'Kaydediliyor...' : 'Kaydet',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      
                      // Current Cookies
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mevcut Çerezler',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Consumer<CookieProvider>(
                            builder: (context, provider, child) {
                              if (provider.cookies.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Chip(
                                label: Text(
                                  '${provider.cookies.length} adet',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF6366F1),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<CookieProvider>(
                        builder: (context, provider, child) {
                          if (provider.cookies.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade800,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cookie_outlined,
                                    size: 48,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Henüz çerez eklenmedi',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Instagram çerezlerinizi JSON formatında ekleyin',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          
                          // Önemli çerezleri filtrele ve göster
                          final importantCookies = provider.cookies.where((c) => 
                            ['sessionid', 'csrftoken', 'ds_user_id', 'mid', 'ig_did'].contains(c.name)
                          ).toList();
                          
                          return Column(
                            children: [
                              ...importantCookies.map((cookie) => Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF1A1A2E).withOpacity(0.6),
                                      const Color(0xFF2A2A46).withOpacity(0.6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: cookie.name == 'sessionid' 
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.grey.shade700.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          cookie.name == 'sessionid' 
                                              ? Icons.key 
                                              : Icons.cookie_outlined,
                                          size: 20,
                                          color: cookie.name == 'sessionid'
                                              ? Colors.green
                                              : Colors.grey.shade400,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          cookie.name,
                                          style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (cookie.name == 'sessionid')
                                          Container(
                                            margin: const EdgeInsets.only(left: 8),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Aktif',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cookie.value.length > 50 
                                          ? '${cookie.value.substring(0, 50)}...'
                                          : cookie.value,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 13,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cookie.displayExpiry,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                              if (provider.cookies.length > importantCookies.length)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade900.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    've ${provider.cookies.length - importantCookies.length} diğer çerez',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
