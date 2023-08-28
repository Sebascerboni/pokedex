import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_mobile/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

class PokemonFavorite extends StatefulWidget {
  final int id;
  const PokemonFavorite({super.key, required this.id});

  @override
  State<PokemonFavorite> createState() => _PokemonFavoriteState();
}

class _PokemonFavoriteState extends State<PokemonFavorite> {
  late Stream<DocumentSnapshot> _documentStream;

  @override
  void initState() {
    var db = FirebaseFirestore.instance;
    _documentStream =
        db.collection('pokemons').doc(widget.id.toString()).snapshots();
    super.initState();
  }

  _markFavoriteStatus(int id, bool value) {
    Provider.of<PokemonProvider>(context, listen: false)
        .updatePokemonFavoriteStatus(id, value);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _documentStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            var data = snapshot.data;
            bool flagFavorite = false;
            try {
              if (data?["isFavorite"] == true) {
                flagFavorite = true;
              }
            } on StateError {
              print('state error');
            }
            return Placeholder();
          }
        });
  }
}
