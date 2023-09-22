import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/user_details_service.dart';

class UserProfile extends StatelessWidget {
  final AuthService _authService = AuthService();
  final UserDetailsService _userDetailsService = UserDetailsService();

  UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final User user = _authService.currentUser;
    final String name = user.displayName ?? "User";
    final String? photoUrl = user.photoURL;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(photoUrl ?? ''),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await _authService.signOut();
              } else if (value == 'edit') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed('/user/edit');
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout), // Icon for Logout
                  title: Text('Logout'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit), // Icon for Edit User
                  title: Text('Edit User'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
