import 'dart:io';

import 'package:android_studyjams/config/config.g.dart';
import 'package:android_studyjams/domain/entity/award.dart';
import 'package:android_studyjams/domain/repository/data_repository.dart';
import 'package:android_studyjams/locator.dart';
import 'package:android_studyjams/utils/strings.g.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

/// This file is used for JuaraAndroid
class ResultController2 extends GetxController with StateMixin<List<Award>?> {
  int valid = 0;
  int tier = 0;

  final List<String> path1 = [
    "introduction to programming in kotlin", // "introduction to kotlin",
    "set up android studio", // "setup android studio",
    "build a basic layout",
    "kotlin fundamentals",
    "add a button to an app",
    "interacting with ui and state",
    "more kotlin fundamentals",
    "build a scrollable list",
    "add theme and animation", // "build beautiful apps",
    "architecture components",
    "navigation in jetpack compose",
    "adaptive layouts", // "adapt for different screen sizes",
    "get data from the internet",
    "load and display images from the internet",
  ];

  final List<String> path2 = [
    "introduction to sql",
    "use room for data persistence",
    "store and access data using keys with datastore",
    "schedule tasks with workmanager",
    "android views and compose in views",
    "views in compose",
    "compose essentials",
    "layouts, theming, and animation",
    "architecture and state",
    "accessibility, testing, and performance",
    "form factors",
  ];

  DateTime start = DateTime.utc(2023, 10, 7);
  DateTime end = DateTime.utc(2023, 11, 4, 23, 59, 59);

  bool isValidDate(Award a) {
    return DateTime.parse(a.createTime!).isAfter(start) && DateTime.parse(a.createTime!).isBefore(end);
  }

  int getTier(List<Award> awards) {
    int p1c = 0, p2c = 0;
    for (var award in awards) {
      if (isValidDate(award)) {
        if (path1.contains(award.title?.toLowerCase())) {
          p1c++;
        }
        if (path2.contains(award.title?.toLowerCase())) {
          p2c++;
        }
      }
    }
    if (p1c == path1.length) {
      if (p2c == path2.length) {
        return 2;
      } else {
        return 1;
      }
    }
    return 0;
  }

  ResultController2() {
    change(null, status: RxStatus.empty());
  }

  int count(List<Award> awards) {
    int count = 0;
    for (var element in awards) {
      if (Config.isValid(element)) {
        count++;
      }
    }
    return count;
  }

  Future<void> load(String? id) async {
    if (id == null || id.isEmpty) {
      change(null, status: RxStatus.error('Missing username.'));
      return;
    }
    try {
      change(null, status: RxStatus.loading());
      final awards = await locator<DataRepository>().getAwards(id);
      if (awards != null) {
        valid = count(awards);
        tier = getTier(awards);
      }
      change(
        awards,
        status: awards == null || awards.isEmpty
            ? RxStatus.empty()
            : RxStatus.success(),
      );
    } on HttpException catch (e) {
      change([], status: RxStatus.error(e.message));
    } catch (_) {
      change([], status: RxStatus.error(AppStrings.errorOccurred.tr));
    }
  }
}
