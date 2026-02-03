// import dependencies
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//footer
import '../widgets/bottom.dart';

// import data models and controllers
import '../models/mood_log.dart';
import '../controllers/mood_controller.dart';
import '../models/trigger_log.dart';
import '../controllers/trigger_controller.dart';
import '../models/sleep_log.dart';
import '../controllers/sleep_controller.dart';

// import helper files (for colors, data, and mapping to environments)
import '../helpers/mood_data.dart';
import '../helpers/environment_map.dart';
import '../helpers/trigger_data.dart';
import '../helpers/sleep_data.dart';
import '../helpers/sleep_sheet.dart';
import '../helpers/trigger_sheet.dart';
//routes
import '../routes/routes.dart';

// main widget for mood tracking page
class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
} // end of MoodPage widget class

// state class manages data and UI updates
class _MoodPageState extends State<MoodPage> {
  final MoodController _controller = MoodController(); // controller instance
  List<MoodLog> moodHistory = []; // list to store past moods

  //now triggers
  final TriggerController _triggerController =
      TriggerController(); // trigger controller instance
  List<TriggerLog> triggerHistory = []; // list to store past triggers
  //sleep moods from helper
  final SleepController _sleepController = SleepController();
  List<SleepLog> sleepHistory = []; // list to store past sleep logs

  // background image used for this page
  final String forestBackground = 'assets/images/forest_begin.png';

  @override
  void initState() {
    super.initState();
    _loadMoods(); // load moods when the page starts
    _loadTriggers(); // load triggers when the page starts
    _loadSleep(); // load sleep logs when the page starts
  } // end of initState

  // async function to load mood logs
  Future<void> _loadMoods() async {
    final logs = await _controller.loadMoodLogs(); // get logs from controller
    setState(() => moodHistory = logs); // update UI with loaded logs
  } // end of _loadMoods

  Future<void> _loadTriggers() async {
    final logs =
        await _triggerController.loadTriggerLogs(); // get logs from controller
    setState(() => triggerHistory = logs); // update UI with loaded logs
  } // end of _loadTriggers

//oh and sleep logs
  Future<void> _loadSleep() async {
    final logs =
        await _sleepController.loadSleepLogs(); // get logs from controller
    setState(() => sleepHistory = logs); // update UI with loaded logs
  } // end of _loadSleep

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // allows background image to go under appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // transparent app bar
        elevation: 0, // no shadow
        title: null, // title removed so it won't stay floating
        centerTitle: true, // centers the title
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // sign out user
              },
            ),
          ),
        ], // end of actions list
      ), // end of AppBar

      // main body layout
      body: Stack(
        children: [
          // background image fills screen
          Positioned.fill(
            child: Image.asset(
              forestBackground, // image path
              fit: BoxFit.cover, // scale to cover full background
            ),
          ), // end background Positioned.fill

          // translucent gradient overlay for readability
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

          // main scrollable content area and footer
          ListView(
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Text(
                    "Log a Mood",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ), // text style
                  ), // text widget
                ), // center
              ),

              // carousel shows past moods if any exist
              if (moodHistory.isNotEmpty)
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
                    itemCount: moodHistory.length,
                    itemBuilder: (context, index) {
                      final mood = moodHistory.reversed
                          .toList()[index]; //most recent first
                      final color = _controller.getMoodColor(mood.emoji);
                      // final monthly = _controller.getMonthlyLogs(mood.label); // for monthly chart

                      // each card opens its environment on tap
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => getEnvironmentWidget(
                                mood.label,
                                mood.emoji,
                                mood,
                              ),
                            ),
                          );
                          await _loadMoods(); // refresh after returning
                        }, // end onTap

                        // mood card design carousel
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white30),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ), // end BoxDecoration

                          // card content
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mood.emoji,
                                style: const TextStyle(fontSize: 44),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mood.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ), // end Column
                        ), // end Container
                      ); // end GestureDetector
                    },
                  ), // end PageView.builder
                ), // end SizedBox

              const SizedBox(height: 30), // spacing between carousel and grid

              // grid of selectable moods
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: GridView.builder(
                  shrinkWrap: true, // lets grid fit inside scroll view
                  physics:
                      const NeverScrollableScrollPhysics(), // disables scroll inside grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 columns
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: mood.length, // total moods
                  itemBuilder: (context, index) {
                    final moodItem = mood[index];
                    final emoji = moodItem['emoji']!;
                    final label = moodItem['label']!;
                    final color = _controller.getMoodColor(emoji);

                    // each mood button navigates to environment
                    return GestureDetector(
                      onTap: () async {
                        final newLog = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                getEnvironmentWidget(label, emoji),
                          ),
                        );

                        // save mood if user returns a new log
                        if (newLog != null && mounted) {
                          await _controller.addLog(newLog);
                          await _loadMoods(); // reload data
                        }
                      }, // end onTap

                      // mood grid button visuals
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              color.withOpacity(0.25), // subtle background tint
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: color, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ), // end Column
                      ), // end Container
                    ); // end GestureDetector
                  },
                ), // end GridView.builder
              ), // end Padding

//Insights section header
//Title Mood Insights
//moved weekly logs to insights page
//trigger trackers section header
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Text(
                    "Trigger Trackers",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ), // text style
                  ), // text widget
                ), // center
              ),
//grid for trigger trackers
// grid for trigger trackers
              const SizedBox(height: 20),
// Add Trigger Tracker grid or content here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.builder(
                  shrinkWrap: true, // lets grid fit inside scroll view
                  physics:
                      const NeverScrollableScrollPhysics(), // disables scroll inside grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 columns
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10.0, // spacing between items
                  ),
                  itemCount: triggers.length, // total trackers
                  itemBuilder: (context, index) {
                    final triggerItem = triggers[index];
                    final emoji = triggerItem['emoji']!;
                    final label = triggerItem['label']!;
                    final color = triggerItem['color']!;

                    // each tracker button
                    return GestureDetector(
                      onTap: () => showTriggerSheet(
                        context: context,
                        controller: _triggerController,
                        preselectedEmoji: emoji,
                        onSaved: _loadTriggers,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              color.withOpacity(0.25), // subtle background tint
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: color, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ), // end GridView.builder
              ), // padding
//sleep trackers section header
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    "Sleep",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ), // text style
                  ), // text widget
                ), // center
              ),
//grid for sleep trackers
              const SizedBox(height: 20),
// Add Sleep Tracker grid or content here
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.builder(
                  shrinkWrap: true, // lets grid fit inside scroll view
                  physics:
                      const NeverScrollableScrollPhysics(), // disables scroll inside grid
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 columns
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10.0, // spacing between items
                  ),
                  itemCount: sleepers.length, // total trackers
                  itemBuilder: (context, index) {
                    final sleepItem = sleepers[index];
                    final emoji = sleepItem['emoji']!;
                    final label = sleepItem['label']!;
                    final color = sleepItem['color']!;

                    return GestureDetector(
                      onTap: () => showSleepSheet(
                        context: context,
                        controller: _sleepController,
                        preselectedEmoji: emoji,
                        onSaved: _loadSleep,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              color.withOpacity(0.25), // subtle background tint
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: color, width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ), // end GridView.builder
              ), // end Padding
            ],
          ), // end ListView
        ],
      ), // end Stack

// shared footer navigation
      bottomNavigationBar: BottomMenu(
        currentIndex: 1,
        onItemTapped: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.insights);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.moodPage);
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
      ),
    ); // end Scaffold
  } // end build method
} // end of _MoodPageState class
