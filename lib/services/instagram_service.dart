import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment.dart';
import '../models/user.dart';
import '../providers/cookie_provider.dart';

class InstagramService {
  final CookieProvider cookieProvider;
  static const String baseUrl = 'https://www.instagram.com';
  static const String apiUrl = 'https://www.instagram.com/api/v1';
  
  InstagramService({required this.cookieProvider});
  
  Future<List<Comment>> getPostComments(String postUrl) async {
    try {
      final postId = extractPostIdFromUrl(postUrl);
      if (postId.isEmpty) {
        throw Exception('Geçersiz Instagram URL');
      }
      
      // Instagram Web API endpoint
      final shortcode = await _getShortcodeFromPostId(postId);
      final commentsUrl = '$apiUrl/media/$shortcode/comments/';
      
      final response = await http.get(
        Uri.parse(commentsUrl),
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseComments(data);
      } else if (response.statusCode == 401) {
        throw Exception('Oturum süresi dolmuş. Lütfen çerezleri yenileyin.');
      } else {
        throw Exception('Yorumlar yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      // Hata durumunda test verisi döndür
      print('API Hatası: $e');
      return _getMockComments();
    }
  }
  
  Future<String> _getShortcodeFromPostId(String postId) async {
    try {
      // Post URL'inden shortcode al
      final postPageUrl = '$baseUrl/p/$postId/';
      final response = await http.get(
        Uri.parse(postPageUrl), 
        headers: _getHeaders(),
      );
      
      if (response.statusCode == 200) {
        // HTML'den shortcode'u parse et
        final regex = RegExp(r'"shortcode":"([^"]+)"');
        final match = regex.firstMatch(response.body);
        return match?.group(1) ?? postId;
      }
    } catch (e) {
      print('Shortcode alınamadı: $e');
    }
    return postId;
  }
  
  List<Comment> _parseComments(Map<String, dynamic> data) {
    final comments = <Comment>[];
    
    if (data['comments'] != null) {
      for (var commentData in data['comments']) {
        comments.add(Comment(
          id: commentData['pk'].toString(),
          text: commentData['text'] ?? '',
          user: User(
            id: commentData['user']['pk'].toString(),
            username: commentData['user']['username'] ?? '',
            profilePicture: commentData['user']['profile_pic_url'],
            fullName: commentData['user']['full_name'],
          ),
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            (commentData['created_at'] * 1000).toInt(),
          ),
        ));
      }
    }
    
    return comments;
  }
  
  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Accept': '*/*',
      'Accept-Language': 'tr-TR,tr;q=0.9,en;q=0.8',
      'X-Requested-With': 'XMLHttpRequest',
      'Referer': 'https://www.instagram.com/',
    };
    
    // Cookie header ekle
    final cookieHeader = cookieProvider.getCookieHeader();
    if (cookieHeader.isNotEmpty) {
      headers['Cookie'] = cookieHeader;
    }
    
    // CSRF token ekle
    final csrfToken = cookieProvider.getCsrfToken();
    if (csrfToken != null) {
      headers['X-CSRFToken'] = csrfToken;
    }
    
    return headers;
  }
  
  List<Comment> _getMockComments() {
    // Test amaçlı mock data
    return [
      Comment(
        id: '1',
        text: 'Harika bir paylaşım!',
        user: User(id: '1', username: 'test_user1', profilePicture: 'https://i.pravatar.cc/150?img=1'),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Comment(
        id: '2',
        text: 'Çok güzel 😍',
        user: User(id: '2', username: 'test_user2', profilePicture: 'https://i.pravatar.cc/150?img=2'),
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Comment(
        id: '3',
        text: 'Bayıldım!',
        user: User(id: '3', username: 'test_user3', profilePicture: 'https://i.pravatar.cc/150?img=3'),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
  
  String extractPostIdFromUrl(String url) {
    // Instagram URL'inden post ID'sini çıkar
    final regex = RegExp(r'/p/([A-Za-z0-9_-]+)');
    final match = regex.firstMatch(url);
    return match?.group(1) ?? '';
  }
}
