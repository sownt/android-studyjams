import 'dart:math';

import 'package:android_studyjams/config/config.g.dart';
import 'package:android_studyjams/domain/entity/award.dart';
import 'package:android_studyjams/presentation/controller/result_controller2.dart';
import 'package:android_studyjams/presentation/widget/awards_table.dart';
import 'package:android_studyjams/presentation/widget/custom_scaffold.dart';
import 'package:android_studyjams/presentation/widget/process_bar.dart';
import 'package:android_studyjams/utils/constants.dart';
import 'package:android_studyjams/utils/dimensions.dart';
import 'package:android_studyjams/utils/routes.dart';
import 'package:android_studyjams/utils/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultPage2 extends GetResponsiveView<ResultController2> {
  ResultPage2({super.key}) {
    final id = Get.parameters['id'];
    controller.load(id);
  }

  final validStyle = const TextStyle(
    color: Colors.green,
  );

  final invalidStyle = const TextStyle(
    color: Colors.red,
    decoration: TextDecoration.lineThrough,
    decorationColor: Colors.red,
  );

  String _buildHeaderString(int value) {
    if (value == 0) {
      return '${AppStrings.letsStart.trParams({
            'num': controller.end
                .difference(DateTime.now().toUtc())
                .inDays
                .toString(),
          })} (0/20)';
    }
    if (value < 12) {
      return '${AppStrings.keepFighting.trParams({
            'num': (12 - value).toString(),
          })} ($value/20)';
    }
    if (value >= 12 && value < 20) {
      return '${AppStrings.congratulations.trParams({
            'tier': '1',
          })} ($value/20)';
    }
    return '${AppStrings.congratulations.trParams({
          'tier': '2',
        })} ($value/20)';
  }

  SliverToBoxAdapter _header(context, constraints) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.l,
        ).copyWith(
          top: Dimensions.m,
          bottom: Dimensions.m,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth / 2,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.l,
                  horizontal: Dimensions.l,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _buildHeaderString(controller.valid),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(
                    //   height: Dimensions.m,
                    // ),
                    // ProcessBar(
                    //   value: controller.valid,
                    //   total: 20,
                    //   width: constraints.maxWidth / 2.5,
                    //   label: controller.valid >= 20
                    //       ? 'Tier 2'
                    //       : controller.valid >= 12
                    //           ? 'Tier 1'
                    //           : '${controller.valid}/20',
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _bottom(context, constraints) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.l,
        ).copyWith(
          bottom: Dimensions.m,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth / 2,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.l,
                  horizontal: Dimensions.m,
                ),
                child: Center(
                  child: Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.spaceEvenly,
                    children: [
                      Text(AppStrings.seeding.tr),
                      TextButton.icon(
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(AppConstants.githubRepo),
                          );
                        },
                        icon: const Icon(Icons.star),
                        label: Text(AppStrings.starThisProject.tr),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(AppConstants.githubProfile),
                          );
                        },
                        icon: const Icon(Icons.rss_feed),
                        label: Text(AppStrings.followMeOnGithub.tr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DateTime start = DateTime.utc(2023, 10, 7);
  DateTime end = DateTime.utc(2023, 11, 4, 23, 59, 59);

  bool isValidDate(Award a) {
    return DateTime.parse(a.createTime!).isAfter(start) &&
        DateTime.parse(a.createTime!).isBefore(end);
  }

  @override
  Widget? desktop() {
    return CustomScaffold(
      body: controller.obx(
        (state) => LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: max(600, constraints.maxWidth / 2),
                      ),
                      child: const Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: SizedBox(
                            width: 64,
                            height: 64,
                            child: Center(
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          title: Text('Tier 1'),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final item = state?.firstWhere(
                      (element) =>
                          controller.path1[index] ==
                          element.title?.toLowerCase(),
                      orElse: () => Award(null, null, null),
                    );
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: max(600, constraints.maxWidth / 2),
                        ),
                        child: Material(
                          child: ListTile(
                            leading: SvgPicture.network(
                              'https://cdn.sownt.com/badges/${controller.path1[index].replaceAll(' ', '_').replaceAll(',', '')}.svg',
                              width: 64,
                            ),
                            title: Text(item?.title ?? controller.path1[index]),
                            subtitle: Text(
                              item?.createTime != null
                                  ? DateFormat('MMM d, yyyy').format(
                                      DateTime.parse(item?.createTime ?? ','),
                                    )
                                  : 'not earned',
                              style:
                                  item?.createTime != null && isValidDate(item!)
                                      ? validStyle
                                      : invalidStyle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.path1.length,
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: max(600, constraints.maxWidth / 2),
                      ),
                      child: const Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: SizedBox(
                            width: 64,
                            height: 64,
                            child: Center(
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          title: Text('Tier 2'),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final item = state?.firstWhere(
                      (element) =>
                          controller.path2[index] ==
                          element.title?.toLowerCase(),
                      orElse: () => Award(null, null, null),
                    );
                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: max(600, constraints.maxWidth / 2),
                        ),
                        child: Material(
                          child: ListTile(
                            leading: SvgPicture.network(
                              'https://cdn.sownt.com/badges/${controller.path2[index].replaceAll(' ', '_').replaceAll(',', '')}.svg',
                              width: 64,
                            ),
                            title: Text(item?.title ?? controller.path2[index]),
                            subtitle: Text(
                              item?.createTime != null
                                  ? DateFormat('MMM d, yyyy').format(
                                      DateTime.parse(item?.createTime ?? ','),
                                    )
                                  : 'not earned',
                              style:
                                  item?.createTime != null && isValidDate(item!)
                                      ? validStyle
                                      : invalidStyle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.path2.length,
                ),
              ],
            );
          },
        ),
        onLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        onError: (error) => Center(
          child: Text(error ?? 'Error occurs.'),
        ),
        onEmpty: const Center(
          child: Text('Empty.'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAndToNamed(AppRoutes.home);
        },
        child: const Icon(Icons.home),
      ),
    );
  }

  @override
  Widget? phone() {
    return CustomScaffold(
      body: controller.obx(
        (state) => LayoutBuilder(
          builder: (context, constraints) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  title: Text('#JuaraAndroid'),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: const Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: SizedBox(
                            width: 64,
                            height: 64,
                            child: Center(
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          title: Text('Tier 1'),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final item = state?.firstWhere(
                      (element) =>
                          controller.path1[index] ==
                          element.title?.toLowerCase(),
                      orElse: () => Award(null, null, null),
                    );
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Material(
                          child: ListTile(
                            leading: SvgPicture.network(
                              'https://cdn.sownt.com/badges/${controller.path1[index].replaceAll(' ', '_').replaceAll(',', '')}.svg',
                              width: 64,
                            ),
                            title: Text(item?.title ?? controller.path1[index]),
                            subtitle: Text(
                              item?.createTime != null
                                  ? DateFormat('MMM d, yyyy').format(
                                      DateTime.parse(item?.createTime ?? ','),
                                    )
                                  : 'not earned',
                              style:
                                  item?.createTime != null && isValidDate(item!)
                                      ? validStyle
                                      : invalidStyle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.path1.length,
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: const Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: SizedBox(
                            width: 64,
                            height: 64,
                            child: Center(
                              child: Icon(
                                Icons.star_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          title: Text('Tier 2'),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final item = state?.firstWhere(
                      (element) =>
                          controller.path2[index] ==
                          element.title?.toLowerCase(),
                      orElse: () => Award(null, null, null),
                    );
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Material(
                          child: ListTile(
                            leading: SvgPicture.network(
                              'https://cdn.sownt.com/badges/${controller.path2[index].replaceAll(' ', '_').replaceAll(',', '')}.svg',
                              width: 64,
                            ),
                            title: Text(item?.title ?? controller.path2[index]),
                            subtitle: Text(
                              item?.createTime != null
                                  ? DateFormat('MMM d, yyyy').format(
                                      DateTime.parse(item?.createTime ?? ','),
                                    )
                                  : 'not earned',
                              style:
                                  item?.createTime != null && isValidDate(item!)
                                      ? validStyle
                                      : invalidStyle,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: controller.path2.length,
                ),
              ],
            );
          },
        ),
        onLoading: const Center(
          child: CircularProgressIndicator(),
        ),
        onError: (error) => Center(
          child: Text(error ?? 'Error occurs.'),
        ),
        onEmpty: const Center(
          child: Text('Empty.'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.offAndToNamed(AppRoutes.home);
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}
