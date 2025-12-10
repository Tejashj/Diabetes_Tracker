// main.dart — Small-screen safe app (Part 1 of 4)
// Paste Part 1, then Part 2, Part 3, Part 4 into lib/main.dart

import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SugarCareApp());
}

class SugarCareApp extends StatelessWidget {
  const SugarCareApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SugarCare — Jagadeesha",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const RootDecider(),
    );
  }
}

/// ---------------------- Compact sizing (small-screen safe) ----------------------
const double kCompactPadding = 10.0;
const double kCardRadius = 12.0;
const double kMeterSize = 70.0; // small, safe
const double kChipMinWidth = 72.0;

/// ---------------------- Colors ----------------------
final Color _peach = const Color(0xFFFFE6DB);
final Color _softPink = const Color(0xFFFFC1D0);
final Color _warmGold = const Color(0xFFF6C77A);
final Color _deepRose = const Color(0xFFDF6B9D);
final Color _neonBlue = const Color(0xFF6EE7FF);
final Color _glass = Colors.white.withOpacity(0.06);

/// ---------------------- Hardcoded user ----------------------
const String userName = "Jagadeesha";

/// ---------------------- RootDecider ----------------------
class RootDecider extends StatefulWidget {
  const RootDecider({super.key});
  @override
  State<RootDecider> createState() => _RootDeciderState();
}
class _RootDeciderState extends State<RootDecider> {
  bool _loaded = false;
  bool _hasSetup = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _hasSetup = prefs.containsKey('bf_start');
    _loaded = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return _hasSetup ? const HomeScreen() : const SetupMealTimesScreen();
  }
}

/// ---------------------- Animated Liquid Background (compact) ----------------------
class AnimatedLiquidBackground extends StatefulWidget {
  final Widget child;
  const AnimatedLiquidBackground({super.key, required this.child});
  @override State<AnimatedLiquidBackground> createState() => _AnimatedLiquidBackgroundState();
}
class _AnimatedLiquidBackgroundState extends State<AnimatedLiquidBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _ctr;
  @override void initState(){
    super.initState();
    _ctr = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
  }
  @override void dispose(){ _ctr.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: _ctr,
      builder: (context, _) {
        final t = _ctr.value;
        return Stack(children: [
          Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-0.8 + 0.5 * math.sin(2*math.pi*t), -1),
              end: Alignment(0.8 - 0.5 * math.cos(2*math.pi*t), 1),
              colors: [_peach, _softPink, _warmGold],
            ),
          )),
          Positioned(
            top: 20 + 30 * math.sin(2*math.pi*t),
            left: 12 + 30 * math.cos(2*math.pi*t),
            child: _NeonBlob(size: 90, color: _deepRose.withOpacity(0.12), blur: 40),
          ),
          Positioned(
            bottom: 12 + 20 * math.cos(2*math.pi*t),
            right: 12 + 30 * math.sin(2*math.pi*t),
            child: _NeonBlob(size: 120, color: _neonBlue.withOpacity(0.10), blur: 60),
          ),
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), child: Container()),
          SafeArea(child: widget.child),
        ]);
      },
    );
  }
}
class _NeonBlob extends StatelessWidget {
  final double size, blur;
  final Color color;
  const _NeonBlob({required this.size, required this.color, required this.blur});
  @override Widget build(BuildContext context){
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0.0)]),
        boxShadow: [BoxShadow(color: color, blurRadius: blur, spreadRadius: blur/6)],
      ),
    );
  }
}

