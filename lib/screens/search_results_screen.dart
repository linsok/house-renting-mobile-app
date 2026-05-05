import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/widgets/property_card.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String selectedLocation = 'Birmingham';
  final TextEditingController _searchController = TextEditingController();
  List<Property> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = 'House';
    _performSearch();
  }

  void _performSearch() {
    setState(() {
      isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // Filter properties based on search criteria
        searchResults = sampleProperties.where((property) {
          return property.location.toLowerCase().contains(selectedLocation.toLowerCase()) &&
                 property.title.toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();
        isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: const Color(0xFF1E3A8A),
              size: 20,
            ),
            const SizedBox(width: 4),
            DropdownButton<String>(
              value: selectedLocation,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF1E3A8A),
              ),
              items: ['Birmingham', 'Phnom Penh', 'Sen Sok', 'BKK'].map((location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(
                    location,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value!;
                });
                _performSearch();
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF1E3A8A),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) => _performSearch(),
                decoration: InputDecoration(
                  hintText: 'Search Properties',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[500],
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF1E3A8A),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: Color(0xFF1E3A8A),
                    ),
                    onPressed: () {
                      // Show filter options
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Results Count and See All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${searchResults.length} Properties found',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Search Results
          Flexible(
            flex: 2,
            child: isSearching
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No properties found',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your search criteria',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final property = searchResults[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: index == searchResults.length - 1 ? 16 : 12),
                            child: PropertyCard(
                              property: property,
                              height: 250,
                              onTap: () {
                                // Navigate to property details
                              },
                              onFavoriteTap: () {
                                setState(() {
                                  searchResults[index] = property.copyWith(
                                    isFavorited: !property.isFavorited,
                                  );
                                });
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
