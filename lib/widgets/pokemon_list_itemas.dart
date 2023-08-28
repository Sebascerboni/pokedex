import 'package:flutter/material.dart';
import 'package:pokedex_mobile/dtos/pokemon_model.dart';
import 'package:pokedex_mobile/providers/pokemon_provider.dart';
import 'package:pokedex_mobile/widgets/pokemon_list.dart';
import 'package:provider/provider.dart';

import '../screens/pokemon_detail.dart';
import '../screens/pokemon_favorite.dart';

class PokemonListItems extends StatefulWidget {
  final List<Pokemon> pokemons;
  const PokemonListItems({super.key, required this.pokemons});

  @override
  State<PokemonListItems> createState() => _PokemonListItemsState();
}

class _PokemonListItemsState extends State<PokemonListItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(3.0),
              child: GestureDetector(
                onTap: () => {
                  Navigator.pushNamed(context, PokemonDetailsScreen.routeName,
                      arguments: widget.pokemons[index].id)
                },
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Hero(
                        tag: widget.pokemons[index].id,
                        child: Image.network(widget.pokemons[index].imageUrl)),
                    title: Text(widget.pokemons[index].name),
                    trailing: PokemonFavorite(id: widget.pokemons[index].id),
                  ),
                ),
              ));
        },
        itemCount: widget.pokemons.length);
  }
}

class _PokemonListState extends State<PokemonList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PokemonProvider>(builder: (context, provider, child) {
      return PokemonListItems(pokemons: provider.pokemons);
    });
  }
}