/// ---------------------- GlassCard (compact) ----------------------
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(kCompactPadding)});
  @override Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(kCardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _glass,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// ---------------------- SimpleMeter (compact) ----------------------
class SimpleMeter extends StatelessWidget {
  final double value; // 0–100
  const SimpleMeter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final display = value.clamp(0, 100).toInt();

    return SizedBox(
      width: kMeterSize,
      height: kMeterSize,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          width: kMeterSize,
          height: kMeterSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFC3A0), // Peach
                Color(0xFFFF8FB1), // Pink
                Color(0xFFC3F8FF), // Blue highlight
              ],
            ),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 1)],
          ),
          child: Center(
            child: Text(
              "$display%",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------- Setup Meal Times Screen (compact) ----------------------
class SetupMealTimesScreen extends StatefulWidget {
  const SetupMealTimesScreen({super.key});
  @override State<SetupMealTimesScreen> createState() => _SetupMealTimesScreenState();
}
class _SetupMealTimesScreenState extends State<SetupMealTimesScreen> {
  final TextEditingController bfStart = TextEditingController(text: "06:00");
  final TextEditingController bfEnd = TextEditingController(text: "11:00");
  final TextEditingController lunchStart = TextEditingController(text: "11:00");
  final TextEditingController lunchEnd = TextEditingController(text: "16:00");
  final TextEditingController dinnerStart = TextEditingController(text: "18:00");
  final TextEditingController dinnerEnd = TextEditingController(text: "22:00");
  bool _saving = false;

  Future<void> _pick(TextEditingController c) async {
    final parts = c.text.split(":");
    final init = TimeOfDay(hour: int.tryParse(parts[0]) ?? 7, minute: int.tryParse(parts[1]) ?? 0);
    final res = await showTimePicker(context: context, initialTime: init);
    if (res != null) {
      c.text = "${res.hour.toString().padLeft(2,'0')}:${res.minute.toString().padLeft(2,'0')}";
      if (mounted) setState((){});
    }
  }

  Future<void> _save() async {
    setState(()=> _saving = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bf_start', bfStart.text);
    await prefs.setString('bf_end', bfEnd.text);
    await prefs.setString('lunch_start', lunchStart.text);
    await prefs.setString('lunch_end', lunchEnd.text);
    await prefs.setString('dinner_start', dinnerStart.text);
    await prefs.setString('dinner_end', dinnerEnd.text);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  Widget timeField(TextEditingController c) => GestureDetector(
    onTap: ()=> _pick(c),
    child: GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(children: [ const Icon(Icons.access_time, size: 18), const SizedBox(width:8), Flexible(child: Text(c.text, overflow: TextOverflow.ellipsis)), const Spacer(), const Icon(Icons.edit, size:16) ]),
    ),
  );

  @override Widget build(BuildContext context){
    return AnimatedLiquidBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text("Set meal windows"), backgroundColor: Colors.transparent, elevation: 0),
        body: ListView(padding: const EdgeInsets.all(kCompactPadding), children: [
          const Text("Breakfast", style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: [ Expanded(child: timeField(bfStart)), const SizedBox(width:8), Expanded(child: timeField(bfEnd)) ]),
          const SizedBox(height:8),

          const Text("Lunch", style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: [ Expanded(child: timeField(lunchStart)), const SizedBox(width:8), Expanded(child: timeField(lunchEnd)) ]),
          const SizedBox(height:8),

          const Text("Dinner", style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Row(children: [ Expanded(child: timeField(dinnerStart)), const SizedBox(width:8), Expanded(child: timeField(dinnerEnd)) ]),

          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saving?null:_save,
            style: ElevatedButton.styleFrom(backgroundColor: _deepRose, padding: const EdgeInsets.symmetric(vertical:12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: _saving? const SizedBox(width:16,height:16,child:CircularProgressIndicator(strokeWidth:2, color:Colors.white)) : const Text("Save & Continue")
          )
        ]),
      ),
    );
  }
}
// ---------------------- HOME SCREEN ----------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tab = 0;

  final pages = [
    const DashboardPage(),
    const AddSugarPage(),
    const ActivityPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedLiquidBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: const Text(
                  "J",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Hello, Jagadeesha 👋",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),

        body: SafeArea(child: pages[tab]),

        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (i) => setState(() => tab = i),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: "Home"),
            NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: "Sugar"),
            NavigationDestination(icon: Icon(Icons.directions_walk), label: "Activity"),
            NavigationDestination(icon: Icon(Icons.history), label: "History"),
          ],
        ),
      ),
    );
  }
}

