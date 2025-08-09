import 'package:dio/dio.dart';
import 'package:favorite_animal/models/animals_model.dart';
import 'package:favorite_animal/utils/dio_client.dart';

class AnimalServices {
  final Dio _dio = createDio();

  AnimalServices();

  Future<List<AnimalsModel>> fetchAnimals() async {
    try {
      final response = await _dio.get('/animals');
      final List<AnimalsModel> animals = (response.data as List)
          .map((animal) => AnimalsModel.fromJson(animal))
          .toList();
      final seenTitles = <String>{};
      animals.retainWhere((animal) => seenTitles.add(animal.title));
      return animals;
    } catch (e) {
      throw Exception('Failed to load animals: $e');
    }
  }
}
