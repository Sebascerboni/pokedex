import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_mobile/widgets/pokemon_list_items.dart';

import '../dtos/pokemon_model.dart';

class PokemonFavoriteListScreen extends StatefulWidget {
  const PokemonFavoriteListScreen({super.key});

  @override
  State<PokemonFavoriteListScreen> createState() =>
      _PokemonFavoriteListScreenState();
}

class _PokemonFavoriteListScreenState extends State<PokemonFavoriteListScreen> {
  late Stream<QuerySnapshot> _queryStream;

  @override
  void initState() {
    var db = FirebaseFirestore.instance;
    _queryStream = db
        .collection('pokemons')
        .where('isFavorite', isEqualTo: true)
        .withConverter<Pokemon>(
            fromFirestore: (snapshot, _) =>
                Pokemon.fromFirebaseJson(snapshot.data()!),
            toFirestore: (model, _) => model.toJson())
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons Favoritos'),
      ),
      body: StreamBuilder(
          stream: _queryStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            List<Pokemon> pokemons =
                snapshot.data!.docs.map((e) => e.data() as Pokemon).toList();
            return PokemonListItems(pokemons: pokemons);
          }),
    );
  }
}
