import 'package:assignment1/screens/home.dart';
import 'package:assignment1/screens/task.dart';
import 'package:assignment1/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  int selectedIndex = 0;
  List<Widget> _WidgetOptions = <Widget>[TaskScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _WidgetOptions.elementAt(selectedIndex),
      bottomNavigationBar: Container(
        color: lightColorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              backgroundColor: lightColorScheme.primary,
              color: Colors.white24,
              activeColor: Colors.white,
              tabBackgroundColor: lightColorScheme.secondary,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                ),
                GButton(
                  icon: CupertinoIcons.tags_solid,
                  text: "Tasks",
                )
              ]),
        ),
      ),
    );
  }
}
