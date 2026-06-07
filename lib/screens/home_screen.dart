import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/screens/search_results_screen.dart';
import 'package:house_renting_mobile/widgets/property_card.dart';

import '../services/saved_property_service.dart';

import '../services/property_service.dart';

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
  String selectedCategory = 'All';

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;

  List<Property> allProperties = [];
  List<Property> bestForYouProperties = [];
  List<Property> popularProperties = [];

  double maxPrice = 5000;
  int minBedrooms = 0;
  int minBathrooms = 0;

  bool furnishedOnly = false;
  bool parkingOnly = false;
  bool poolOnly = false;
  bool acOnly = false;
  bool gymOnly = false;

  final List<String> categories = [
    'All',
    'House',
    'Apartment',
    'Condo',
    'Office Space',
    'Shop',
    'Studio',
  ];

  final List<String> fallbackImages = [
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

  Future<void> _saveProperty(Property property) async {
    try {
      await SavedPropertyService.saveProperty(property.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${property.title} saved successfully.'),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _loadProperties() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await PropertyService.getProperties();

      if (!mounted) return;

      setState(() {
        allProperties = data;
        isLoading = false;
      });

      _applyFilter();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _applyFilter() {
    final keyword = _searchController.text.trim().toLowerCase();

    final filtered = allProperties.where((property) {
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

    if (!mounted) return;

    setState(() {
      bestForYouProperties = filtered.take(2).toList();
      popularProperties = filtered.skip(2).take(6).toList();
    });
  }

  void _resetFilter() {
    setState(() {
      selectedCategory = 'All';
      maxPrice = 5000;
      minBedrooms = 0;
      minBathrooms = 0;
      furnishedOnly = false;
      parkingOnly = false;
      poolOnly = false;
      acOnly = false;
      gymOnly = false;
      _searchController.clear();
    });

    _applyFilter();
  }

  String _getImageUrl(Property property, int index) {
    if (property.imageUrl.trim().isNotEmpty &&
        !property.imageUrl.contains('via.placeholder.com')) {
      return property.imageUrl;
    }

    return fallbackImages[index % fallbackImages.length];
  }

  String _getOwnerName(int index) {
    final owners = [
      'Admin Team',
      'Property Manager',
      'House Renting Support',
      'Rental Owner',
      'Listing Manager',
      'Customer Support',
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

  String _getSize(Property property, int index) {
    if (property.area > 0) {
      return '${property.area.toStringAsFixed(0)} m²';
    }

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

  bool _hasParking(Property property, int index) {
    return property.parkingAvailable || index % 3 != 0;
  }

  bool _hasSecurity(int index) {
    return index % 2 != 0;
  }

  bool _hasAirConditioner(Property property, int index) {
    return property.airConditioning || index % 3 != 1;
  }

  String _getDescription(Property property) {
    if (property.description.trim().isNotEmpty) {
      return property.description;
    }

    return '${property.title} is a comfortable and modern property located in ${property.location}. '
        'It is suitable for students, workers, small families, or anyone looking for a clean and safe place to stay. '
        'The property has good access to nearby shops, transportation, restaurants, and daily living services.';
  }

  void _openPropertyDetails(Property property) {
    final int index = allProperties.indexWhere((item) => item.id == property.id);
    final int safeIndex = index == -1 ? 0 : index;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsScreen(
          property: property,
          imageUrl: _getImageUrl(property, safeIndex),
          ownerName: _getOwnerName(safeIndex),
          ownerPhone: _getOwnerPhone(safeIndex),
          size: _getSize(property, safeIndex),
          hasWifi: _hasWifi(safeIndex),
          hasParking: _hasParking(property, safeIndex),
          hasSecurity: _hasSecurity(safeIndex),
          hasAirConditioner: _hasAirConditioner(property, safeIndex),
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
                      items: categories.map((item) {
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
                                selectedCategory = 'All';
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              foregroundColor: Colors.white,
                            ),
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

  Widget _buildLoadingBody() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProperties,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeBody() {
    return RefreshIndicator(
      onRefresh: _loadProperties,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBox(),

              const SizedBox(height: 24),

              _sectionHeader(
                title: 'Category',
                showSeeAll: true,
              ),

              const SizedBox(height: 12),

              _categoryChips(),

              const SizedBox(height: 24),

              _sectionHeader(title: 'Best For You'),

              const SizedBox(height: 12),

              _propertyHorizontalList(
                properties: bestForYouProperties,
                emptyText: 'No properties found',
              ),

              const SizedBox(height: 24),

              _sectionHeader(title: 'Popular Properties'),

              const SizedBox(height: 12),

              _propertyHorizontalList(
                properties: popularProperties,
                emptyText: 'No popular properties found',
              ),

              const SizedBox(height: 24),

              _sectionHeader(title: 'Our Achievements'),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatCard('${allProperties.length}+', 'Properties'),
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

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
    );
  }

  Widget _sectionHeader({
    required String title,
    bool showSeeAll = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        if (showSeeAll)
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
    );
  }

  Widget _categoryChips() {
    return SizedBox(
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
                color: isSelected ? Colors.white : const Color(0xFF1F2937),
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
    );
  }

  Widget _propertyHorizontalList({
    required List<Property> properties,
    required String emptyText,
  }) {
    return SizedBox(
      height: 235,
      child: properties.isEmpty
          ? Center(
        child: Text(
          emptyText,
          style: GoogleFonts.inter(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];

          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            child: PropertyCard(
              property: property,
              height: 235,
              onTap: () => _openPropertyDetails(property),
              onFavoriteTap: () => _saveProperty(property),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (isLoading) {
      body = _buildLoadingBody();
    } else if (errorMessage != null) {
      body = _buildErrorBody();
    } else {
      body = _buildHomeBody();
    }

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
      body: body,
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
              color: Colors.black.withValues(alpha: 0.05),
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