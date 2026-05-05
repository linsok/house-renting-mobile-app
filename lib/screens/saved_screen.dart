import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/widgets/property_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Property> savedProperties = [];

  @override
  void initState() {
    super.initState();
    _loadSavedProperties();
  }

  void _loadSavedProperties() {
    // Get properties that are favorited
    savedProperties = sampleProperties.where((property) => property.isFavorited).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Saved Properties',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),
      body: savedProperties.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved properties',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start saving properties you like',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedProperties.length,
              itemBuilder: (context, index) {
                final property = savedProperties[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: index == savedProperties.length - 1 ? 0 : 12),
                  child: PropertyCard(
                    property: property,
                    height: 120,
                    onTap: () {
                      // Navigate to property details
                    },
                    onFavoriteTap: () {
                      setState(() {
                        savedProperties[index] = property.copyWith(
                          isFavorited: !property.isFavorited,
                        );
                        if (!savedProperties[index].isFavorited) {
                          savedProperties.removeAt(index);
                        }
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
