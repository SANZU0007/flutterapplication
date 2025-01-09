import 'package:flutter/material.dart';
import 'package:testapp/colors.dart';
import 'package:testapp/dashboard/dashboard.dart';
import 'package:testapp/login_screen.dart';
// Make sure to import the Dashboard screen

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Future<void> Function() fetchData;
  final String displayID;
  final String names;
  final String apiKeys;

  const DashboardAppBar({
    super.key,
    required this.fetchData,
    required this.displayID,
    required this.names,
    required this.apiKeys,
  });

  @override
  _DashboardAppBarState createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.displayID, // Use widget.displayID to access the displayID
        style: const TextStyle(
          color: Colors.white, // Set the color of the title text
        ),
      ),
      backgroundColor: primaryColor, // Sets the AppBar's background color

      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          color: primaryColorbg,
          tooltip: 'Logout',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.refresh,
          ),
          color: primaryColorbg,
          tooltip: 'Go to Dashboard',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(
                  // Navigate to Dashboard screen
                  name: widget.names,
                  apiKey: widget.apiKeys,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
