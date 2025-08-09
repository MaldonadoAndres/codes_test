part of 'animals_bloc.dart';

abstract class AnimalsState extends Equatable {
  const AnimalsState();

  @override
  List<Object> get props => [];
}

class AnimalsInitial extends AnimalsState {}

class AnimalsLoading extends AnimalsState {}

class AnimalsLoaded extends AnimalsState {
  final List<AnimalsModel> animals;

  const AnimalsLoaded(this.animals);

  @override
  List<Object> get props => [animals];
}

class AnimalsError extends AnimalsState {
  final String message;

  const AnimalsError(this.message);

  @override
  List<Object> get props => [message];
}
