import 'dart:io';

import 'package:android_studyjams/domain/entity/award.dart';
import 'package:android_studyjams/domain/repository/data_repository.dart';
import 'package:android_studyjams/locator.dart';
import 'package:android_studyjams/utils/juara.dart';
import 'package:android_studyjams/utils/strings.g.dart';
import 'package:get/get.dart';

class ResultController3 extends GetxController
    with StateMixin<List<Requirement>> {
  ResultController3() {
    change(requirements, status: RxStatus.success());
  }

  int path1Badges = 0;
  int path2Badges = 0;

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

  List<Requirement> getResult(List<Award> awards) {
    final re = requirements;
    var path1Count = 0;
    var path2Count = 0;
    for (var r in re) {
      if (r.runtimeType == Course) {
        final course = r as Course;
        for (var pathway in course.pathways ?? <Pathway>[]) {
          final matched = awards.firstWhere(
            (award) =>
                award.title
                    ?.toLowerCase()
                    .replaceAll(' ', '_')
                    .replaceAll(',', '') ==
                pathway.getBadgeName(),
            orElse: () => Award(null, null, null),
          );
          pathway.earnedOn = matched.createTime;
          if (pathway.earnedOn != null && pathway.isValid()) {
            if (path1.contains(pathway.getBadgeName().replaceAll('_', ' '))) {
              path1Count++;
            } else if (path2.contains(pathway.getBadgeName().replaceAll('_', ' '))) {
              path2Count++;
            }
          }
        }
      } else if (r.runtimeType == Pathway) {
        final pathway = r as Pathway;
        final matched = awards.firstWhere(
          (award) =>
              award.title
                  ?.toLowerCase()
                  .replaceAll(' ', '_')
                  .replaceAll(',', '') ==
              pathway.getBadgeName(),
          orElse: () => Award(null, null, null),
        );
        pathway.earnedOn = matched.createTime;
      }
    }
    path1Badges = path1Count;
    path2Badges = path1Count + path2Count;
    return re;
  }

  Future<void> load(String? id) async {
    if (id == null || id.isEmpty) {
      change(null, status: RxStatus.error('Missing username.'));
      return;
    }
    try {
      change(null, status: RxStatus.loading());
      final awards = await locator<DataRepository>().getAwards(id);
      if (awards == null || awards.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(
          getResult(awards),
          status: RxStatus.success(),
        );
      }
    } on HttpException catch (e) {
      change([], status: RxStatus.error(e.message));
    } catch (_) {
      change([], status: RxStatus.error(AppStrings.errorOccurred.tr));
    }
  }
}
