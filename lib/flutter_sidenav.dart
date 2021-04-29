library flutter_sidenav;

import 'package:flutter/material.dart';

class SideNavItem {
  final String name;
  final IconData iconData;
  final Widget page;

  const SideNavItem({
    this.name,
    this.iconData,
    this.page,
  });
}

class SideBar extends StatefulWidget {
  final Color backgroundColor;
  final double sideBarWidth;
  final double sideBarCollapsedWidth;

  final Widget currentItem;

  final List<SideNavItem> items;
  final Function show;

  final int selectedIndex;
  final Color selectedColor;

  SideBar({
    this.backgroundColor = Colors.blueGrey,
    @required this.currentItem,
    @required this.items,
    this.sideBarCollapsedWidth = 60,
    this.sideBarWidth = 180,
    this.show,
    this.selectedIndex,
    this.selectedColor = Colors.transparent,
  });

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  bool showText = false;
  bool _first = true;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _controller.addListener(() {
      if (_controller.status == AnimationStatus.completed) {
        if (_first) {
          _first = false;
        }

        if (isCollapsed) {
          setState(() {
            showText = true;
          });
        } else {
          setState(() {
            showText = false;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animation =
        Tween<double>(begin: isCollapsed ? 0 : 0.5, end: isCollapsed ? 0.5 : 1)
            .animate(_controller);

    final Locale appLocale = Localizations.localeOf(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.zero,
      elevation: 4,
      child: Row(children: [
        AnimatedContainer(
          duration: _controller.duration,
          color: widget.backgroundColor,
          width:
              isCollapsed ? widget.sideBarCollapsedWidth : widget.sideBarWidth,
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.items
                        .asMap()
                        .map((index, item) {
                          final view = NavItemTile(
                            isCollapsed: showText ? true : isCollapsed,
                            // hoverColor: Colors.blue,
                            selectedColor: widget.selectedIndex != index
                                ? null
                                : widget.selectedColor,
                            title: Text(
                              item.name,
                              style: TextStyle(
                                color: widget.selectedIndex == index
                                    ? Colors.white
                                    : null,
                              ),
                            ),
                            icon: Icon(
                              item.iconData,
                              color: widget.selectedIndex == index
                                  ? Colors.white
                                  : null,
                            ),
                            onPressed: () => widget.show(index),
                          );
                          return MapEntry<int, Widget>(index, view);
                        })
                        .values
                        .toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(end: isCollapsed ? 0 : 12),
                  alignment: isCollapsed
                      ? AlignmentDirectional.center
                      : AlignmentDirectional.centerEnd,
                  child: RotationTransition(
                    turns: _animation,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: Container(
                              margin: EdgeInsetsDirectional.only(
                                end: _first
                                    ? 0
                                    : isCollapsed
                                        ? 8
                                        : 8,
                              ),
                               child: Icon(
                                  _first ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                                  size: 24,
                                  textDirection:
                                      appLocale.languageCode == "he"
                                          ? TextDirection.ltr
                                          : TextDirection.rtl)),
                          onPressed: () {
                            _controller.forward(
                              from: 0,
                            );
                            setState(() {
                              isCollapsed = !isCollapsed;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        Expanded(child: widget.currentItem)
      ]),
    );
  }
}

class NavItemTile extends StatelessWidget {
  final Color hoverColor;
  final Widget title;
  final Widget icon;
  final bool isCollapsed;
  final Function onPressed;
  final Color selectedColor;

  NavItemTile(
      {@required this.isCollapsed,
      @required this.title,
      @required this.icon,
      this.onPressed,
      this.hoverColor,
      this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: onPressed,
        hoverColor: hoverColor,
        child: ListTile(
          selected: selectedColor != null,
          selectedTileColor: selectedColor,
          leading: icon,
          title: isCollapsed ? null : title,
        ),
      ),
    );
  }
}

class SideBarScaffold extends StatefulWidget {
  final List<SideNavItem> items;
  final Color backgroundColor;
  final Color selectedColor;
  final double sideBarWidth;

  const SideBarScaffold({
    Key key,
    this.backgroundColor = Colors.blueGrey,
    this.sideBarWidth = 180,
    @required this.items,
    this.selectedColor,
  }) : super(key: key);

  @override
  _SideBarScaffoldState createState() => _SideBarScaffoldState();
}

class _SideBarScaffoldState extends State<SideBarScaffold> {
  Widget currentItem;
  int currentItemIndex;

  @override
  void initState() {
    super.initState();
    currentItem = widget.items.first.page;
    currentItemIndex = 0;
  }

  void show(int index) {
    setState(() {
      currentItemIndex = index;
      currentItem = widget.items[index].page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideBar(
      currentItem: currentItem,
      backgroundColor: widget.backgroundColor,
      sideBarWidth: widget.sideBarWidth,
      items: widget.items,
      selectedColor: widget.selectedColor,
      selectedIndex: currentItemIndex,
      show: show,
    );
  }
}
