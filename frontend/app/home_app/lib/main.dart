import 'package:flutter/material.dart';
import 'package:rummel_blue_theme/rummel_blue_theme.dart';
import 'package:home_ui/screens/home_screen.dart';
import 'package:home_ui/screens/login_screen.dart';
import 'package:shared_services/shared_services.dart';

void main() {
  runApp(const HomeManagerApp());
}

class HomeManagerApp extends StatelessWidget {
  const HomeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Manager',
      theme: RummelBlueTheme.light(),
      darkTheme: RummelBlueTheme.dark(),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _authService = AuthService(config: AppConfigs.auth());
  bool _isLoading = true;
  bool _isAuthenticated = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    try {
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final userId = await _authService.getUserId();
        setState(() {
          _isAuthenticated = true;
          _userId = userId;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
    }
  }

  void _onLoginSuccess() {
    _checkAuthentication();
  }

  void _onLogout() async {
    await _authService.logout();
    setState(() {
      _isAuthenticated = false;
      _userId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isAuthenticated && _userId != null) {
      return HomeManagerScreen(
        userId: _userId!,
        onLogout: _onLogout,
      );
    }

    return LoginScreen(onLoginSuccess: _onLoginSuccess);
  }
}
