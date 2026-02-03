//dependency imports
import 'package:flutter/material.dart';
//charts and graphs
import 'package:fl_chart/fl_chart.dart';
//footer for now will be moved to a separate file later
import '../widgets/bottom.dart';

//data models and controllers
import '../controllers/mood_controller.dart';
import '../models/mood_log.dart';
//routes
import '../routes/routes.dart';

//main wiget for insights page

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
} // end of Insights class

// state class manages data and UI updates
class _InsightsState extends State<Insights> {
  final MoodController _controller = MoodController(); // controller instance
  List<MoodLog> moodHistory = []; // list to store past moods if needed later

  // background image used for this page
  final String forestBackground = 'assets/images/forest_begin.png';

  @override
  void initState() {
    super.initState();
    _loadMoods(); // load moods when the page starts (if you want to reuse later)
  } // end of initState

  // async function to load mood logs
  Future<void> _loadMoods() async {
    final logs = await _controller.loadMoodLogs(); // get logs from controller
    setState(() => moodHistory = logs); // update UI with loaded logs
  } // end of _loadMoods

/*




*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // allows background image to go under appbar

      appBar: AppBar(
        backgroundColor: Colors.transparent, // transparent app bar
        elevation: 0, // no shadow
        title: const Text(
          "Insights",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
          // main content scrollable area
          // main scrollable content area
          ListView(
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            children: [
              // Weekly overview card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "This week's overview",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // donut chart widget for weekly data
                      // currently calls _controller.summarizeLogs()
                      // later you can switch this to a weekly-only method
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _controller.summarizeLogs(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          } else {
                            final summaryData = snapshot.data!;
                            return SizedBox(
                              height: 300, // size of the chart
                              child: PieChart(
                                PieChartData(
                                  sections: summaryData.map((data) {
                                    return PieChartSectionData(
                                      color: data['color'],
                                      value: data['percentage'],
                                      title:
                                          '${data['label']} \n${data['percentage'].toStringAsFixed(1)}%',
                                      radius: 60, // size of each section
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                  sectionsSpace: 2, // space between sections
                                  centerSpaceRadius: 40, // donut hole size
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ), // end weekly card

              const SizedBox(height: 30), // spacing between charts

              // Monthly overview card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24),
                  ),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "This month's overview",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // donut chart widget for monthly data
                      // currently calls _controller.summarizeLogs()
                      // later you can switch this to a monthly-only method
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _controller.summarizeLogs(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No data available',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          } else {
                            final summaryData = snapshot.data!;
                            return SizedBox(
                              height: 300, // size of the chart
                              child: PieChart(
                                PieChartData(
                                  sections: summaryData.map((data) {
                                    return PieChartSectionData(
                                      color: data['color'],
                                      value: data['percentage'],
                                      title:
                                          '${data['label']} \n${data['percentage'].toStringAsFixed(1)}%',
                                      radius: 60, // size of each section
                                      titleStyle: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }).toList(),
                                  sectionsSpace: 2, // space between sections
                                  centerSpaceRadius: 40, // donut hole size
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ), // end monthly card
            ],
          ), // end ListView
        ], // end Stack children
      ), // end Stack

      // shared footer navigation, same pattern as MoodPage
      bottomNavigationBar: BottomMenu(
        currentIndex: 0,
        onItemTapped: (index) {
          switch (index) {
            case 0: // Insights
              Navigator.pushNamed(context, Routes.insights);
              break;
            case 1: // Home (MoodPage)
              Navigator.pushNamed(context, Routes.moodPage);
              break;
            case 2: // Blank Pages (not made yet)
              // Navigator.pushNamed(context, Routes.blankPages);
              break;
            case 3: // Profile (not made yet)
              // Navigator.pushNamed(context, Routes.profilePage);
              break;
          }
        },
      ),
    ); // end Scaffold
  } // end build
} // end _InsightsState
