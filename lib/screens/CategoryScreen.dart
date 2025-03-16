import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_supabase_local_service/screens/SubCategoryScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/Category.dart';

class CategoryScreen extends StatefulWidget {
  final String title;

  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController searchController = TextEditingController();
  final CarouselSliderController  _controller = CarouselSliderController ();

  int _current = 0;
  String searchQuery = '';

  final List<String> imgList = [
    'https://xxllfyzeciydpjwwyeef.supabase.co/storage/v1/object/public/assets/local_service_carousel/appliance.jpg',
    'https://xxllfyzeciydpjwwyeef.supabase.co/storage/v1/object/public/assets/local_service_carousel/bike_mechanic.jpeg',
    'https://xxllfyzeciydpjwwyeef.supabase.co/storage/v1/object/public/assets/local_service_carousel/carpenter.jpeg',
  ];

  List<Widget> get imageSliders => imgList
      .map(
        (item) => ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        item,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 100),
      ),
    ),
  )
      .toList();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void navigateToServiceScreen(Category selectedCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubCategoryScreen(category: selectedCategory),
      ),
    );
  }

  Stream<List<Category>> getCategoryStream() {
    return supabase
        .from('categories')
        .stream(primaryKey: ['id'])
        .order('name')
        .map((data) => data
        .map((category) => Category.fromJson(category))
        .where((category) =>
        category.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Categories',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // 🎠 Carousel Slider
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                // setState(() {
                //   _current = index;
                // });

                _current = index; // Avoid calling setState here
              },
            ),
          ),

          // 🔘 Carousel Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_current == entry.key
                        ? Colors.blueAccent
                        : Colors.grey)
                        .withOpacity(0.9),
                  ),
                ),
              );
            }).toList(),
          ),

          // 📂 Category Grid
          Expanded(
            child: StreamBuilder<List<Category>>(
              stream: getCategoryStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final categories = snapshot.data ?? [];

                if (categories.isEmpty) {
                  return const Center(child: Text('No categories found.'));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await supabase.from('categories').select(); // Manual refresh
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () => navigateToServiceScreen(category),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                category.image_path,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 80),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                category.name,
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
          ),
        ],
      ),
    );
  }
}
