import 'package:flutter/material.dart';
import 'package:testapp/colors.dart';

class DashboardAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Future<void> Function() fetchData;

  const DashboardAppBar({super.key, required this.fetchData});

  @override
  _DashboardAppBarState createState() => _DashboardAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DashboardAppBarState extends State<DashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Dashboard',
        style: TextStyle(
          color: Colors
              .white, // Set the color of the title text (replace with primaryColorbg if needed)
        ),
      ),
      backgroundColor: primaryColor, // Sets the AppBar's background color

      actions: [
        IconButton(
          icon: const Icon(
            Icons.refresh,
          ),
          color: primaryColorbg, // Sets the color of the icon to primaryColorbg
          tooltip: 'Refresh',
          onPressed: () {
            // Call the fetchData function when the refresh button is clicked
            widget.fetchData().then((_) {
              // Optionally, show a snack bar or any other indicator
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data refreshed')),
              );
            }).catchError((e) {
              // Handle error if fetching data fails
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to refresh data: $e')),
              );
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          color: primaryColorbg,
          tooltip: 'Logout',
          onPressed: () {
            // Add your logout logic here
          },
        ),
      ],
    );
  }
}
