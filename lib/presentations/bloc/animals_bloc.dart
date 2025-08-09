import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:favorite_animal/models/animals_model.dart';
import 'package:favorite_animal/services/animal_services.dart';

part 'animals_event.dart';
part 'animals_state.dart';

class AnimalsBloc extends Bloc<AnimalsEvent, AnimalsState> {
  final AnimalServices animalServices;
  AnimalsBloc(this.animalServices) : super(AnimalsInitial()) {
    on<FetchAnimals>(_onAnimalsFetched);
    on<ToggleFavorite>(_onToggleFavorite);
    on<FilterAnimals>(_filterAnimals);
  }
  final List<AnimalsModel> _animals = [];

  void _onAnimalsFetched(FetchAnimals event, Emitter<AnimalsState> emit) async {
    emit(AnimalsLoading());
    try {
      _animals.addAll(await animalServices.fetchAnimals());
      emit(AnimalsLoaded(_animals));
    } catch (e) {
      emit(AnimalsError('Failed to fetch animals: $e'));
    }
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<AnimalsState> emit) {
    if (state is AnimalsLoaded) {
      final currentState = state as AnimalsLoaded;
      final updatedAnimals = currentState.animals.map((animal) {
        if (animal.id == event.animal.id) {
          return animal.copyWith(isFavorite: !animal.isFavorite, favoriteAt: animal.isFavorite ? null : DateTime.now());
        }
        return animal;
      }).toList();
      emit(AnimalsLoaded(updatedAnimals));
    }
  }

  void _filterAnimals(FilterAnimals event, Emitter<AnimalsState> emit) {
    if (state is AnimalsLoaded) {
      final filteredAnimals = _animals.where((animal) {
        return animal.title.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(AnimalsLoaded(filteredAnimals));
    }
  }
}
