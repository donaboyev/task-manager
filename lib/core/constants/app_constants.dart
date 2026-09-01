class AppConstants {
  static const databaseVersion = 2;
  static const String version = String.fromEnvironment('VERSION');
  static const Version running =
      version == 'lazy' ? Version.lazy : Version.wait;
  static const String tagSortByName = 'Sort by name';
  static const String tagSortByDate = 'Sort by date created';
  static const String tagHideCompleted = 'hideCompleted';
  static const String tagDeleteAllCompleted = 'deleteAllCompleted';
}

enum Version { lazy, wait }

enum SortOrder { byName, byDate }

extension SortOrderExtension on SortOrder {
  String get value => name;
}
