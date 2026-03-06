// ============================================================
// RoadGuard - Pothole Detection App
// Complete Flutter UI (No Backend / No Business Logic)
// Material 3 Design | Dark Blue + Teal Accent Scheme
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const RoadGuardApp());
}

// ─────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────
class RoadGuardApp extends StatelessWidget {
  const RoadGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoadGuard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// THEME CONFIGURATION
// ─────────────────────────────────────────────
class AppTheme {
  static const Color primary = Color(0xFF0D2137);      // Deep navy
  static const Color accent = Color(0xFF00C9A7);       // Teal
  static const Color accentLight = Color(0xFF4EECD1);  // Light teal
  static const Color danger = Color(0xFFFF4757);
  static const Color warning = Color(0xFFFFD32A);
  static const Color success = Color(0xFF2ED573);
  static const Color cardDark = Color(0xFF112233);
  static const Color surfaceDark = Color(0xFF0A1929);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: accent,
          onPrimary: Colors.black,
          secondary: accentLight,
          surface: cardDark,
          error: danger,
        ),
        scaffoldBackgroundColor: surfaceDark,
        cardTheme: CardThemeData(
          color: cardDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: surfaceDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: cardDark,
          selectedItemColor: accent,
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white60),
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF00C9A7),
          secondary: Color(0xFF0D2137),
          surface: Colors.white,
       
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// 1. SPLASH SCREEN
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate to main shell after delay
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const MainShell(),
            transitionsBuilder: (_, anim, _, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_,_) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo
              FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: const _AppLogo(size: 120),
                ),
              ),
              const SizedBox(height: 32),
              // ── App Name
              FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'RoadGuard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // ── Tagline
              FadeTransition(
                opacity: _textFade,
                child: const Text(
                  'Smart Roads, Safer Rides',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // ── Loading dots
              FadeTransition(
                opacity: _textFade,
                child: const _PulsingDots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated pulsing loading dots
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true, period: Duration(milliseconds: 600 + i * 200)),
    );
    for (var i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (_, _) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.accent
                  .withValues(alpha:0.4 + 0.6 * _controllers[i].value),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// APP LOGO WIDGET (reusable)
// ─────────────────────────────────────────────
class _AppLogo extends StatelessWidget {
  final double size;
  const _AppLogo({this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF1A3A5C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent..withValues(alpha:0.4),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
        border: Border.all(color: AppTheme.accent, width: 2.5),
      ),
      child: Center(
        child: Icon(
          Icons.shield_rounded,
          color: AppTheme.accent,
          size: size * 0.52,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 2. MAIN SHELL (Bottom Navigation)
// ─────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    MapScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _RoadGuardNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

/// Custom styled bottom navigation bar
class _RoadGuardNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _RoadGuardNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Home'),
      (Icons.history_rounded, Icons.history_outlined, 'History'),
      (Icons.map_rounded, Icons.map_outlined, 'Map'),
      (Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        border: Border(
          top: BorderSide(
            color: AppTheme.accent.withValues(alpha:0.15),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isSelected = i == currentIndex;
              final item = items[i];
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accent.withValues(alpha:0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.$1 : item.$2,
                        color: isSelected ? AppTheme.accent : Colors.white38,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.$3,
                        style: TextStyle(
                          color:
                              isSelected ? AppTheme.accent : Colors.white38,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 3. HOME DASHBOARD SCREEN
// ─────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header
              const _HomeHeader(),
              const SizedBox(height: 28),
              // ── Status Badge
              const _StatusBadge(isActive: false),
              const SizedBox(height: 32),
              // ── Start Detection Button
              const Center(child: _DetectionButton()),
              const SizedBox(height: 36),
              // ── Sensor Status Cards
              const Text(
                'Sensor Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              const _SensorGrid(),
              const SizedBox(height: 24),
              // ── Quick Stats Row
              const _QuickStatsRow(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _AppLogo(size: 44),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RoadGuard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Smart Roads, Safer Rides',
              style: TextStyle(
                color: AppTheme.accent,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppTheme.accent.withValues(alpha:0.2)),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.white70, size: 22),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppTheme.success.withValues(alpha:0.4)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive ? AppTheme.success : Colors.white30,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppTheme.success..withValues(alpha:0.6),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            isActive ? 'Detection Active' : 'Detection Inactive',
            style: TextStyle(
              color: isActive ? AppTheme.success : Colors.white54,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            isActive ? 'RUNNING' : 'IDLE',
            style: TextStyle(
              color: isActive
                  ? AppTheme.success.withValues(alpha:0.8)
                  : Colors.white30,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Large circular "Start Detection" button
class _DetectionButton extends StatelessWidget {
  const _DetectionButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const LiveDetectionScreen()),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accent.withValues(alpha:0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Inner ring
          Container(
            width: 172,
            height: 172,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accent.withValues(alpha:0.3),
                width: 1.5,
              ),
            ),
          ),
          // Main button
          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF00C9A7), Color(0xFF009E85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha:0.45),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.radar_rounded, color: Colors.black, size: 36),
                SizedBox(height: 6),
                Text(
                  'START',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'Detection',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 3-column sensor status grid
class _SensorGrid extends StatelessWidget {
  const _SensorGrid();

  @override
  Widget build(BuildContext context) {
    const sensors = [
      (Icons.vibration_rounded, 'Accelerometer', 'Ready', true),
      (Icons.rotate_90_degrees_ccw_rounded, 'Gyroscope', 'Ready', true),
      (Icons.gps_fixed_rounded, 'GPS', 'Searching', false),
    ];

    return Row(
      children: sensors.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: s == sensors.last ? 0 : 10,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: s.$4
                    ? AppTheme.accent.withValues(alpha:0.25)
                    : Colors.white10,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: s.$4
                        ? AppTheme.accent.withValues(alpha:0.15)
                        : Colors.white.withValues(alpha:0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(s.$1,
                      color: s.$4 ? AppTheme.accent : Colors.white38,
                      size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  s.$2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                Text(
                  s.$3,
                  style: TextStyle(
                    color: s.$4 ? AppTheme.success : AppTheme.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Today',
            value: '12',
            sub: 'Potholes',
            icon: Icons.warning_amber_rounded,
            color: AppTheme.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Distance',
            value: '4.2',
            sub: 'km driven',
            icon: Icons.route_rounded,
            color: AppTheme.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Score',
            value: '87',
            sub: 'Road quality',
            icon: Icons.star_rounded,
            color: AppTheme.success,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha:0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 4. LIVE DETECTION SCREEN
// ─────────────────────────────────────────────
class LiveDetectionScreen extends StatefulWidget {
  const LiveDetectionScreen({super.key});

  @override
  State<LiveDetectionScreen> createState() => _LiveDetectionScreenState();
}

class _LiveDetectionScreenState extends State<LiveDetectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _pulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Live Detection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppTheme.success.withValues(alpha:0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTheme.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppTheme.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Animated Detection Indicator
              _AnimatedDetectionIndicator(
                pulse: _pulse,
                rotate: _rotateController,
              ),
              const SizedBox(height: 28),
              // ── Speed & Location Row
              Row(
                children: [
                  Expanded(
                    child: _LiveDataCard(
                      icon: Icons.speed_rounded,
                      label: 'Speed',
                      value: '42',
                      unit: 'km/h',
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LiveDataCard(
                      icon: Icons.gps_fixed_rounded,
                      label: 'Accuracy',
                      value: '±3',
                      unit: 'meters',
                      color: AppTheme.accentLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ── Location card
              _LocationCard(),
              const SizedBox(height: 20),
              // ── Graph placeholder
              _GraphPlaceholder(),
              const SizedBox(height: 20),
              // ── Sensor readings
              const _SensorReadingsCard(),
              const SizedBox(height: 24),
              // ── Stop button
              _StopButton(onTap: () => Navigator.pop(context)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedDetectionIndicator extends StatelessWidget {
  final Animation<double> pulse;
  final AnimationController rotate;

  const _AnimatedDetectionIndicator({
    required this.pulse,
    required this.rotate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing ring
          AnimatedBuilder(
            animation: pulse,
            builder: (_, _) => Transform.scale(
              scale: pulse.value,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accent.withValues(alpha:0.15),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          // Rotating dashed ring
          AnimatedBuilder(
            animation: rotate,
            builder: (_, _) => Transform.rotate(
              angle: rotate.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(176, 176),
                painter: _DashedCirclePainter(
                  color: AppTheme.accent.withValues(alpha:0.5),
                ),
              ),
            ),
          ),
          // Center circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.accent.withValues(alpha:0.25),
                  AppTheme.surfaceDark,
                ],
              ),
              border: Border.all(color: AppTheme.accent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accent.withValues(alpha:0.3),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.radar_rounded, color: AppTheme.accent, size: 40),
                SizedBox(height: 6),
                Text(
                  'SCANNING',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for dashed circle
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashCount = 24;
    const dashLength = 0.12;
    const gapLength = 0.14;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashLength + gapLength));
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
        ),
        startAngle,
        dashLength,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LiveDataCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _LiveDataCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha:.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 11)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(unit,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on_rounded,
                color: AppTheme.accent, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                Text(
                  'MG Road, Bengaluru, Karnataka',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: Colors.white30, size: 20),
        ],
      ),
    );
  }
}

/// Real-time graph UI placeholder with waveform visuals
class _GraphPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Acceleration Data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha:0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _WaveformPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Waveform painter for graph placeholder
class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppTheme.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.accent.withValues(alpha:0.3),
          AppTheme.accent.withValues(alpha:0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Dummy waveform data
    final points = [
      0.5, 0.45, 0.55, 0.4, 0.6, 0.3, 0.8, 0.2, 0.7, 0.5,
      0.4, 0.6, 0.35, 0.65, 0.5, 0.45, 0.55, 0.7, 0.3, 0.5,
      0.45, 0.6, 0.4, 0.55, 0.5,
    ];

    final path = Path();
    final fillPath = Path();
    final stepX = size.width / (points.length - 1);

    for (var i = 0; i < points.length; i++) {
      final x = i * stepX;
      final y = size.height * points[i];
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    final lastX = (points.length - 1) * stepX;
    fillPath.lineTo(lastX, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.07)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SensorReadingsCard extends StatelessWidget {
  const _SensorReadingsCard();

  @override
  Widget build(BuildContext context) {
    const readings = [
      ('X-Axis', '0.24 m/s²', AppTheme.accent),
      ('Y-Axis', '-0.12 m/s²', AppTheme.accentLight),
      ('Z-Axis', '9.81 m/s²', AppTheme.warning),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sensor Readings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ...readings.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: r.$3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(r.$1,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 13)),
                  const Spacer(),
                  Text(r.$2,
                      style: TextStyle(
                        color: r.$3,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              AppTheme.danger,
              AppTheme.danger.withValues(alpha:0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.danger.withValues(alpha:0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stop_circle_outlined, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text(
              'Stop Detection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 5. HISTORY SCREEN
// ─────────────────────────────────────────────

/// Dummy pothole data model (UI only)
class _PotholeRecord {
  final String date;
  final String time;
  final String location;
  final String severity;

  const _PotholeRecord({
    required this.date,
    required this.time,
    required this.location,
    required this.severity,
  });
}

const List<_PotholeRecord> _dummyHistory = [
  _PotholeRecord(
      date: 'Mon, 23 Feb',
      time: '09:14 AM',
      location: 'MG Road, Bengaluru',
      severity: 'High'),
  _PotholeRecord(
      date: 'Mon, 23 Feb',
      time: '08:52 AM',
      location: 'Silk Board Junction',
      severity: 'Medium'),
  _PotholeRecord(
      date: 'Sun, 22 Feb',
      time: '06:31 PM',
      location: 'Outer Ring Road',
      severity: 'Low'),
  _PotholeRecord(
      date: 'Sun, 22 Feb',
      time: '05:12 PM',
      location: 'Hosur Road, Bommanahalli',
      severity: 'High'),
  _PotholeRecord(
      date: 'Sat, 21 Feb',
      time: '10:05 AM',
      location: 'KR Puram, ITPL Road',
      severity: 'Medium'),
  _PotholeRecord(
      date: 'Sat, 21 Feb',
      time: '09:40 AM',
      location: 'Whitefield Main Rd',
      severity: 'Low'),
  _PotholeRecord(
      date: 'Fri, 20 Feb',
      time: '07:28 PM',
      location: 'Electronic City Phase 1',
      severity: 'High'),
];

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Detection History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Summary strip
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _HistorySummaryStrip(total: _dummyHistory.length),
          ),
          const SizedBox(height: 16),
          // ── List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _dummyHistory.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) =>
                  _PotholeHistoryCard(record: _dummyHistory[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistorySummaryStrip extends StatelessWidget {
  final int total;
  const _HistorySummaryStrip({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryChip(
              label: 'Total', count: total.toString(), color: Colors.white),
          _VerticalDivider(),
          const _SummaryChip(label: 'High', count: '3', color: AppTheme.danger),
          _VerticalDivider(),
          const _SummaryChip(
              label: 'Medium', count: '2', color: AppTheme.warning),
          _VerticalDivider(),
          const _SummaryChip(
              label: 'Low', count: '2', color: AppTheme.success),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: Colors.white12);
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(
                color: color, fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}

class _PotholeHistoryCard extends StatelessWidget {
  final _PotholeRecord record;
  const _PotholeHistoryCard({required this.record});

  Color get _severityColor {
    switch (record.severity) {
      case 'High':
        return AppTheme.danger;
      case 'Medium':
        return AppTheme.warning;
      default:
        return AppTheme.success;
    }
  }

  IconData get _severityIcon {
    switch (record.severity) {
      case 'High':
        return Icons.error_rounded;
      case 'Medium':
        return Icons.warning_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _severityColor.withValues(alpha:0.2)),
      ),
      child: Row(
        children: [
          // ── Severity icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _severityColor.withValues(alpha:0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_severityIcon, color: _severityColor, size: 24),
          ),
          const SizedBox(width: 14),
          // ── Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: Colors.white38, size: 11),
                    const SizedBox(width: 4),
                    Text(record.date,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                    const SizedBox(width: 10),
                    const Icon(Icons.access_time_rounded,
                        color: Colors.white38, size: 11),
                    const SizedBox(width: 4),
                    Text(record.time,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          // ── Severity badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _severityColor.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _severityColor.withValues(alpha:0.4)),
            ),
            child: Text(
              record.severity,
              style: TextStyle(
                color: _severityColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 6. MAP SCREEN
// ─────────────────────────────────────────────
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(
        title: const Text('Pothole Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map placeholder
          const _MapPlaceholder(),
          // ── Legend overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _MapLegend(),
          ),
          // ── Stats overlay (top)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _MapStatsBar(),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid background simulating map
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF0E1F33),
          child: CustomPaint(
            painter: _MapGridPainter(),
          ),
        ),
        // Simulated road lines
        CustomPaint(
          size: Size.infinite,
          painter: _RoadPainter(),
        ),
        // Placeholder markers
        ..._buildDummyMarkers(),
        // Center: "Google Maps coming soon" label
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.map_outlined,
                color: AppTheme.accent.withValues(alpha:0.3),
                size: 64,
              ),
              const SizedBox(height: 8),
              Text(
                'Google Maps Integration',
                style: TextStyle(
                  color: Colors.white.withValues(alpha:0.3),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '(UI Placeholder)',
                style: TextStyle(
                  color: Colors.white.withValues(alpha:0.2),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDummyMarkers() {
    final markers = [
      (0.25, 0.35, AppTheme.danger),
      (0.6, 0.45, AppTheme.warning),
      (0.42, 0.62, AppTheme.danger),
      (0.7, 0.3, AppTheme.success),
      (0.3, 0.7, AppTheme.warning),
    ];

    return markers.map((m) {
      return Positioned(
        left: m.$1 * 400, // approximate
        top: m.$2 * 600,
        child: _MapMarker(color: m.$3),
      );
    }).toList();
  }
}

class _MapMarker extends StatelessWidget {
  final Color color;
  const _MapMarker({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.25),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha:0.4), blurRadius: 8),
        ],
      ),
      child: Icon(Icons.warning_amber_rounded, color: color, size: 14),
    );
  }
}

/// Map grid painter
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha:0.04)
      ..strokeWidth = 1;

    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i.toDouble(), 0),
          Offset(i.toDouble(), size.height), paint);
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
          Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Road lines painter
class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha:0.08)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.5),
        paint);
    canvas.drawLine(
        Offset(size.width * 0.3, 0),
        Offset(size.width * 0.45, size.height),
        paint);
    canvas.drawLine(
        Offset(size.width * 0.6, 0),
        Offset(size.width * 0.55, size.height),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapStatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha:0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MapStat(label: 'In Area', value: '24', icon: Icons.warning_rounded),
          _MapStat(
              label: 'Critical',
              value: '8',
              icon: Icons.error_rounded,
              color: AppTheme.danger),
          _MapStat(
              label: 'Reported',
              value: '16',
              icon: Icons.check_circle_rounded,
              color: AppTheme.success),
        ],
      ),
    );
  }
}

class _MapStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MapStat({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppTheme.warning,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withValues(alpha:0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _LegendItem(color: AppTheme.danger, label: 'High'),
          _LegendItem(color: AppTheme.warning, label: 'Medium'),
          _LegendItem(color: AppTheme.success, label: 'Low'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 7. SETTINGS SCREEN
// ─────────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoStart = false;
  bool _notifications = true;
  bool _darkMode = true;
  bool _saveHistory = true;
  String _sensitivity = 'Medium';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceDark,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Profile card
          const _SettingsProfileCard(),
          const SizedBox(height: 24),
          // ── Detection section
          _SettingsSection(
            title: 'Detection',
            children: [
              _ToggleTile(
                icon: Icons.play_circle_outline_rounded,
                label: 'Auto Start',
                sub: 'Begin detection on launch',
                value: _autoStart,
                onChanged: (v) => setState(() => _autoStart = v),
              ),
              _ToggleTile(
                icon: Icons.save_outlined,
                label: 'Save History',
                sub: 'Store pothole detections locally',
                value: _saveHistory,
                onChanged: (v) => setState(() => _saveHistory = v),
              ),
              _SensitivityTile(
                value: _sensitivity,
                onChanged: (v) => setState(() => _sensitivity = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── Notifications
          _SettingsSection(
            title: 'Notifications',
            children: [
              _ToggleTile(
                icon: Icons.notifications_outlined,
                label: 'Push Notifications',
                sub: 'Alert when pothole detected',
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── Appearance
          _SettingsSection(
            title: 'Appearance',
            children: [
              _ToggleTile(
                icon: Icons.dark_mode_outlined,
                label: 'Dark Mode',
                sub: 'Use dark color scheme',
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ── About
          _AboutSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _SettingsProfileCard extends StatelessWidget {
  const _SettingsProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.cardDark,
            AppTheme.accent.withValues(alpha:0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withValues(alpha:0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha:0.2),
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.accent, width: 2),
            ),
            child: const Icon(Icons.person_rounded,
                color: AppTheme.accent, size: 28),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Road Guard User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'v2.1.0 · Pro Member',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded,
              color: Colors.white30),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.accent,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: children
                .asMap()
                .entries
                .map((e) => Column(
                      children: [
                        e.value,
                        if (e.key < children.length - 1)
                          Divider(
                            color: Colors.white.withValues(alpha:0.05),
                            height: 1,
                            indent: 56,
                          ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha:0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.accent, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                Text(sub,
                    style: const TextStyle(
                        color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor:AppTheme.accent,
            activeTrackColor: AppTheme.accent.withValues(alpha:0.3),
            inactiveTrackColor: Colors.white12,
            inactiveThumbColor: Colors.white38,
          ),
        ],
      ),
    );
  }
}

class _SensitivityTile extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _SensitivityTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const options = ['Low', 'Medium', 'High'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.accent..withValues(alpha:0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune_rounded,
                color: AppTheme.accent, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sensitivity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
                Text('Detection threshold level',
                    style:
                        TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: AppTheme.cardDark,
            underline: const SizedBox(),
            style: const TextStyle(
                color: AppTheme.accent, fontWeight: FontWeight.w700),
            icon: const Icon(Icons.expand_more_rounded,
                color: AppTheme.accent, size: 18),
            items: options
                .map((o) => DropdownMenuItem(
                      value: o,
                      child: Text(o),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SettingsSection(
      title: 'About',
      children: [
        _AboutTile(
          icon: Icons.info_outline_rounded,
          label: 'App Version',
          trailing: 'v2.1.0',
        ),
        _AboutTile(
          icon: Icons.policy_outlined,
          label: 'Privacy Policy',
          trailing: null,
          isNavItem: true,
        ),
        _AboutTile(
          icon: Icons.description_outlined,
          label: 'Terms of Service',
          trailing: null,
          isNavItem: true,
        ),
        _AboutTile(
          icon: Icons.star_rate_rounded,
          label: 'Rate the App',
          trailing: null,
          isNavItem: true,
        ),
      ],
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final bool isNavItem;

  const _AboutTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.isNavItem = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          if (trailing != null)
            Text(trailing!,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 13)),
          if (isNavItem)
            const Icon(Icons.chevron_right_rounded,
                color: Colors.white30, size: 18),
        ],
      ),
    );
  }
}