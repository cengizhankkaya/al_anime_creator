import 'package:al_anime_creator/core/widgets/bottom_navigator_bar_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'FeedRoute')
class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['Anime', 'Manhwa', 'Manhua', 'Manga'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildAppBar(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCategoryTabs(),
                const SizedBox(height: 20),
                _buildStoryCarousel(),
                const SizedBox(height: 30),
                _buildPopularSection(),
                 const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  // Üst Kısım: Logo ve Ekle Butonu
  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.greenAccent.shade400, size: 28),
            const SizedBox(width: 8),
            const Text(
              'AIMAG',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.black, size: 28),
        ),
      ],
    );
  }

  // Arama Çubuğu
  Widget _buildSearchBar() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Astronaut with tank with light background',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        suffixIcon: Icon(Icons.search, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFF1E1531),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.greenAccent.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.greenAccent.shade400, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }

  // Kategori Sekmeleri (Anime, Manhwa vb.)
  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _selectedCategoryIndex == index
                    ? const Color(0xFFF44336) // Seçili renk
                    : const Color(0xFF1E1531), // Seçili olmayan renk
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _categories[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Yatay Kaydırılabilir Hikaye Kartları
  Widget _buildStoryCarousel() {
    // Örnek veri
    final List<Map<String, String>> stories = [
      {'image': 'assets/images/bleach.jpg', 'title': 'BLEACH', 'tags': 'Action, Adventure, Fantasy'},
      {'image': 'assets/images/chainsaw.jpg', 'title': 'CHAINSAW MAN', 'tags': 'Action, Comedy, Horror, Dark fantasy'},
      {'image': 'assets/images/aot.jpg', 'title': 'ATTACK ON TITAN', 'tags': 'Action, Dark fantasy, Post-apocalyptic'},
    ];

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          bool isCenter = index == 1; // Ortadaki kartı daha belirgin yapmak için
          return Transform.scale(
            scale: isCenter ? 1.0 : 0.9,
            child: _buildStoryCard(
              imagePath: stories[index]['image']!,
              title: stories[index]['title']!,
              tags: stories[index]['tags']!,
            ),
          );
        },
      ),
    );
  }

  // Tek bir hikaye kartı
  Widget _buildStoryCard({required String imagePath, required String title, required String tags}) {
    return Container(
      width: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1531),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Resim
            Image.asset(imagePath, fit: BoxFit.cover),
            // Alttan üste doğru gradient (yazının okunabilirliği için)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            // Yazılar
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tags,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  // Popüler Bölümü
  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage('assets/images/aot_popular.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Attack on titan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


}