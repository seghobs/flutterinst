import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../models/user.dart';
import '../services/instagram_service.dart';
import 'cookie_provider.dart';

class CommentProvider extends ChangeNotifier {
  late final InstagramService _instagramService;
  final CookieProvider cookieProvider;
  
  CommentProvider({required this.cookieProvider}) {
    _instagramService = InstagramService(cookieProvider: cookieProvider);
  }
  
  List<Comment> _comments = [];
  List<String> _groupMembers = [];
  List<String> _allowedUsers = [];
  List<User> _nonCommenters = [];
  bool _isLoading = false;
  String? _error;
  double _loadingProgress = 0.0;
  
  List<Comment> get comments => _comments;
  List<String> get groupMembers => _groupMembers;
  List<String> get allowedUsers => _allowedUsers;
  List<User> get nonCommenters => _nonCommenters;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get loadingProgress => _loadingProgress;
  
  void setGroupMembers(String membersText) {
    _groupMembers = membersText
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    notifyListeners();
  }
  
  void setAllowedUsers(String allowedText) {
    _allowedUsers = allowedText
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    notifyListeners();
  }
  
  Future<void> checkComments(String postUrl) async {
    _isLoading = true;
    _error = null;
    _loadingProgress = 0.0;
    notifyListeners();
    
    try {
      // İlerleme simülasyonu
      for (int i = 0; i <= 75; i += 5) {
        await Future.delayed(const Duration(milliseconds: 100));
        _loadingProgress = i / 100;
        notifyListeners();
      }
      
      // Yorumları al
      _comments = await _instagramService.getPostComments(postUrl);
      
      // İlerlemeyi tamamla
      _loadingProgress = 1.0;
      notifyListeners();
      
      // Yorum yapmayanları bul (sadece groupMembers listesindekiler kontrol edilir)
      _findNonCommenters();
      
      await Future.delayed(const Duration(milliseconds: 500));
      _isLoading = false;
      notifyListeners();
      
    } catch (e) {
      _error = 'Yorumlar yüklenirken hata oluştu: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void _findNonCommenters() {
    // Yorum yapan kullanıcıların username'lerini al
    final commentUsernames = _comments
        .map((comment) => comment.user.username.toLowerCase())
        .toSet();
    
    // GroupMembers'dan yorum yapmayanları bul
    _nonCommenters = _groupMembers
        .where((member) => !commentUsernames.contains(member.toLowerCase()))
        .map((username) => User(
              id: username,
              username: username,
              profilePicture: 'https://i.pravatar.cc/150?u=$username',
            ))
        .toList();
    
    notifyListeners();
  }
  
  void reset() {
    _comments = [];
    _groupMembers = [];
    _allowedUsers = [];
    _nonCommenters = [];
    _isLoading = false;
    _error = null;
    _loadingProgress = 0.0;
    notifyListeners();
  }
}
