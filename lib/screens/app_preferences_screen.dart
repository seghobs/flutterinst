import 'package:flutter/material.dart';

class AppPreferencesScreen extends StatefulWidget {
  const AppPreferencesScreen({super.key});

  @override
  State<AppPreferencesScreen> createState() => _AppPreferencesScreenState();
}

class _AppPreferencesScreenState extends State<AppPreferencesScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _autoResponseEnabled = false;
  String _sensitivityLevel = 'Orta';
  String _languageFilter = 'Türkçe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF10101A),
              Color(0xFF0A0A10),
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF10101A),
                      const Color(0xFF10101A).withOpacity(0.8),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Uygulama Tercihleri',
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      
                      // General Section
                      _buildSectionTitle('GENEL'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: _sectionDecoration(),
                        child: Column(
                          children: [
                            _buildSwitchTile(
                              icon: Icons.notifications,
                              title: 'Bildirimler',
                              subtitle: 'Anlık bildirimleri etkinleştirin veya devre dışı bırakın',
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildSwitchTile(
                              icon: Icons.dark_mode,
                              title: 'Koyu Mod',
                              subtitle: 'Her zaman koyu modu kullan',
                              value: _darkModeEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _darkModeEnabled = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Moderation Section
                      _buildSectionTitle('DENETLEME'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: _sectionDecoration(),
                        child: Column(
                          children: [
                            _buildOptionTile(
                              icon: Icons.sentiment_very_satisfied,
                              title: 'Hassasiyet Eşiği',
                              subtitle: 'Yorumların hassasiyet seviyesini ayarlayın',
                              value: _sensitivityLevel,
                              onTap: () {
                                _showSensitivityDialog();
                              },
                            ),
                            _buildDivider(),
                            _buildSwitchTile(
                              icon: Icons.auto_awesome,
                              title: 'Otomatik Yanıtlama',
                              subtitle: 'Yorumlara otomatik yanıtları etkinleştirin',
                              value: _autoResponseEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _autoResponseEnabled = value;
                                });
                              },
                            ),
                            _buildDivider(),
                            _buildOptionTile(
                              icon: Icons.language,
                              title: 'Dil Filtresi',
                              subtitle: 'Yorumları dile göre filtrele',
                              value: _languageFilter,
                              onTap: () {
                                _showLanguageDialog();
                              },
                            ),
                          ],
                        ),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  BoxDecoration _sectionDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey.shade900.withOpacity(0.5),
          Colors.grey.shade800.withOpacity(0.2),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade800,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF6366F1),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSensitivityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text(
            'Hassasiyet Eşiği',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Düşük', 'Orta', 'Yüksek'].map((level) {
              return RadioListTile<String>(
                title: Text(
                  level,
                  style: const TextStyle(color: Colors.white),
                ),
                value: level,
                groupValue: _sensitivityLevel,
                activeColor: const Color(0xFF6366F1),
                onChanged: (value) {
                  setState(() {
                    _sensitivityLevel = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F2937),
          title: const Text(
            'Dil Filtresi',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Türkçe', 'İngilizce', 'Tümü'].map((lang) {
              return RadioListTile<String>(
                title: Text(
                  lang,
                  style: const TextStyle(color: Colors.white),
                ),
                value: lang,
                groupValue: _languageFilter,
                activeColor: const Color(0xFF6366F1),
                onChanged: (value) {
                  setState(() {
                    _languageFilter = value!;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
