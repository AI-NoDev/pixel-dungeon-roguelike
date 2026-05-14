import 'package:flutter/material.dart';
import '../i18n/app_localizations.dart';

class LoadingScreen extends StatefulWidget {
  final VoidCallback onLoaded;

  const LoadingScreen({super.key, required this.onLoaded});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _startLoading();
  }

  Future<void> _startLoading() async {
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) widget.onLoaded();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D0D1A), Color(0xFF1a1a2e), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF66BB6A).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  t.t('app_title'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t.t('app_subtitle'),
                  style: TextStyle(
                    color: Colors.amber.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 40),

                // Progress bar
                AnimatedBuilder(
                  animation: _progress,
                  builder: (context, _) {
                    return Container(
                      width: 200,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progress.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF66BB6A), Color(0xFFFFD54F)],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Loading text
                Text(
                  t.t('loading_assets'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 11,
                    letterSpacing: 1,
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
