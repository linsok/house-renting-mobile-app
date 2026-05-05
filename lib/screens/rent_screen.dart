import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/widgets/property_card.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  String selectedLocation = 'Toul Kork';
  String selectedCategory = 'House';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = ['House', 'Apartment', 'Office Space', 'Shop'];

  List<Property> rentProperties = [];
  List<Property> featuredProperties = [];

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  void _loadProperties() {
    rentProperties = sampleProperties.take(3).toList();
    featuredProperties = sampleProperties.skip(3).take(5).toList();
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
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF1E3A8A),
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
              items: ['Toul Kork', 'Phnom Penh', 'Sen Sok', 'BKK'].map((location) {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
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
                  decoration: InputDecoration(
                    hintText: 'Search Properties to Rent',
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
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Property Type',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

              const SizedBox(height: 12),

              // Category Pills
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedCategory;

                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == categories.length - 1 ? 0 : 12,
                      ),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1E3A8A),
                        labelStyle: GoogleFonts.inter(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1F2937),
                          fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.grey[300]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Available for Rent Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available for Rent',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

              const SizedBox(height: 12),

              // Horizontal Property Cards for Available for Rent
              SizedBox(
                height: 235,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: rentProperties.length,
                  itemBuilder: (context, index) {
                    final property = rentProperties[index];
                    return Container(
                      width: 280,
                      margin: EdgeInsets.only(
                        right:
                        index == rentProperties.length - 1 ? 0 : 12,
                      ),
                      child: PropertyCard(
                        property: property,
                        height: 235,
                        onTap: () {
                          // Navigate to property details
                        },
                        onFavoriteTap: () {
                          setState(() {
                            rentProperties[index] = property.copyWith(
                              isFavorited: !property.isFavorited,
                            );
                          });
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Featured Properties Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Properties',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

              const SizedBox(height: 12),

              // Vertical Property Cards for Featured Properties
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featuredProperties.length,
                itemBuilder: (context, index) {
                  final property = featuredProperties[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == featuredProperties.length - 1 ? 0 : 12,
                    ),
                    child: PropertyCard(
                      property: property,
                      height: 250,
                      onTap: () {
                        // Navigate to property details
                      },
                      onFavoriteTap: () {
                        setState(() {
                          featuredProperties[index] = property.copyWith(
                            isFavorited: !property.isFavorited,
                          );
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
