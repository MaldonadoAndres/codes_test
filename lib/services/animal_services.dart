import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:favorite_animal/models/animals_model.dart';
import 'package:favorite_animal/utils/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalServices {
  final Dio _dio = createDio();

  AnimalServices();

  Future<List<AnimalsModel>> fetchAnimals() async {
    try {
      final response = await _dio.get('/animals');
      final List<AnimalsModel> apiAnimals = (response.data as List)
          .map((animal) => AnimalsModel.fromJson(animal))
          .toList();

      final favoriteAnimals = await getFavoriteAnimals();

      // Merge favorites first (so they win) then API animals, removing duplicates by id
      final merged = <AnimalsModel>[];
      final seenIds = <dynamic>{};
      for (final animal in [...favoriteAnimals, ...apiAnimals]) {
        final id = (animal.id);
        if (seenIds.add(id)) {
          merged.add(animal);
        }
      }
      return merged;
    } catch (e) {
      throw Exception('Failed to load animals: $e');
    }
  }

  Future<void> saveToSharedPreferences(AnimalsModel animal) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('favorite_animals') ?? [];
    final favorites = rawList.map((e) => Map<String, dynamic>.from(jsonDecode(e) as Map)).toList();

    if (!favorites.any((m) => m['id'] == animal.id)) {
      favorites.add(animal.toJson());
      await prefs.setStringList('favorite_animals', favorites.map((m) => jsonEncode(m)).toList());
    }
  }

  Future<void> removeFromSharedPreferences(AnimalsModel animal) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('favorite_animals') ?? [];
    if (rawList.isEmpty) return;

    final favorites = rawList.map((e) => Map<String, dynamic>.from(jsonDecode(e) as Map)).toList();

    final originalLength = favorites.length;
    favorites.removeWhere((m) => m['id'] == animal.id);

    if (favorites.length != originalLength) {
      await prefs.setStringList('favorite_animals', favorites.map((m) => jsonEncode(m)).toList());
    }
  }

  Future<List<AnimalsModel>> getFavoriteAnimals() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('favorite_animals') ?? [];
    if (rawList.isEmpty) return [];
    final favorites = <AnimalsModel>[];
    for (final item in rawList) {
      try {
        final map = jsonDecode(item);
        if (map is Map<String, dynamic>) {
          favorites.add(AnimalsModel.fromSharedPreferences(map));
        }
      } catch (_) {
        continue;
      }
    }
    return favorites;
  }
}
