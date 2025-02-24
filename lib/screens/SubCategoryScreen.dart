import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Category.dart';
import '../models/SubCategory.dart';

class SubCategoryScreen extends StatefulWidget {
  final Category category;

  const SubCategoryScreen({super.key, required this.category});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Stream<List<SubCategory>> getSubCategoriesStream() {

    // print(widget.category.id);
    return supabase
        .from('sub_categories')
        .stream(primaryKey: ['id'])
        .eq('category_id', widget.category.id)
        .order('name', ascending: true)
        // .map((data) => data.map((json) => SubCategory.fromJson(json)).toList());
        .map((data) {
          print("Fetched Data: $data"); // 🔥 Print raw data
          return data.map((json) => SubCategory.fromJson(json)).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: StreamBuilder<List<SubCategory>>(
        stream: getSubCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final subcategories = snapshot.data ?? [];

          if (subcategories.isEmpty) {
            return const Center(child: Text('No subcategories found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              await supabase.from('sub_categories').select().eq('category_id', widget.category.id);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                return GestureDetector(
                  onTap: () {
                    // Handle subcategory tap if needed
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          subcategory.image_path,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 80),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          subcategory.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