/// ---------------------- DASHBOARD PAGE ----------------------
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double todayScore = 40; // dynamic later

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(kCompactPadding),
      children: [
        GlassCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Health Score",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Based on your sugar logs & activity",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              SimpleMeter(value: todayScore),
            ],
          ),
        ),

        const SizedBox(height: kCompactPadding),

        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _quickButton("Add Sugar", Icons.bloodtype, () {
                    _switchTab(context, 1);
                  }),
                  _quickButton("Activity", Icons.directions_run, () {
                    _switchTab(context, 2);
                  }),
                  _quickButton("History", Icons.history, () {
                    _switchTab(context, 3);
                  }),
                  _quickButton("Outside Meal Log", Icons.add_alert, () {
                    _switchTab(context, 1, openOutside: true);
                  }),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: kCompactPadding),

        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Motivation", style: TextStyle(fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text(
                "Small steps matter! Even one reading a day is progress. "
                "A 10-minute walk after meals greatly improves sugar levels.",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quickButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _switchTab(BuildContext ctx, int index, {bool openOutside = false}) {
    final home = ctx.findAncestorStateOfType<_HomeScreenState>();
    if (home != null) {
      home.setState(() => home.tab = index);
    }

    if (openOutside) {
      Future.delayed(const Duration(milliseconds: 300), () {
        final add = ctx.findAncestorStateOfType<_AddSugarPageState>();
        add?.openOutsideDialog();
      });
    }
  }
}
// ---------------------- ADD SUGAR PAGE ----------------------
class AddSugarPage extends StatefulWidget {
  const AddSugarPage({super.key});
  @override State<AddSugarPage> createState() => _AddSugarPageState();
}

class _AddSugarPageState extends State<AddSugarPage> {
  final TextEditingController sugarCtrl = TextEditingController();
  String selectedTiming = "before"; // before / after
  String detectedMeal = "breakfast"; // auto-detected meal
  bool outsideMode = false;

  @override
  void initState() {
    super.initState();
    _detectMeal();
  }

  /// Detect which meal window the current time falls into
  Future<void> _detectMeal() async {
    final prefs = await SharedPreferences.getInstance();

    String bfS = prefs.getString("bf_start") ?? "06:00";
    String bfE = prefs.getString("bf_end") ?? "11:00";
    String luS = prefs.getString("lunch_start") ?? "11:00";
    String luE = prefs.getString("lunch_end") ?? "16:00";
    String diS = prefs.getString("dinner_start") ?? "18:00";
    String diE = prefs.getString("dinner_end") ?? "22:00";

    final now = TimeOfDay.now();

    if (_inWindow(now, bfS, bfE)) {
      detectedMeal = "breakfast";
    } else if (_inWindow(now, luS, luE)) {
      detectedMeal = "lunch";
    } else if (_inWindow(now, diS, diE)) {
      detectedMeal = "dinner";
    } else {
      detectedMeal = "outside";
      outsideMode = true;
    }

    if (mounted) setState(() {});
  }

  bool _inWindow(TimeOfDay now, String start, String end) {
    final s = _toTOD(start);
    final e = _toTOD(end);
    return (now.hour > s.hour || (now.hour == s.hour && now.minute >= s.minute)) &&
           (now.hour < e.hour || (now.hour == e.hour && now.minute <= e.minute));
  }

