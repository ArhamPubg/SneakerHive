import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static const String prefKeyPrefix = 'favorite_status_';

  static Future<bool> getFavoriteStatus(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefKeyPrefix + productId) ?? false;
  }

  static Future<void> setFavoriteStatus(String productId, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefKeyPrefix + productId, isFavorite);
  }
}
