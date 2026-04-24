import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({super.key});

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final firstName = await _storage.read(key: 'user_first_name') ?? '';
    final lastName = await _storage.read(key: 'user_last_name') ?? '';

    final fullName = '$firstName $lastName'.trim();

    if (!mounted) return;

    setState(() {
      _fullName = fullName.isNotEmpty ? fullName : 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hi, $_fullName'),
      ),
    );
  }
}