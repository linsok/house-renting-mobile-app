import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/screens/search_results_screen.dart';

import '../services/saved_property_service.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1F2937);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<SavedPropertyItem> savedItems = [];

  bool isLoading = true;
  String? errorMessage;

  static const Color primaryColor = SavedScreen.primaryColor;
  static const Color darkText = SavedScreen.darkText;

  @override
  void initState() {
    super.initState();
    _loadSavedProperties();
  }

  Future<void> _loadSavedProperties() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await SavedPropertyService.getSavedProperties();

      if (!mounted) return;

      setState(() {
        savedItems = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String _getOwnerName(int index) {
    final owners = [
      'Admin Team',
      'Property Manager',
      'House Renting Support',
    ];

    return owners[index % owners.length];
  }

  String _getOwnerPhone(int index) {
    final phones = [
      '+855 12 345 678',
      '+855 15 888 999',
      '+855 96 777 2222',
    ];

    return phones[index % phones.length];
  }

  String _getSize(Property property, int index) {
    if (property.area > 0) {
      return '${property.area.toStringAsFixed(0)} m²';
    }

    final sizes = [
      '65 m²',
      '95 m²',
      '45 m²',
    ];

    return sizes[index % sizes.length];
  }

  String _getDescription(Property property) {
    if (property.description.trim().isNotEmpty) {
      return property.description;
    }

    return '${property.title} is a comfortable property located in ${property.location}. '
        'It is suitable for students, workers, families, or anyone looking for a safe rental place.';
  }

  void _openPropertyDetails(BuildContext context, Property property, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsScreen(
          property: property,
          imageUrl: property.imageUrl,
          ownerName: _getOwnerName(index),
          ownerPhone: _getOwnerPhone(index),
          size: _getSize(property, index),
          hasWifi: index % 2 == 0,
          hasParking: property.parkingAvailable || index % 3 != 0,
          hasSecurity: index % 2 != 0,
          hasAirConditioner: property.airConditioning || index % 3 != 1,
          description: _getDescription(property),
        ),
      ),
    );
  }

  Future<void> _removeSavedProperty(SavedPropertyItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Remove Saved Property',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Do you want to remove "${item.property.title}" from saved properties?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Remove',
                style: GoogleFonts.inter(),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await SavedPropertyService.removeSavedProperty(item.savedId);

      if (!mounted) return;

      setState(() {
        savedItems.removeWhere((saved) => saved.savedId == item.savedId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved property removed.'),
          backgroundColor: primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              onPressed: _loadSavedProperties,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 58,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No saved properties yet',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Saved properties will appear here after you bookmark them.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBody() {
    return RefreshIndicator(
      onRefresh: _loadSavedProperties,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _headerCard(),

          const SizedBox(height: 16),

          Row(
            children: [
              _statCard(
                Icons.home_outlined,
                '${savedItems.length}',
                'Saved',
              ),
              const SizedBox(width: 12),
              _statCard(
                Icons.bookmark_border,
                '${savedItems.length}',
                'Favorites',
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            'Saved Properties',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),

          const SizedBox(height: 12),

          if (savedItems.isEmpty)
            _buildEmptyState()
          else
            ...savedItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final property = item.property;

              return _savedPropertyCard(
                item: item,
                property: property,
                index: index,
              );
            }),
        ],
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.bookmark,
              color: primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${savedItems.length} Saved Properties',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Your favorite rental homes',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _savedPropertyCard({
    required SavedPropertyItem item,
    required Property property,
    required int index,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openPropertyDetails(context, property, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                property.imageUrl,
                width: 74,
                height: 74,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      color: primaryColor,
                      size: 34,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${property.price.toStringAsFixed(0)}/month',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.bedrooms} Beds • ${property.bathrooms} Baths',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () => _removeSavedProperty(item),
              icon: const Icon(
                Icons.bookmark_remove,
                color: primaryColor,
              ),
              tooltip: 'Remove',
            ),
          ],
        ),
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
      body = _buildMainBody();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Saved',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ),
      body: body,
    );
  }

  Widget _statCard(IconData icon, String number, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}