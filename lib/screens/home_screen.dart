import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/screens/search_results_screen.dart';
import 'package:house_renting_mobile/widgets/property_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onSeeAll;

  const HomeScreen({
    super.key,
    this.onSeeAll,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLocation = 'Toul Kork';
  String selectedCategory = 'House';

  final TextEditingController _searchController = TextEditingController();

  double maxPrice = 5000;
  int minBedrooms = 0;
  int minBathrooms = 0;

  bool furnishedOnly = false;
  bool parkingOnly = false;
  bool poolOnly = false;
  bool acOnly = false;
  bool gymOnly = false;

  final List<String> categories = ['House', 'Apartment', 'Office Space', 'Shop'];

  List<Property> bestForYouProperties = [];
  List<Property> popularProperties = [];

  final List<String> propertyImages = [
    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=1200',
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=1200',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1200',
    'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1200',
    'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=1200',
  ];

  @override
  void initState() {
    super.initState();
    _loadProperties();

    _searchController.addListener(() {
      _applyFilter();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProperties() {
    bestForYouProperties = sampleProperties.take(2).toList();
    popularProperties = sampleProperties.skip(2).take(4).toList();
  }

  void _applyFilter() {
    final keyword = _searchController.text.trim().toLowerCase();

    final filtered = sampleProperties.where((property) {
      final matchSearch = keyword.isEmpty ||
          property.title.toLowerCase().contains(keyword) ||
          property.location.toLowerCase().contains(keyword) ||
          property.address.toLowerCase().contains(keyword) ||
          property.propertyType.toLowerCase().contains(keyword) ||
          property.description.toLowerCase().contains(keyword);

      final matchCategory = selectedCategory == 'All' ||
          property.propertyType.toLowerCase() == selectedCategory.toLowerCase();

      final matchPrice = property.price <= maxPrice;
      final matchBedrooms = property.bedrooms >= minBedrooms;
      final matchBathrooms = property.bathrooms >= minBathrooms;

      final matchFurnished = !furnishedOnly || property.isFurnished;
      final matchParking = !parkingOnly || property.parkingAvailable;
      final matchPool = !poolOnly || property.swimmingPool;
      final matchAc = !acOnly || property.airConditioning;
      final matchGym = !gymOnly || property.gym;

      return matchSearch &&
          matchCategory &&
          matchPrice &&
          matchBedrooms &&
          matchBathrooms &&
          matchFurnished &&
          matchParking &&
          matchPool &&
          matchAc &&
          matchGym;
    }).toList();

    setState(() {
      bestForYouProperties = filtered.take(2).toList();
      popularProperties = filtered.skip(2).take(4).toList();
    });
  }

  void _resetFilter() {
    setState(() {
      selectedCategory = 'House';
      maxPrice = 5000;
      minBedrooms = 0;
      minBathrooms = 0;
      furnishedOnly = false;
      parkingOnly = false;
      poolOnly = false;
      acOnly = false;
      gymOnly = false;
    });

    _applyFilter();
  }

  String _getImageUrl(int index) {
    return propertyImages[index % propertyImages.length];
  }

  String _getOwnerName(int index) {
    final owners = [
      'Mr. Dara',
      'Ms. Sreynich',
      'Mr. Visal',
      'Ms. Sophea',
      'Mr. Rithy',
      'Ms. Kanika',
    ];

    return owners[index % owners.length];
  }

  String _getOwnerPhone(int index) {
    final phones = [
      '+855 12 345 678',
      '+855 15 888 999',
      '+855 96 777 2222',
      '+855 10 555 123',
      '+855 88 456 7890',
      '+855 92 333 444',
    ];

    return phones[index % phones.length];
  }

  String _getSize(int index) {
    final sizes = [
      '65 m²',
      '82 m²',
      '95 m²',
      '120 m²',
      '150 m²',
      '180 m²',
    ];

    return sizes[index % sizes.length];
  }

  bool _hasWifi(int index) {
    return index % 2 == 0;
  }

  bool _hasParking(int index) {
    return index % 3 != 0;
  }

  bool _hasSecurity(int index) {
    return index % 2 != 0;
  }

  bool _hasAirConditioner(int index) {
    return index % 3 != 1;
  }

  String _getDescription(Property property) {
    return '${property.title} is a comfortable and modern property located in ${property.location}. '
        'It is suitable for students, workers, small families, or anyone looking for a clean and safe place to stay. '
        'The property has good access to nearby shops, transportation, restaurants, and daily living services.';
  }

  void _openPropertyDetails(Property property) {
    final int index = sampleProperties.indexWhere((item) => item.id == property.id);
    final int safeIndex = index == -1 ? 0 : index;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsScreen(
          property: property,
          imageUrl: _getImageUrl(safeIndex),
          ownerName: _getOwnerName(safeIndex),
          ownerPhone: _getOwnerPhone(safeIndex),
          size: _getSize(safeIndex),
          hasWifi: _hasWifi(safeIndex),
          hasParking: _hasParking(safeIndex),
          hasSecurity: _hasSecurity(safeIndex),
          hasAirConditioner: _hasAirConditioner(safeIndex),
          description: _getDescription(property),
        ),
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Filter Properties',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: ['All', ...categories].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedCategory = value ?? 'All';
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: maxPrice.toInt().toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max Price',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        final typedPrice = double.tryParse(value);

                        setModalState(() {
                          maxPrice = typedPrice ?? 5000;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: minBedrooms,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Bedrooms',
                        border: OutlineInputBorder(),
                      ),
                      items: [0, 1, 2, 3, 4, 5].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item+'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          minBedrooms = value ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      value: minBathrooms,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Bathrooms',
                        border: OutlineInputBorder(),
                      ),
                      items: [0, 1, 2, 3, 4, 5].map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text('$item+'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() {
                          minBathrooms = value ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: furnishedOnly,
                      title: const Text('Furnished only'),
                      onChanged: (value) {
                        setModalState(() {
                          furnishedOnly = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: parkingOnly,
                      title: const Text('Parking available'),
                      onChanged: (value) {
                        setModalState(() {
                          parkingOnly = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: poolOnly,
                      title: const Text('Swimming pool'),
                      onChanged: (value) {
                        setModalState(() {
                          poolOnly = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: acOnly,
                      title: const Text('Air conditioning'),
                      onChanged: (value) {
                        setModalState(() {
                          acOnly = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      value: gymOnly,
                      title: const Text('Gym'),
                      onChanged: (value) {
                        setModalState(() {
                          gymOnly = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                selectedCategory = 'House';
                                maxPrice = 5000;
                                minBedrooms = 0;
                                minBathrooms = 0;
                                furnishedOnly = false;
                                parkingOnly = false;
                                poolOnly = false;
                                acOnly = false;
                                gymOnly = false;
                              });

                              _resetFilter();
                              Navigator.pop(context);
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilter();
                              Navigator.pop(context);
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Home',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    hintText: 'Search Properties',
                    hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF1E3A8A),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Color(0xFF1E3A8A),
                      ),
                      onPressed: _openFilterSheet,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onSeeAll,
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
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                          _applyFilter();
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1E3A8A),
                        labelStyle: GoogleFonts.inter(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1F2937),
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF1E3A8A)
                              : Colors.grey[300]!,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Best For You',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 235,
                child: bestForYouProperties.isEmpty
                    ? const Center(child: Text('No properties found'))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bestForYouProperties.length,
                  itemBuilder: (context, index) {
                    final property = bestForYouProperties[index];

                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      child: PropertyCard(
                        property: property,
                        height: 235,
                        onTap: () => _openPropertyDetails(property),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Popular Properties',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 235,
                child: popularProperties.isEmpty
                    ? const Center(child: Text('No popular properties found'))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularProperties.length,
                  itemBuilder: (context, index) {
                    final property = popularProperties[index];

                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      child: PropertyCard(
                        property: property,
                        height: 235,
                        onTap: () => _openPropertyDetails(property),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Our Achievements',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatCard('1.2K+', 'Properties'),
                  _buildStatCard('800+', 'Clients'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatCard('350+', 'Rented'),
                  _buildStatCard('4.8★', 'Rating'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
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
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}