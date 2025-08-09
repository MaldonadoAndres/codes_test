part of 'animals_bloc.dart';

abstract class AnimalsEvent extends Equatable {
  const AnimalsEvent();

  @override
  List<Object> get props => [];
}

class FetchAnimals extends AnimalsEvent {
  const FetchAnimals();

  @override
  List<Object> get props => [];
}

class ToggleFavorite extends AnimalsEvent {
  final AnimalsModel animal;

  const ToggleFavorite(this.animal);

  @override
  List<Object> get props => [animal];
}

class FilterAnimals extends AnimalsEvent {
  final String query;

  const FilterAnimals(this.query);

  @override
  List<Object> get props => [query];
}
