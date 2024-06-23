import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static Future<void> setFavoriteStatus(
      String productId, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(productId, isFavorite);
  }

  static Future<bool> getFavoriteStatus(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(productId) ?? false;
  }
}

// class StarsManager {
//   static Future<void> setStarsStatus(String productId, double stars) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble(productId, stars);
//   }

//   static Future<double?> getStarsStatus(String productId) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getDouble(productId);
//   }
// }
