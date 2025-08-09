import 'package:favorite_animal/presentations/bloc/animals_bloc.dart';
import 'package:favorite_animal/services/animal_services.dart';
import 'package:favorite_animal/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');
    return BlocProvider(
      create: (context) => AnimalsBloc(AnimalServices())..add(const FetchAnimals()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Animals'),
          actions: [
            Builder(
              builder: (context) {
                final favoriteCount = context.select((AnimalsBloc bloc) {
                  if (bloc.state is AnimalsLoaded) {
                    final animals = (bloc.state as AnimalsLoaded).animals;
                    return animals.where((animal) => animal.isFavorite).length;
                  }
                  return 0;
                });

                return IconButton(
                  icon: Badge.count(
                    count: favoriteCount,
                    isLabelVisible: favoriteCount > 0,
                    child: const Icon(Icons.favorite, color: Colors.red),
                  ),
                  onPressed: () {},
                );
              },
            ),
          ],
        ),
        body: Column(
          spacing: 12,
          children: [
            Builder(
              builder: (context) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: SearchBar(
                    hintText: 'Search animals...',
                    onChanged: (value) {
                      context.read<AnimalsBloc>().add(FilterAnimals(value));
                    },
                  ),
                );
              },
            ),

            BlocBuilder<AnimalsBloc, AnimalsState>(
              builder: (context, state) => switch (state) {
                AnimalsLoading() => const Center(child: CircularProgressIndicator()),
                AnimalsLoaded(:final animals) when animals.isEmpty => const Center(child: Text('No animals found.')),
                AnimalsLoaded(:final animals) => Expanded(
                  child: ListView.builder(
                    itemCount: animals.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final animal = animals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text(
                            '${animal.title.capitalize()} (ID:${animal.id})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: animal.favoriteAt != null
                              ? Text('Favorited at: ${dateFormatter.format(animal.favoriteAt!.toLocal())}')
                              : null,

                          trailing: IconButton(
                            tooltip: 'Favorite',
                            icon: Icon(
                              (animal.isFavorite) ? Icons.favorite : Icons.favorite_border,
                              color: (animal.isFavorite) ? Colors.red : Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              context.read<AnimalsBloc>().add(ToggleFavorite(animal));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AnimalsError(:final message) => Center(child: Text(message)),
                _ => const Center(child: Text('Welcome to Favorite Animals!')),
              },
            ),
          ],
        ),
      ),
    );
  }
}
