import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/comment_provider.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _searchController = TextEditingController();
  List<String> _filteredUsers = [];
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers(String query) {
    final provider = context.read<CommentProvider>();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = provider.nonCommenters
            .map((user) => user.username)
            .toList();
      } else {
        _filteredUsers = provider.nonCommenters
            .where((user) => 
                user.username.toLowerCase().contains(query.toLowerCase()))
            .map((user) => user.username)
            .toList();
      }
    });
  }

  void _copyUsernames() {
    final provider = context.read<CommentProvider>();
    final usernames = provider.nonCommenters
        .map((user) => user.username)
        .join('\n');
    
    Clipboard.setData(ClipboardData(text: usernames));
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kullanıcı adları kopyalandı!'),
        backgroundColor: Color(0xFF8B5CF6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<CommentProvider>(
        builder: (context, provider, child) {
          final nonCommenters = _searchController.text.isEmpty
              ? provider.nonCommenters
              : provider.nonCommenters.where((user) =>
                  user.username.toLowerCase().contains(
                      _searchController.text.toLowerCase())).toList();

          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.grey),
                          onPressed: () {},
                        ),
                        const Expanded(
                          child: Text(
                            'Yorum Yapmayanlar Listesi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey.shade700,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterUsers,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Kullanıcı adı ara...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: Icon(Icons.search,
                              color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.filter_list,
                            label: 'Filtrele',
                            onPressed: () {},
                            isPrimary: false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.sort,
                            label: 'Sırala',
                            onPressed: () {},
                            isPrimary: false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.content_copy,
                            label: 'Kopyala',
                            onPressed: _copyUsernames,
                            isPrimary: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // User List
              Expanded(
                child: nonCommenters.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Colors.green.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tüm kullanıcılar yorum yapmış!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kontrol edilen grup üyelerinin\ntamamı yorum yapmış durumda.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: nonCommenters.length,
                        itemBuilder: (context, index) {
                          final user = nonCommenters[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(
                                      user.profilePicture ?? '',
                                    ),
                                    backgroundColor: Colors.grey.shade700,
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.purple.withOpacity(0.2),
                                            Colors.indigo.withOpacity(0.2),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                user.username,
                                style: const TextStyle(
                                  color: Colors.grey.shade200,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFF8B5CF6)
            : Colors.grey.shade700,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
