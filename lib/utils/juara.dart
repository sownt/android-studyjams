class Requirement {
  final String title;
  final String? url;

  Requirement({required this.title, this.url});
}

class Pathway extends Requirement {
  final String? img;
  final String? badgeName;
  String? earnedOn;

  Pathway(
      {required super.title,
      super.url,
      this.img,
      this.badgeName,
      this.earnedOn});

  DateTime start = DateTime.utc(2023, 10, 7).subtract(const Duration(hours: 9));
  DateTime end = DateTime.utc(2023, 11, 4, 23, 59, 59).subtract(const Duration(hours: 9));

  bool isValid() {
    if (earnedOn == null) return false;
    return DateTime.parse(earnedOn!).isAfter(start) &&
        DateTime.parse(earnedOn!).isBefore(end);
  }

  String getBadgeSvg() {
    final name =
        badgeName?.toLowerCase().replaceAll(' ', '_').replaceAll(',', '') ??
            title.toLowerCase().replaceAll(' ', '_').replaceAll(',', '');
    return 'https://cdn.sownt.com/badges/$name.svg';
  }

  String getBadgeName() {
    return badgeName?.toLowerCase() ?? title.toLowerCase();
  }
}

class Course extends Requirement {
  final List<Pathway>? pathways;
  final String? label;

  Course({required super.title, super.url, this.pathways, this.label});

  bool isCompleted() {
    if (pathways == null) return false;
    for (var pathway in pathways!) {
      if (!pathway.isValid()) {
        return false;
      }
    }
    return true;
  }
}

final List<String> urls = [
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-1-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-1-pathway-2',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-1-pathway-3',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-2',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-3',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-2',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-3',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-4-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-4-pathway-2',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-4-pathway-3',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-5-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-5-pathway-2',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-6-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-6-pathway-2',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-6-pathway-3',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-7-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-8-pathway-1',
  'https://developer.android.com/courses/pathways/android-basics-compose-unit-8-pathway-2',
  'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-1',
  'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-2',
  'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-3',
  'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-4',
  'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-5'
];

final List<Requirement> requirements = [
  Course(
    title: 'Your first Android app',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-1',
    label: 'Unit 1',
    pathways: [
      Pathway(
        title: 'Introduction to Kotlin',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-1-pathway-1',
        badgeName: 'introduction to programming in kotlin',
      ),
      Pathway(
        title: 'Setup Android Studio',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-1-pathway-2',
        badgeName: 'set up android studio',
      ),
      Pathway(
        title: 'Build a basic layout',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-1-pathway-3',
      ),
    ],
  ),
  Course(
    title: 'Building app UI',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-2',
    label: 'Unit 2',
    pathways: [
      Pathway(
        title: 'Kotlin fundamentals',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-2', // 'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-1',
      ),
      Pathway(
        title: 'Add a button to an app',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-2',
      ),
      Pathway(
          title: 'Interact with UI and state',
          url:
              'https://developer.android.com/courses/pathways/android-basics-compose-unit-2-pathway-3',
          badgeName: 'interacting with ui and state'),
    ],
  ),
  Course(
    title: 'Display lists and use Material Design',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-3',
    label: 'Unit 3',
    pathways: [
      Pathway(
        title: 'More Kotlin fundamentals',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-2', // 'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-1',
      ),
      Pathway(
        title: 'Build a scrollable list',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-3', // 'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-2',
      ),
      Pathway(
          title: 'Build beautiful apps',
          url:
              'https://developer.android.com/courses/pathways/android-basics-compose-unit-3-pathway-3',
          badgeName: 'add theme and animation'),
    ],
  ),
  Course(
    title: 'Navigation and app architecture',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-4',
    label: 'Unit 4',
    pathways: [
      Pathway(
        title: 'Architecture Components',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-4-pathway-1',
      ),
      Pathway(
        title: 'Navigation in Jetpack Compose',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-4-pathway-2',
      ),
      Pathway(
        title: 'Adapt for different screen sizes',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-4-pathway-3',
        badgeName: 'adaptive layouts',
      ),
    ],
  ),
  Course(
    title: 'Connect to the internet',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-5',
    label: 'Unit 5',
    pathways: [
      Pathway(
        title: 'Get data from the internet',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-5-pathway-1',
      ),
      Pathway(
        title: 'Load and display images from the internet',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-5-pathway-2',
      ),
    ],
  ),
  Course(
    title: 'Data persistence',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-6',
    label: 'Unit 6',
    pathways: [
      Pathway(
        title: 'Introduction to SQL',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-6-pathway-1',
      ),
      Pathway(
        title: 'Use Room for data persistence',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-6-pathway-2',
      ),
      Pathway(
        title: 'Store and access data using keys with DataStore',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-6-pathway-3',
      ),
    ],
  ),
  Course(
    title: 'WorkManager',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-7',
    label: 'Unit 7',
    pathways: [
      Pathway(
        title: 'Schedule tasks with WorkManager',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-7-pathway-1',
      ),
    ],
  ),
  Course(
    title: 'Compose with Views',
    url: 'https://developer.android.com/courses/android-basics-compose/unit-8',
    label: 'Unit 8',
    pathways: [
      Pathway(
        title: 'Android Views and Compose in Views',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-8-pathway-1',
      ),
      Pathway(
        title: 'Views in Compose',
        url:
            'https://developer.android.com/courses/pathways/android-basics-compose-unit-8-pathway-2',
      ),
    ],
  ),
  Pathway(
    title: 'Compose essentials',
    url:
        'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-1',
  ),
  Pathway(
    title: 'Layouts, theming, and animation',
    url:
        'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-2',
  ),
  Pathway(
    title: 'Architecture and state',
    url:
        'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-3',
  ),
  Pathway(
    title: 'Accessibility, testing, and performance',
    url:
        'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-4',
  ),
  Pathway(
    title: 'Form factors',
    url:
        'https://developer.android.com/courses/pathways/jetpack-compose-for-android-developers-5',
  ),
];
