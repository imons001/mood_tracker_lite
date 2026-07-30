//dependency imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//footer
import '../widgets/bottom.dart';

//routes
import '../routes/routes.dart';

//controllers
import '../controllers/mood_controller.dart';
import '../controllers/sleep_controller.dart';
import '../controllers/trigger_controller.dart';
import '../controllers/daily_log_controller.dart';
import '../controllers/profile_controller.dart';

//model
import '../models/profile_stats.dart';

//main widget for profile page

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

//state class for profile page
class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  //background image
  final String _forestBackground = 'assets/images/background.jpg';

  //controllers for pulling stat data together
  final MoodController _moodController = MoodController();
  final SleepController _sleepController = SleepController();
  final TriggerController _triggerController = TriggerController();
  late final DailyLogController _dailyLogController = DailyLogController(
    moodController: _moodController,
    triggerController: _triggerController,
    sleepController: _sleepController,
  );
  late final ProfileController _profileController = ProfileController(
    moodController: _moodController,
    sleepController: _sleepController,
    triggerController: _triggerController,
    dailyLogController: _dailyLogController,
  );

  late Future<ProfileStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _statsFuture = _profileController.loadStats();
  }

  Future<void> _refreshStats() async {
    setState(() {
      _statsFuture = _profileController.loadStats();
    });
  }

  //temporary stub for settings rows that don't have a real page yet
  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming soon')),
    );
  }

  //derives initials from the user's email since there's no display name yet
  String get _initials {
    final email = user?.email;
    if (email == null || email.isEmpty) return '?';
    final namePart = email.split('@').first;
    final pieces = namePart.split(RegExp(r'[._]'));
    final letters = pieces
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase())
        .take(2)
        .join();
    return letters.isEmpty ? namePart[0].toUpperCase() : letters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // allows background image to go under app bar

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ), // end of app bar

      //main body layout
      body: Stack(
        children: [
          //background image
          Positioned.fill(
            child: Image.asset(
              _forestBackground,
              fit: BoxFit.cover,
            ),
          ), //pos fill

          //translucent gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.65),
                  ],
                ),
              ),
            ),
          ), // end overlay Positioned.fill

          //scrollable content
          RefreshIndicator(
            onRefresh: _refreshStats,
            child: ListView(
              padding: const EdgeInsets.only(top: 110, bottom: 100),
              children: [
                // avatar + email + streak badge
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: Text(
                          _initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.email ?? 'Guest',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 14),
                      FutureBuilder<ProfileStats>(
                        future: _statsFuture,
                        builder: (context, snapshot) {
                          final streak = snapshot.data?.streak ?? 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(
                                color: Colors.orangeAccent.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🔥',
                                    style: TextStyle(fontSize: 16)),
                                const SizedBox(width: 6),
                                Text(
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? 'Loading streak...'
                                      : '$streak day streak',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // stat cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: FutureBuilder<ProfileStats>(
                    future: _statsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final stats = snapshot.data ?? ProfileStats.empty();

                      return Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              emoji: stats.topMoodEmoji.isEmpty
                                  ? '—'
                                  : stats.topMoodEmoji,
                              label: 'Top Mood',
                              value: stats.topMoodlabel.isEmpty
                                  ? 'No logs yet'
                                  : stats.topMoodlabel,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              emoji: stats.topSleepEmoji.isEmpty
                                  ? '—'
                                  : stats.topSleepEmoji,
                              label: 'Top Sleep',
                              value: stats.topSleeplabel.isEmpty
                                  ? 'No logs yet'
                                  : stats.topSleeplabel,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              emoji: '📒',
                              label: 'Total Logs',
                              value: '${stats.totalLogs}',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // settings list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _settingsRow(
                        icon: Icons.edit_outlined,
                        label: 'Edit profile',
                        onTap: () => _comingSoon('Edit profile'),
                      ),
                      _settingsRow(
                        icon: Icons.notifications_outlined,
                        label: 'Reminders',
                        onTap: () => _comingSoon('Reminders'),
                      ),
                      _settingsRow(
                        icon: Icons.palette_outlined,
                        label: 'Theme and appearance',
                        onTap: () => _comingSoon('Theme and appearance'),
                      ),
                      _settingsRow(
                        icon: Icons.lock_outline,
                        label: 'Privacy and data',
                        onTap: () => _comingSoon('Privacy and data'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // sign out - styled as a destructive action
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.moodPage,
                          (route) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      'Sign out',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.redAccent.withOpacity(0.6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ), // end of stack
      bottomNavigationBar: BottomMenu(
        currentIndex: 3,
        onItemTapped: (index) {
          // Handle item tap
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.insights);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.moodPage);
              break;
            case 2: //not made yet
              // Navigator.pushNamed(context, Routes.notifications);
              break;
            case 3: //current
              Navigator.pushNamed(context, Routes.profilePage);
              break;
          }
        },
      ),
    );
  }

  //small glass-style stat card used for mood/sleep/total-logs
  Widget _statCard({
    required String emoji,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  //settings list row, glass style with a coming-soon stub for unbuilt pages
  Widget _settingsRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
