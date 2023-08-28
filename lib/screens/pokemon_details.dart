import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_mobile/providers/pokemon_provider.dart';
import 'package:pokedex_mobile/widgets/input_comment.dart';
import 'package:pokedex_mobile/widgets/pokemon_favorite.dart';
import 'package:provider/provider.dart';

import '../dtos/pokemon_model.dart';

class PokemonDetailsScreen extends StatefulWidget {
  static const routeName = '/pokemon-details';

  const PokemonDetailsScreen({super.key});

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  Widget _getPokemonNameWidget(Pokemon pokemonData) {
    return Expanded(
      child: Text(
        pokemonData.name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.blue,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;

    var pokemonData = Provider.of<PokemonProvider>(
      context,
      listen: false,
    ).getPokemon(id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: pokemonData.id,
              child: SizedBox(
                height: 300,
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    pokemonData.imageUrl,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _getPokemonNameWidget(pokemonData),
                  PokemonFavorite(id: pokemonData.id)
                ],
              ),
            ),
            InputComment(id: pokemonData.id)
          ],
        ),
      ),
    );
  }
}
