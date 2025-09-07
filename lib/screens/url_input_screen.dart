import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/comment_provider.dart';
import 'loading_screen.dart';

class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  State<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen> {
  final _groupMembersController = TextEditingController();
  final _allowedUsersController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _groupMembersController.dispose();
    _allowedUsersController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_urlController.text.isEmpty || _groupMembersController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen URL ve grup üyelerini girin!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<CommentProvider>();
    provider.setGroupMembers(_groupMembersController.text);
    provider.setAllowedUsers(_allowedUsersController.text);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingScreen(postUrl: _urlController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: Text(
                      'Yorumları Yönet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Icon and Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.manage_search,
                      size: 60,
                      color: Color(0xFFA78BFA),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Giriş Yöntemi',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'URL veya kullanıcı adları ile yorumları yönetin.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Group Members Input
                  _buildTextAreaField(
                    label: 'Grup Üyeleri',
                    icon: Icons.group,
                    controller: _groupMembersController,
                    hint: 'Her satıra bir kullanıcı adı gelecek şekilde girin...',
                  ),
                  const SizedBox(height: 24),
                  
                  // Allowed Users Input
                  _buildTextAreaField(
                    label: 'İzinliler',
                    icon: Icons.verified_user,
                    controller: _allowedUsersController,
                    hint: 'Her satıra bir kullanıcı adı gelecek şekilde girin...',
                  ),
                  const SizedBox(height: 24),
                  
                  // URL Input
                  _buildInputField(
                    icon: Icons.public,
                    controller: _urlController,
                    hint: 'https://instagram.com/p/...',
                  ),
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7C3AED),
                          Color(0xFFEC4899),
                          Color(0xFFEF4444),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEC4899).withOpacity(0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Onayla',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAreaField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 16,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 12, bottom: 40),
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.5),
                  size: 24,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.5),
              size: 24,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
