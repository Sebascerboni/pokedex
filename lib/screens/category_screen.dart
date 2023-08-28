import 'package:flutter/material.dart';
import 'package:pokedex_mobile/providers/category_provider.dart';
import 'package:pokedex_mobile/widgets/category_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String lastUpdate = 'N/A';

  void updateLastSyncDate(String lastSync) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString("last_sync", lastSync);
  }

  Future<String?> getLastSyncDate() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString("last_sync");
  }

  int? getStringLength(String? str) {
    return str?.length;
  }

  @override
  void initState() {
    getLastSyncDate().then((value) => {
          setState(() {
            lastUpdate = value ?? 'N/A';
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<CategoryProvider>(context, listen: false)
                  .initializeCategories();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Provider.of<CategoryProvider>(context, listen: false).clearList();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
        title: const Text("Tipos de Pokemon"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              height: 40,
              child: Card(
                elevation: 10,
                child: Text("Ultima Sicronizacion: $lastUpdate"),
              ),
            ),
          ),
          const Expanded(
            child: CategoryListWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<CategoryProvider>(context, listen: false)
              .addCategory('Fire');
          setState(() {
            lastUpdate = DateTime.now().toIso8601String();
            updateLastSyncDate(lastUpdate);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