  TimeOfDay _toTOD(String s) {
    final parts = s.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  /// ---------------------- Outside Meal Popup ----------------------
  void openOutsideDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: const Text("Outside Meal Log"),
        content: const Text(
            "You are currently outside your breakfast, lunch, or dinner window.\n"
            "Do you still want to add a sugar reading?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                outsideMode = false;
                _detectMeal();
              });
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                outsideMode = true;
                detectedMeal = "outside";
              });
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  /// ---------------------- Save Reading ----------------------
  Future<void> _saveReading() async {
    if (sugarCtrl.text.trim().isEmpty) return;

    final value = double.tryParse(sugarCtrl.text) ?? 0;
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final record = {
      "meal": detectedMeal,
      "timing": selectedTiming,
      "value": value,
      "time": now.toIso8601String(),
    };

    /// Append to existing list
    List<String> old = prefs.getStringList("sugar_logs") ?? [];
    old.add(jsonEncode(record));
    await prefs.setStringList("sugar_logs", old);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reading saved!")),
    );

    sugarCtrl.clear();
    _detectMeal();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(kCompactPadding),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Update Sugar Level",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 8),

                /// Detected Meal
                Row(
                  children: [
                    const Icon(Icons.restaurant_menu, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      outsideMode
                          ? "Outside meal"
                          : "Detected: ${_cap(detectedMeal)}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Enter sugar value
                TextField(
                  controller: sugarCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter sugar level (mg/dL)",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Before / After options
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _timingChip("before"),
                    _timingChip("after"),
                  ],
                ),

                const SizedBox(height: 14),

                /// Outside Meal Log Button
                ElevatedButton.icon(
                  onPressed: openOutsideDialog,
                  icon: const Icon(Icons.add_alert),
                  label: const Text("Log Outside Meal"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                  ),
                ),

                const SizedBox(height: 14),

                /// Save Button
                ElevatedButton(
                  onPressed: _saveReading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deepRose,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Save Reading"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timingChip(String label) {
    final isSel = selectedTiming == label;
    return GestureDetector(
      onTap: () => setState(() => selectedTiming = label),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            isSel ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isSel ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(_cap(label)),
        ]),
      ),
    );
  }

  String _cap(String s) => s[0].toUpperCase() + s.substring(1);
}
// ---------------------- ACTIVITY PAGE ----------------------
class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});
  @override State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final TextEditingController stepsCtrl = TextEditingController();
  final TextEditingController distCtrl = TextEditingController();

  Future<void> _saveActivity() async {
    final prefs = await SharedPreferences.getInstance();

    int steps = int.tryParse(stepsCtrl.text) ?? 0;
    double dist = double.tryParse(distCtrl.text) ?? 0;

    final now = DateTime.now();
    final act = {
      "steps": steps,
      "distance": dist,
      "cal": (steps * 0.04).round(),   // very simplified calorie estimate
      "time": now.toIso8601String()
    };

    List<String> old = prefs.getStringList("activity_logs") ?? [];
    old.add(jsonEncode(act));
    await prefs.setStringList("activity_logs", old);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Activity saved!")),
    );

    stepsCtrl.clear();
    distCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(kCompactPadding),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Log Activity", style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),

                TextField(
                  controller: stepsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Steps",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: distCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Distance (km)",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 14),

                ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _deepRose,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Save Activity"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ---------------------- HISTORY PAGE ----------------------
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map<String, List<Map<String, dynamic>>> groupedSugar = {};
  Map<String, List<Map<String, dynamic>>> groupedActivity = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> rawSugar = prefs.getStringList("sugar_logs") ?? [];
    List<String> rawAct = prefs.getStringList("activity_logs") ?? [];

    groupedSugar = _groupByDate(rawSugar);
    groupedActivity = _groupByDate(rawAct);

    if (mounted) setState(() {});
  }

  /// Converts list of JSON-items into map of "yyyy-mm-dd": [items]
  Map<String, List<Map<String, dynamic>>> _groupByDate(List<String> list) {
    Map<String, List<Map<String, dynamic>>> result = {};

    for (final j in list) {
      final decoded = jsonDecode(j) as Map<String, dynamic>;
      final time = DateTime.parse(decoded["time"]);
      final key = DateFormat("yyyy-MM-dd").format(time);

      result.putIfAbsent(key, () => []);
      result[key]!.add(decoded);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final allDates = {...groupedSugar.keys, ...groupedActivity.keys}.toList()
      ..sort((a, b) => b.compareTo(a)); // newest first

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(kCompactPadding),
        children: [
          if (allDates.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("No history yet."),
              ),
            ),

          for (final date in allDates) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                DateFormat("dd MMM yyyy").format(DateTime.parse(date)),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            if (groupedSugar.containsKey(date))
              ...groupedSugar[date]!.map((e) => _sugarTile(e)),

            if (groupedActivity.containsKey(date))
              ...groupedActivity[date]!.map((e) => _activityTile(e)),
          ]
        ],
      ),
    );
  }

  Widget _sugarTile(Map<String, dynamic> e) {
    final dt = DateTime.parse(e["time"]);
    final t = DateFormat("hh:mm a").format(dt);

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.bloodtype, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${_cap(e['meal'])} (${_cap(e['timing'])})  —  ${e['value']} mg/dL",
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(t, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _activityTile(Map<String, dynamic> e) {
    final dt = DateTime.parse(e["time"]);
    final t = DateFormat("hh:mm a").format(dt);

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.directions_walk, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${e['steps']} steps — ${e['distance']} km\n${e['cal']} cal burned",
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(t, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  String _cap(String s) => s[0].toUpperCase() + s.substring(1);
}
