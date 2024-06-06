part of 'shared.dart';

class Const with ChangeNotifier {
  static String baseUrl = 'http://10.1.65.59:8080/api/v1';
  static ThemeMode themeMode = ThemeMode.system;
  static String auth = '';
  static int userId = 0;

  static late final SharedPreferences sharedPrefs;
  static late final JsonCacheMem jsonCache;

  // Singleton pattern for ChangeNotifier
  static final Const instance = Const._internal();

  factory Const() {
    return instance;
  }

  Const._internal();

  // Cache initialization
  static void initializeCache() async {
    sharedPrefs = await SharedPreferences.getInstance();
    jsonCache = JsonCacheMem(JsonCacheSharedPreferences(sharedPrefs));
    _refreshCache();
  }

  // Saving preferences data
  static Future<void> signIn(int id, String token) async {
    await jsonCache.refresh('profile', {'userId': id, 'auth': token});
    await jsonCache.refresh('setting', {'themeMode': 'system'});
    _refreshCache();
  }

  // Saving theme mode
  static Future<void> changeTheme(ThemeMode theme) async {
    await jsonCache.refresh('setting', {'themeMode': theme.toString()});
    themeMode = theme;
    instance.notifyListeners();
  }

  // Frees up cached data before the user leaves the application.
  static Future<void> signout() async {
    await jsonCache.clear();
    _refreshCache();
  }

  // Refreshing cache
  static void _refreshCache() async {
    final profileMap = await jsonCache.value('profile');
    final settingMap = await jsonCache.value('setting');

    if (profileMap != null && settingMap != null) {
      userId = profileMap['userId'];
      auth = profileMap['auth'];

      String themeStr = settingMap['themeMode'];
      if (themeStr == 'ThemeMode.light') {
        themeMode = ThemeMode.light;
      } else if (themeStr == 'ThemeMode.dark') {
        themeMode = ThemeMode.dark;
      } else {
        themeMode = ThemeMode.system;
      }

      instance.notifyListeners();
    } else {
      themeMode = ThemeMode.system;
      userId = 0;
      auth = '';
    }
  }
}
