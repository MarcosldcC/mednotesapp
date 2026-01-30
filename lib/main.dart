import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'constants/colors.dart';
import 'services/settings_service.dart';
import 'providers/user_career_provider.dart';
import 'providers/simulation_state_provider.dart';
import 'providers/recent_protocols_provider.dart';
import 'design/responsive.dart';

class _NavigationHistory extends NavigatorObserver {
  _NavigationHistory(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;
  final List<_RouteEntry> _stack = [];
  int _currentIndex = -1;
  bool _isHistoryNavigation = false;

  bool get canGoBack => _currentIndex > 0;
  bool get canGoForward => _currentIndex >= 0 && _currentIndex < _stack.length - 1;

  void goBack() {
    if (!canGoBack) return;
    navigatorKey.currentState?.pop();
  }

  void goForward() {
    if (!canGoForward) return;
    final entry = _stack[_currentIndex + 1];
    _isHistoryNavigation = true;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: entry.builder,
        settings: entry.settings,
      ),
    );
    _isHistoryNavigation = false;
  }

  bool _isTrackable(Route<dynamic> route) => route is MaterialPageRoute;

  _RouteEntry _entryFrom(Route<dynamic> route) {
    final material = route as MaterialPageRoute;
    return _RouteEntry(builder: material.builder, settings: material.settings);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!_isTrackable(route)) return;
    final entry = _entryFrom(route);

    if (_isHistoryNavigation) {
      _currentIndex = (_currentIndex + 1).clamp(0, _stack.length);
      if (_currentIndex < _stack.length) {
        _stack[_currentIndex] = entry;
      } else {
        _stack.add(entry);
      }
      return;
    }

    if (_currentIndex < _stack.length - 1) {
      _stack.removeRange(_currentIndex + 1, _stack.length);
    }
    _stack.add(entry);
    _currentIndex = _stack.length - 1;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!_isTrackable(route)) return;
    if (_currentIndex > 0) {
      _currentIndex -= 1;
    } else {
      _currentIndex = 0;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute == null || !_isTrackable(newRoute)) return;
    final entry = _entryFrom(newRoute);
    if (_currentIndex == -1) {
      _stack.add(entry);
      _currentIndex = 0;
      return;
    }
    _stack[_currentIndex] = entry;
    if (!_isHistoryNavigation && _currentIndex < _stack.length - 1) {
      _stack.removeRange(_currentIndex + 1, _stack.length);
    }
  }
}

class _RouteEntry {
  const _RouteEntry({
    required this.builder,
    required this.settings,
  });

  final WidgetBuilder builder;
  final RouteSettings settings;
}

/// Chama UserCareerProvider.load() uma vez após o primeiro frame.
class _CareerProviderLoader extends StatefulWidget {
  const _CareerProviderLoader({required this.child});

  final Widget child;

  @override
  State<_CareerProviderLoader> createState() => _CareerProviderLoaderState();
}

class _CareerProviderLoaderState extends State<_CareerProviderLoader> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserCareerProvider>(context, listen: false).load();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MedNotesApp());
}

class MedNotesApp extends StatelessWidget {
  const MedNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = GlobalKey<NavigatorState>();
    final navigationHistory = _NavigationHistory(navigatorKey);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsService()),
        ChangeNotifierProvider(create: (_) => UserCareerProvider()),
        ChangeNotifierProvider(create: (_) => SimulationStateProvider()),
        ChangeNotifierProvider(create: (_) => RecentProtocolsProvider()),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'MedNotes',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(
              settings.highContrast,
              settings.ecoModeEnabled,
              context,
            ),
            navigatorKey: navigatorKey,
            navigatorObservers: [navigationHistory],
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context).copyWith(
                textScaleFactor: settings.textScale,
              );

              return MediaQuery(
                data: mediaQuery,
                child: _CareerProviderLoader(
                  child: _SwipeNavigator(
                    navigationHistory: navigationHistory,
                    child: child!,
                  ),
                ),
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(
    bool highContrast,
    bool ecoModeEnabled,
    BuildContext context,
  ) {
    final responsive = Responsive.of(context);
    final pageTransitionsTheme = ecoModeEnabled
        ? const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: _NoAnimationPageTransitionsBuilder(),
              TargetPlatform.iOS: _NoAnimationPageTransitionsBuilder(),
              TargetPlatform.linux: _NoAnimationPageTransitionsBuilder(),
              TargetPlatform.macOS: _NoAnimationPageTransitionsBuilder(),
              TargetPlatform.windows: _NoAnimationPageTransitionsBuilder(),
            },
          )
        : const PageTransitionsTheme();
    
    if (highContrast) {
      // Tema de alto contraste - cores mais contrastantes
      return ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        pageTransitionsTheme: pageTransitionsTheme,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.white,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          outline: Colors.black,
        ),
        textTheme: TextTheme(
          displayLarge: responsive.heading1.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          displayMedium: responsive.heading2.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          displaySmall: responsive.heading3.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          bodyLarge: responsive.bodyLarge.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          bodyMedium: responsive.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          bodySmall: responsive.bodySmall.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          labelLarge: responsive.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          labelMedium: responsive.bodySmall.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          labelSmall: responsive.caption.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radiusMD),
            side: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: responsive.button,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      );
    } else {
      // Tema normal com tipografia responsiva
      return ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
        pageTransitionsTheme: pageTransitionsTheme,
        textTheme: TextTheme(
          displayLarge: responsive.heading1,
          displayMedium: responsive.heading2,
          displaySmall: responsive.heading3,
          bodyLarge: responsive.bodyLarge,
          bodyMedium: responsive.bodyMedium,
          bodySmall: responsive.bodySmall,
          labelLarge: responsive.bodyMedium,
          labelMedium: responsive.bodySmall,
          labelSmall: responsive.caption,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(responsive.radiusMD),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: responsive.button,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      );
    }
  }
}

class _NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const _NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class _SwipeNavigator extends StatefulWidget {
  const _SwipeNavigator({
    required this.navigationHistory,
    required this.child,
  });

  final _NavigationHistory navigationHistory;
  final Widget child;

  @override
  State<_SwipeNavigator> createState() => _SwipeNavigatorState();
}

class _SwipeNavigatorState extends State<_SwipeNavigator> {
  double? _dragStartX;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        _dragStartX = details.globalPosition.dx;
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        final velocity = details.primaryVelocity!;
        if (velocity.abs() < 300) return;

        final width = MediaQuery.of(context).size.width;
        final startX = _dragStartX ?? width / 2;
        final isEdgeSwipe = startX <= 24 || startX >= width - 24;
        if (!isEdgeSwipe) return;

        if (velocity > 0) {
          // Swipe para direita: voltar
          if (widget.navigationHistory.canGoBack) {
            widget.navigationHistory.goBack();
          }
        } else {
          // Swipe para esquerda: avançar
          if (widget.navigationHistory.canGoForward) {
            widget.navigationHistory.goForward();
          }
        }
      },
      child: widget.child,
    );
  }
}
