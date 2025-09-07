import 'package:flutter/material.dart';
import 'cookies_screen.dart';
import 'app_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, 
                      color: Colors.white70),
                  onPressed: () {},
                ),
                const Expanded(
                  child: Text(
                    'Ayarlar',
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
          
          // Settings Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingsItem(
                  context: context,
                  icon: Icons.cookie,
                  title: 'Çerezler',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CookiesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Bildirimler',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  context: context,
                  icon: Icons.tune,
                  title: 'Uygulama Tercihleri',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppPreferencesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  context: context,
                  icon: Icons.shield,
                  title: 'Gizlilik',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  context: context,
                  icon: Icons.help_outline,
                  title: 'Yardım',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildSettingsItem(
                  context: context,
                  icon: Icons.info,
                  title: 'Hakkında',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade500,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
