import 'package:flutter/material.dart';
import 'package:together/Controller/Chat.dart';
import 'package:together/Controller/Home.dart';
import 'package:together/Controller/Settings.dart';
import 'package:together/Controller/SharedMedia.dart';
import 'package:together/Controller/Notes.dart';
import 'package:together/Core/UIFunctions.dart';

import 'package:together/ViewModel/ChatViewModel.dart';

import 'package:flutter/cupertino.dart';

class BarItem {
  String name;
  Icon icon;

  BarItem(this.name, this.icon);
}

class MainNavigation extends StatefulWidget {
  MainNavigation({Key key, this.page}) : super(key: key);

  final int page;

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex;

  BarItem _homePage = BarItem("Home", Icon(Icons.home));
  BarItem _mediaPage = BarItem("Media", Icon(Icons.perm_media));
  BarItem _chatPage = BarItem("Chat", Icon(Icons.chat));
  BarItem _notesPage = BarItem("Notes", Icon(Icons.text_fields));
  BarItem _settingsPage = BarItem("Settings", Icon(Icons.settings));

  List<BarItem> _barItems = [];

  //! TODO: init background and getSender separately from ChatViewModel
  final _chatViewModel = ChatViewModel();

  Widget chatWidget;
  List<Widget> _widgets = [];

  final _chatIndex = 2;

  @override
  void initState() {
    _chatViewModel.init();

    chatWidget = Chat(viewModel: _chatViewModel);

    _widgets = [Home(), SharedMedia(), chatWidget, Notes(), Settings()];
    _barItems = [_homePage, _mediaPage, _chatPage, _notesPage, _settingsPage];
    _selectedIndex = widget.page == null ? 0 : widget.page;
    super.initState();
  }

  @override
  void dispose() {
    _chatViewModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgets,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _createTabs(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.blueGrey,
      ),
    );
  }

  void _onItemTapped(int index) async {
    if (index == _chatIndex) {
      //! using Future to build page before pushing
      //! (hope it works...)
      Widget page = await Future.microtask(() {
        return Chat(viewModel: _chatViewModel);
      });

      pushPage(context, page);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  List<BottomNavigationBarItem> _createTabs() {
    return _barItems.map<BottomNavigationBarItem>((page) {
      return BottomNavigationBarItem(
          icon: page.icon,
          label: page.name
          // title: Text(
          //   page.name,
          //   style: TextStyle(fontSize: 14),
          // )
      );
    }).toList();
  }
}
