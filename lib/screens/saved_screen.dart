import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';
import 'package:house_renting_mobile/screens/search_results_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1F2937);

  String _getOwnerName(int index) {
    final owners = [
      'Mr. Dara',
      'Ms. Sreynich',
      'Mr. Visal',
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

  String _getSize(int index) {
    final sizes = [
      '65 m²',
      '95 m²',
      '45 m²',
    ];
    return sizes[index % sizes.length];
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
          size: _getSize(index),
          hasWifi: index % 2 == 0,
          hasParking: index % 3 != 0,
          hasSecurity: index % 2 != 0,
          hasAirConditioner: index % 3 != 1,
          description:
          '${property.title} is a comfortable property located in ${property.location}. '
              'It is suitable for students, workers, families, or anyone looking for a safe rental place.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedProperties = sampleProperties.take(3).toList();

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${savedProperties.length} Saved Properties',
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
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _statCard(Icons.home_outlined, '12', 'Viewed'),
              const SizedBox(width: 12),
              _statCard(Icons.bookmark_border, '${savedProperties.length}', 'Saved'),
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

          ...savedProperties.asMap().entries.map((entry) {
            final index = entry.key;
            final property = entry.value;

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
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 70,
                            height: 70,
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
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            property.location,
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
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const Icon(
                          Icons.bookmark,
                          color: primaryColor,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '${property.bedrooms} Beds',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
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