import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:pixez/generated/i18n.dart';
import 'package:pixez/page/hello/ranking/bloc.dart';
import 'package:pixez/page/hello/ranking/ranking_mode/ranking_mode_page.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  final modeList = [
    "day",
    "day_male",
    "day_female",
    "week_original",
    "week_rookie",
    "week",
    "month",
    "day_r18",
    "week_r18"
  ];
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: modeList.length);
    super.initState();
  }

  String toRequestDate(DateTime dateTime) {
    if (dateTime == null) {
      return null;
    }
    debugPrint("${dateTime.year}-${dateTime.month}-${dateTime.day}");
    return "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RankingBloc>(
      create: (context) => RankingBloc(),
      child: BlocBuilder<RankingBloc, RankingState>(
        builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(I18n.of(context).Rank),
            bottom: TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: modeList.map((f) {
                  return Tab(
                    text: f,
                  );
                }).toList()),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      maxDateTime: DateTime.now(),
                      initialDateTime: DateTime.now(),
                      onConfirm: (DateTime dateTime, List<int> list) {
                    BlocProvider.of<RankingBloc>(context)
                        .add(DateChangeEvent(dateTime));
                  });
                },
              )
            ],
          ),
          body: TabBarView(
              controller: _tabController,
              children: modeList.map((f) {
                return RankingModePage(
                  mode: f,
                  date: (state is DateState)
                      ? toRequestDate(state.dateTime)
                      : null,
                );
              }).toList()),
        );
      }),
    );
  }
}