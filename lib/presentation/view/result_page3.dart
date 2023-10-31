import 'dart:math';

import 'package:android_studyjams/presentation/controller/result_controller3.dart';
import 'package:android_studyjams/presentation/widget/text_badge.dart';
import 'package:android_studyjams/utils/colors.dart';
import 'package:android_studyjams/utils/juara.dart';
import 'package:android_studyjams/utils/routes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const githubUrl = 'https://github.com/sownt/android-studyjams';
const juaraUrl = 'https://juara.sownt.com';
const chienBinhAndroidUrl = 'https://chienbinhandroid.sownt.com';
const completionForm = 'https://docs.google.com/forms/d/e/1FAIpQLSe5jDAHa7GCbSAul7neFdW-aghNiRMJWzu71OF_2SpORnHPLg/viewform';

class ResultPage3 extends GetResponsiveView<ResultController3> {
  ResultPage3({super.key}) {
    controller.load(Get.parameters['id']);
  }

  Widget _buildBodyList({double? width}) {
    final timeLeft = DateTime.utc(2023, 11, 4, 23, 59, 59)
        .difference(DateTime.now().toUtc())
        .inDays;
    return controller.obx(
      (state) => CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: CarouselSlider(
          //     options: CarouselOptions(height: 400.0),
          //     items: [
          //       'https://i.imgur.com/rKm85vT.png',
          //       'https://i.imgur.com/XPSXkjl.png',
          //       'https://i.imgur.com/r9g2KmF.jpeg',
          //       'https://images.tokopedia.net/img/cache/700/OJWluG/2022/6/15/1d389e79-5935-4435-b8bb-bcfd1a95e0f8.jpg',
          //       'https://i.imgur.com/uAzQefE.png',
          //     ].map((url) => Image.network(url, fit: BoxFit.contain)).toList(),
          //   ),
          // ),
          if (width != null)
            SliverToBoxAdapter(
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: const Text('#JuaraAndroid'),
                        onPressed: () async {
                          await launchUrl(Uri.parse(juaraUrl));
                        },
                      ),
                      TextButton(
                        child: const Text('#ChienBinhAndroid'),
                        onPressed: () async {
                          await launchUrl(Uri.parse(chienBinhAndroidUrl));
                        },
                      ),
                      TextButton(
                        child: const Text('GitHub repo'),
                        onPressed: () async {
                          await launchUrl(Uri.parse(githubUrl));
                        },
                      ),
                      TextButton(
                        child: const Text('Completion Form'),
                        onPressed: () async {
                          await launchUrl(Uri.parse(completionForm));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width ?? double.infinity,
                ),
                child: Material(
                  child: ExpansionTile(
                    leading: const Icon(Icons.dataset_rounded),
                    title: Wrap(
                      runAlignment: WrapAlignment.center,
                      spacing: 8.0,
                      children: [
                        const Text('Your Progress'),
                        TextBadge(
                          text: timeLeft <= 1
                              ? '$timeLeft day left'
                              : '$timeLeft days left',
                          color:
                              timeLeft <= 1 ? AppColors.red : AppColors.yellow,
                        )
                      ],
                    ),
                    initiallyExpanded: true,
                    children: [
                      ListTile(
                        title: const Text('Tier 1'),
                        trailing: TextBadge(
                          text: '${controller.path1Badges}/14',
                          color: controller.path1Badges == 0
                              ? AppColors.red
                              : controller.path1Badges < 14
                                  ? AppColors.yellow
                                  : AppColors.green,
                        ),
                      ),
                      ListTile(
                        title: const Text('Tier 2'),
                        trailing: TextBadge(
                          text: '${controller.path2Badges}/25',
                          color: controller.path2Badges == 0
                              ? AppColors.red
                              : controller.path2Badges < 25
                                  ? AppColors.yellow
                                  : AppColors.green,
                        ),
                      ),
                      ListTile(
                        title: const Text('Overall'),
                        trailing: controller.path1Badges < 14
                            ? const TextBadge.blue(text: 'not availble')
                            : controller.path2Badges < 25
                                ? const TextBadge.yellow(text: 'tier 1')
                                : const TextBadge.green(text: 'tier 2'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              final item = state?[index];

              // Course item
              if (item.runtimeType == Course) {
                final course = item as Course;
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width ?? double.infinity,
                    ),
                    child: Material(
                      child: ExpansionTile(
                        initiallyExpanded: !course.isCompleted(),
                        childrenPadding: const EdgeInsets.only(bottom: 16),
                        title: course.label != null
                            ? Wrap(
                                spacing: 8.0,
                                direction: Axis.horizontal,
                                children: [
                                  Text(course.title),
                                  TextBadge.blue(text: course.label!),
                                  course.isCompleted()
                                      ? const TextBadge.green(text: 'completed')
                                      : const TextBadge.error(
                                          text: 'not completed'),
                                ],
                              )
                            : Text(course.title),
                        children: course.pathways?.map(
                              (pathway) {
                                final earnedOn = pathway.earnedOn != null
                                    ? DateFormat('MMM d, yyyy').format(
                                        DateTime.parse(pathway.earnedOn!),
                                      )
                                    : null;
                                return ListTile(
                                  leading: SvgPicture.network(
                                    pathway.getBadgeSvg(),
                                    width: 64,
                                  ),
                                  title: Text(pathway.title),
                                  subtitle: Wrap(
                                    spacing: 8.0,
                                    direction: Axis.horizontal,
                                    children: [
                                      pathway.earnedOn != null
                                          ? TextBadge.green(
                                              text: 'earned on $earnedOn')
                                          : const TextBadge.error(
                                              text: 'not earned'),
                                      pathway.isValid()
                                          ? const TextBadge.green(text: 'valid')
                                          : const TextBadge.error(
                                              text:
                                                  'must be earned between 07 Oct to 04 Nov, 2023'),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.open_in_new),
                                    onPressed: () async {
                                      await launchUrl(
                                          Uri.parse(pathway.url ?? ''));
                                    },
                                  ),
                                );
                              },
                            ).toList() ??
                            [],
                      ),
                    ),
                  ),
                );
              }

              // Fallback to Pathway item
              final pathway = state![index] as Pathway;
              final earnedOn = pathway.earnedOn != null
                  ? DateFormat('MMM d, yyyy').format(
                      DateTime.parse(pathway.earnedOn!),
                    )
                  : null;
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: width ?? double.infinity,
                  ),
                  child: Material(
                    child: ListTile(
                      leading: SvgPicture.network(
                        pathway.getBadgeSvg(),
                        width: 64,
                      ),
                      title: Text(pathway.title),
                      subtitle: Wrap(
                        spacing: 8.0,
                        direction: Axis.horizontal,
                        children: [
                          pathway.earnedOn != null
                              ? TextBadge.green(text: 'earned on $earnedOn')
                              : const TextBadge.error(text: 'not earned'),
                          pathway.isValid()
                              ? const TextBadge.green(text: 'valid')
                              : const TextBadge.error(text: 'invalid'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new),
                        onPressed: () async {
                          await launchUrl(Uri.parse(state[index].url ?? ''));
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: state?.length,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 128,
              width: width ?? double.infinity,
              child: Center(
                child: Material(
                  elevation: 0.0,
                  color: AppColors.transparent,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.star_rounded),
                    label: const Text('Give me a star on GitHub'),
                    onPressed: () async {
                      await launchUrl(Uri.parse(githubUrl));
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _resolvePathway(Pathway pathway) {
    if (pathway.earnedOn == null) return 'not earned';
    if (pathway.isValid()) {
      return 'valid';
    }
    return 'invalid';
  }

  @override
  Widget? desktop() {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: _buildBodyList(width: min(960, constraints.maxWidth)),
          );
        },
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('#JuaraAndroid'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Center(
                child: Icon(
                  Icons.android_rounded,
                  size: 64,
                  color: AppColors.green,
                ),
              ),
            ),
            ListTile(
              title: const Text('#JuaraAndroid'),
              onTap: () async {
                await launchUrl(Uri.parse(juaraUrl));
              },
              trailing: GestureDetector(
                child: const Icon(Icons.open_in_new),
              ),
            ),
            ListTile(
              title: const Text('#ChienBinhAndroid'),
              onTap: () async {
                await launchUrl(Uri.parse(chienBinhAndroidUrl));
              },
              trailing: GestureDetector(
                child: const Icon(Icons.open_in_new),
              ),
            ),
            const Spacer(),
            ListTile(
              title: const Text('GitHub repo'),
              onTap: () async {
                await launchUrl(Uri.parse(githubUrl));
              },
              trailing: GestureDetector(
                child: const Icon(Icons.open_in_new),
              ),
            ),
            ListTile(
              title: const Text('Completion Form'),
              onTap: () async {
                await launchUrl(Uri.parse(completionForm));
              },
              trailing: GestureDetector(
                child: const Icon(Icons.open_in_new),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _buildBodyList(),
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
