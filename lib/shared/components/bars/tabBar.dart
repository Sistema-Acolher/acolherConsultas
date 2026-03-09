import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final List<String> tabs_;
  final List<Widget> views_;
  final List<Widget>? fabs_;
  const CustomTabBar({super.key, this.appBar, required this.tabs_, required this.views_, this.fabs_});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin  {
  late final TabController _tabController;
  
  @override
  void initState() {
    assert(widget.tabs_.length == widget.views_.length && (widget.fabs_ == null || widget.tabs_.length == widget.fabs_!.length));

    super.initState();
    _tabController = TabController(length: widget.tabs_.length, vsync: this);

    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var listTabs = widget.tabs_.map<Tab>((e) => Tab(text: e)).toList();
    return Scaffold(
      appBar: widget.appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: widget.fabs_ != null ? widget.fabs_![_tabController.index] : null,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50, top: 15, left: 20, right: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    spreadRadius: 3,
                    blurRadius: 9.1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:  DefaultTabController( length: 3,
                child: TabBar.secondary(
                  controller: _tabController,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4,
                      color: Colors.black,
                    )
                  ),
                  labelPadding: const EdgeInsets.only(left: 0, right: 0),
                  unselectedLabelStyle: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontFamily: "Montserrat", color: Color(0xFF151515)),
                  labelStyle:           const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold, fontFamily: "Montserrat", color: Color(0xFF5DB075)),
                  tabs: listTabs
                ),
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.views_
              )
            )
          ],
        ),
      )
    );
  }
}