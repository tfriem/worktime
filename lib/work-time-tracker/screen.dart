import 'package:flutter/material.dart';

import '../l10n.dart';
import 'booking_detail.dart';
import 'graph.dart';
import 'horizontal_calendar.dart';
import 'overview.dart';

class WorkTimeTrackerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Work Time Tracker'),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: OrganizerLocalization.of(context).timesTitle),
                Tab(text: OrganizerLocalization.of(context).overviewTitle),
                Tab(text: OrganizerLocalization.of(context).chartsTitle)
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(child: BookingDetail()),
                  Card(
                      child:
                          Container(height: 100.0, child: HorizontalCalendar()))
                ],
              ),
              Overview(),
              Column(
                children: <Widget>[Expanded(child: Graph())],
              )
            ],
          )),
    );
  }
}
