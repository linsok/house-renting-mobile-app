import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/models/property.dart';

import '../services/property_service.dart';
import '../services/request_service.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Property> allProperties = [];
  List<Property> searchResults = [];

  bool isLoading = true;
  bool isSearching = false;
  String? errorMessage;

  final List<String> propertyImages = [
    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=1200',
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=1200',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=1200',
    'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=1200',
    'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=1200',
    'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=1200',
    'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200',
    'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=1200',
    'https://images.unsplash.com/photo-1598228723793-52759bba239c?w=1200',
    'https://images.unsplash.com/photo-1600585154084-4e5fe7c39198?w=1200',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
    _loadProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        searchResults = data;
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

  void _performSearch() {
    setState(() {
      isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      final searchText = _searchController.text.trim().toLowerCase();

      final filtered = allProperties.where((property) {
        return searchText.isEmpty ||
            property.title.toLowerCase().contains(searchText) ||
            property.location.toLowerCase().contains(searchText) ||
            property.address.toLowerCase().contains(searchText) ||
            property.propertyType.toLowerCase().contains(searchText) ||
            property.description.toLowerCase().contains(searchText);
      }).toList();

      setState(() {
        searchResults = filtered;
        isSearching = false;
      });
    });
  }

  String _getImageUrl(Property property, int index) {
    if (property.imageUrl.trim().isNotEmpty &&
        !property.imageUrl.contains('via.placeholder.com')) {
      return property.imageUrl;
    }

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
    if (property.description.trim().isNotEmpty) {
      return property.description;
    }

    return '${property.title} is a comfortable and modern property located in ${property.location}. '
        'It is suitable for students, workers, small families, or anyone looking for a clean and safe place to stay. '
        'The property has good access to nearby shops, transportation, restaurants, and daily living services.';
  }

  void _openPropertyDetails(Property property, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailsScreen(
          property: property,
          imageUrl: _getImageUrl(property, index),
          ownerName: _getOwnerName(index),
          ownerPhone: _getOwnerPhone(index),
          size: _getSize(property, index),
          hasWifi: _hasWifi(index),
          hasParking: _hasParking(index),
          hasSecurity: _hasSecurity(index),
          hasAirConditioner: _hasAirConditioner(index),
          description: _getDescription(property),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E3A8A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openBookForm(Property property, int index) {
    _openFloatingForm(
      property: property,
      type: 'Book',
      ownerName: _getOwnerName(index),
      ownerPhone: _getOwnerPhone(index),
    );
  }

  void _openRentForm(Property property, int index) {
    _openFloatingForm(
      property: property,
      type: 'Rent',
      ownerName: _getOwnerName(index),
      ownerPhone: _getOwnerPhone(index),
    );
  }

  void _showFormError({
    required BuildContext dialogContext,
    required String title,
    required String message,
  }) {
    showDialog(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1E3A8A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openFloatingForm({
    required Property property,
    required String type,
    required String ownerName,
    required String ownerPhone,
  }) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();
    final descriptionController = TextEditingController();

    final bool isBook = type == 'Book';

    String formatDate(DateTime date) {
      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');

      return '$year-$month-$day';
    }

    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');

      return '$hour:$minute:00';
    }

    Future<void> submitRequest(BuildContext dialogContext) async {
      if (!formKey.currentState!.validate()) return;

      try {
        if (isBook) {
          await RequestService.createVisitRequest(
            propertyId: property.id,
            fullName: nameController.text.trim(),
            phone: phoneController.text.trim(),
            email: emailController.text.trim(),
            preferredDate: dateController.text.trim(),
            preferredTime: timeController.text.trim(),
            message: descriptionController.text.trim(),
          );
        } else {
          final durationMonths = int.tryParse(
            durationController.text.trim(),
          );

          if (durationMonths == null || durationMonths <= 0) {
            _showFormError(
              dialogContext: dialogContext,
              title: 'Invalid Duration',
              message: 'Please enter rental duration as a number. Example: 12',
            );
            return;
          }

          await RequestService.createRentRequest(
            propertyId: property.id,
            fullName: nameController.text.trim(),
            phone: phoneController.text.trim(),
            email: emailController.text.trim(),
            moveInDate: dateController.text.trim(),
            rentalDurationMonths: durationMonths,
            message: descriptionController.text.trim(),
          );
        }

        if (!mounted) return;

        Navigator.pop(dialogContext);

        _showSuccessMessage(
          isBook
              ? 'Visit booking submitted for ${property.title}'
              : 'Rent request submitted for ${property.title}',
        );
      } catch (e) {
        if (!mounted) return;

        _showFormError(
          dialogContext: dialogContext,
          title: 'Request Error',
          message: e.toString(),
        );
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formHeader(
                      title: isBook ? 'Book Visit' : 'Rent Property',
                      subtitle: isBook
                          ? 'Choose a date and time to visit this property.'
                          : 'Fill your information to request renting.',
                    ),

                    const SizedBox(height: 16),

                    _propertyInfoCard(property),

                    const SizedBox(height: 12),

                    _ownerInfoCard(
                      ownerName: ownerName,
                      ownerPhone: ownerPhone,
                    ),

                    const SizedBox(height: 18),

                    _dialogInputField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validatorText: 'Please enter your name',
                    ),

                    _dialogInputField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validatorText: 'Please enter your phone number',
                    ),

                    _dialogInputField(
                      controller: emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validatorText: 'Please enter your email',
                    ),

                    _dialogInputField(
                      controller: dateController,
                      label: isBook ? 'Visit Date' : 'Move-in Date',
                      icon: isBook
                          ? Icons.calendar_month_outlined
                          : Icons.event_available_outlined,
                      readOnly: true,
                      validatorText: isBook
                          ? 'Please choose visit date'
                          : 'Please choose move-in date',
                      hintText: isBook
                          ? 'Choose date to visit property'
                          : 'Choose your move-in date',
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: dialogContext,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (selectedDate != null) {
                          dateController.text = formatDate(selectedDate);
                        }
                      },
                    ),

                    if (isBook)
                      _dialogInputField(
                        controller: timeController,
                        label: 'Visit Time',
                        icon: Icons.access_time,
                        readOnly: true,
                        validatorText: 'Please choose visit time',
                        hintText: 'Choose time to visit property',
                        onTap: () async {
                          final selectedTime = await showTimePicker(
                            context: dialogContext,
                            initialTime: TimeOfDay.now(),
                          );

                          if (selectedTime != null) {
                            timeController.text = formatTime(selectedTime);
                          }
                        },
                      ),

                    if (!isBook)
                      _dialogInputField(
                        controller: durationController,
                        label: 'Rental Duration Months',
                        icon: Icons.timelapse_outlined,
                        keyboardType: TextInputType.number,
                        validatorText: 'Please enter rental duration',
                        hintText: 'Example: 12',
                      ),

                    _dialogInputField(
                      controller: descriptionController,
                      label: 'Description / Message',
                      icon: Icons.description_outlined,
                      maxLines: 4,
                      validatorText: 'Please enter description',
                      hintText: isBook
                          ? 'Example: I want to visit this property in the morning.'
                          : 'Example: I want to rent this property for 1 year.',
                    ),

                    const SizedBox(height: 12),

                    _submitButton(
                      text: isBook ? 'Submit Booking' : 'Submit Rent Request',
                      icon: isBook
                          ? Icons.calendar_month_outlined
                          : Icons.key_outlined,
                      onPressed: () => submitRequest(dialogContext),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _formHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _propertyInfoCard(Property property) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.home_outlined,
              color: Color(0xFF1E3A8A),
              size: 28,
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
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property.location,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${property.price.toStringAsFixed(0)} / month',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownerInfoCard({
    required String ownerName,
    required String ownerPhone,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_pin_circle_outlined,
              color: Color(0xFFF59E0B),
              size: 30,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Owner',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ownerName,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 15,
                      color: Color(0xFF1E3A8A),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ownerPhone,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _dialogInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validatorText;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF1E3A8A),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF1E3A8A),
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),
        ),
      ),
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
          'Search',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
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
                errorMessage!,
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
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
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
                onSubmitted: (_) => _performSearch(),
                decoration: InputDecoration(
                  hintText: 'Search properties',
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
                    onPressed: _performSearch,
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _statCard(
                  Icons.home_outlined,
                  '${searchResults.length}',
                  'Found',
                ),
                const SizedBox(width: 12),
                _statCard(
                  Icons.calendar_month_outlined,
                  'Book',
                  'Visit',
                ),
                const SizedBox(width: 12),
                _statCard(
                  Icons.key_outlined,
                  'Rent',
                  'Ready',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  onPressed: _performSearch,
                  child: Text(
                    'Search',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: isSearching
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : searchResults.isEmpty
                ? Center(
              child: Text(
                'No properties found',
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final property = searchResults[index];

                return _propertyCard(
                  property,
                  _getImageUrl(property, index),
                  index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _propertyCard(
      Property property,
      String imageUrl,
      int index,
      ) {
    return GestureDetector(
      onTap: () {
        _openPropertyDetails(property, index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _smallInfo(
                        Icons.bed_outlined,
                        '${property.bedrooms} Beds',
                      ),
                      const SizedBox(width: 14),
                      _smallInfo(
                        Icons.bathtub_outlined,
                        '${property.bathrooms} Baths',
                      ),
                      const SizedBox(width: 14),
                      _smallInfo(
                        Icons.square_foot_outlined,
                        _getSize(property, index),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    '\$${property.price.toStringAsFixed(0)} / month',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _openBookForm(property, index);
                          },
                          icon: const Icon(
                            Icons.calendar_month_outlined,
                          ),
                          label: const Text('Book Visit'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1E3A8A),
                            side: const BorderSide(
                              color: Color(0xFF1E3A8A),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _openRentForm(property, index);
                          },
                          icon: const Icon(Icons.key),
                          label: const Text('Rent'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _statCard(
      IconData icon,
      String number,
      String title,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
              icon,
              color: const Color(0xFF1E3A8A),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;
  final String imageUrl;
  final String ownerName;
  final String ownerPhone;
  final String size;
  final bool hasWifi;
  final bool hasParking;
  final bool hasSecurity;
  final bool hasAirConditioner;
  final String description;

  const PropertyDetailsScreen({
    super.key,
    required this.property,
    required this.imageUrl,
    required this.ownerName,
    required this.ownerPhone,
    required this.size,
    required this.hasWifi,
    required this.hasParking,
    required this.hasSecurity,
    required this.hasAirConditioner,
    required this.description,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  List<String> get _propertyImages {
    final images = widget.property.imageUrls
        .where((url) => url.trim().isNotEmpty)
        .toList();

    if (images.isNotEmpty) {
      return images;
    }

    if (widget.imageUrl.trim().isNotEmpty) {
      return [widget.imageUrl];
    }

    return ['https://via.placeholder.com/600x400'];
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _openImageViewer(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyImageViewerScreen(
          images: _propertyImages,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E3A8A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFormError({
    required BuildContext dialogContext,
    required String title,
    required String message,
  }) {
    showDialog(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.inter(
                  color: const Color(0xFF1E3A8A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openFloatingForm(String type) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();
    final descriptionController = TextEditingController();

    final bool isBook = type == 'Book';

    String formatDate(DateTime date) {
      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');

      return '$year-$month-$day';
    }

    String formatTime(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');

      return '$hour:$minute:00';
    }

    Future<void> submitRequest(BuildContext dialogContext) async {
      if (!formKey.currentState!.validate()) return;

      try {
        if (isBook) {
          await RequestService.createVisitRequest(
            propertyId: widget.property.id,
            fullName: nameController.text.trim(),
            phone: phoneController.text.trim(),
            email: emailController.text.trim(),
            preferredDate: dateController.text.trim(),
            preferredTime: timeController.text.trim(),
            message: descriptionController.text.trim(),
          );
        } else {
          final durationMonths = int.tryParse(
            durationController.text.trim(),
          );

          if (durationMonths == null || durationMonths <= 0) {
            _showFormError(
              dialogContext: dialogContext,
              title: 'Invalid Duration',
              message: 'Please enter rental duration as a number. Example: 12',
            );
            return;
          }

          await RequestService.createRentRequest(
            propertyId: widget.property.id,
            fullName: nameController.text.trim(),
            phone: phoneController.text.trim(),
            email: emailController.text.trim(),
            moveInDate: dateController.text.trim(),
            rentalDurationMonths: durationMonths,
            message: descriptionController.text.trim(),
          );
        }

        if (!mounted) return;

        Navigator.pop(dialogContext);

        _showSuccessMessage(
          isBook
              ? 'Visit booking submitted for ${widget.property.title}'
              : 'Rent request submitted for ${widget.property.title}',
        );
      } catch (e) {
        if (!mounted) return;

        _showFormError(
          dialogContext: dialogContext,
          title: 'Request Error',
          message: e.toString(),
        );
      }
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formHeader(
                      title: isBook ? 'Book Visit' : 'Rent Property',
                      subtitle: isBook
                          ? 'Choose a date and time to visit this property.'
                          : 'Fill your information to request renting.',
                    ),

                    const SizedBox(height: 16),

                    _propertyInfoCard(),

                    const SizedBox(height: 12),

                    _ownerInfoCard(),

                    const SizedBox(height: 18),

                    _dialogInputField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                      validatorText: 'Please enter your name',
                    ),

                    _dialogInputField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validatorText: 'Please enter your phone number',
                    ),

                    _dialogInputField(
                      controller: emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validatorText: 'Please enter your email',
                    ),

                    _dialogInputField(
                      controller: dateController,
                      label: isBook ? 'Visit Date' : 'Move-in Date',
                      icon: isBook
                          ? Icons.calendar_month_outlined
                          : Icons.event_available_outlined,
                      readOnly: true,
                      validatorText: isBook
                          ? 'Please choose visit date'
                          : 'Please choose move-in date',
                      hintText: isBook
                          ? 'Choose date to visit property'
                          : 'Choose your move-in date',
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: dialogContext,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (selectedDate != null) {
                          dateController.text = formatDate(selectedDate);
                        }
                      },
                    ),

                    if (isBook)
                      _dialogInputField(
                        controller: timeController,
                        label: 'Visit Time',
                        icon: Icons.access_time,
                        readOnly: true,
                        validatorText: 'Please choose visit time',
                        hintText: 'Choose time to visit property',
                        onTap: () async {
                          final selectedTime = await showTimePicker(
                            context: dialogContext,
                            initialTime: TimeOfDay.now(),
                          );

                          if (selectedTime != null) {
                            timeController.text = formatTime(selectedTime);
                          }
                        },
                      ),

                    if (!isBook)
                      _dialogInputField(
                        controller: durationController,
                        label: 'Rental Duration Months',
                        icon: Icons.timelapse_outlined,
                        keyboardType: TextInputType.number,
                        validatorText: 'Please enter rental duration',
                        hintText: 'Example: 12',
                      ),

                    _dialogInputField(
                      controller: descriptionController,
                      label: 'Description / Message',
                      icon: Icons.description_outlined,
                      maxLines: 4,
                      validatorText: 'Please enter description',
                      hintText: isBook
                          ? 'Example: I want to visit this property in the morning.'
                          : 'Example: I want to rent this property for 1 year.',
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => submitRequest(dialogContext),
                        icon: Icon(
                          isBook
                              ? Icons.calendar_month_outlined
                              : Icons.key_outlined,
                        ),
                        label: Text(
                          isBook ? 'Submit Booking' : 'Submit Rent Request',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _formHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _propertyInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.home_outlined,
            color: Color(0xFF1E3A8A),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.property.title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_pin_circle_outlined,
            color: Color(0xFFF59E0B),
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.ownerName}\n${widget.ownerPhone}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return validatorText;
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF1E3A8A),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF1E3A8A),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Icon(
            icon,
            color: const Color(0xFF1E3A8A),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureChip({
    required IconData icon,
    required String label,
    required bool available,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: available
            ? const Color(0xFFEFF6FF)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: available
              ? const Color(0xFF1E3A8A).withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available ? icon : Icons.close,
            color: available ? const Color(0xFF1E3A8A) : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: available ? const Color(0xFF1E3A8A) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _imageSlider() {
    final images = _propertyImages;

    return Stack(
      children: [
        SizedBox(
          height: 310,
          width: double.infinity,
          child: PageView.builder(
            controller: _imagePageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = images[index];

              return GestureDetector(
                onTap: () => _openImageViewer(index),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 44,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        Positioned(
          top: 44,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ),

        Positioned(
          top: 48,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Tap to zoom',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (index) {
                  final isActive = index == _currentImageIndex;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                },
              ),
            ),
          ),

        if (images.length > 1)
          Positioned(
            right: 16,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${images.length}',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageSlider(),

                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1F2937),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              property.location,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        '\$${property.price.toStringAsFixed(0)} / month',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),

                      _sectionTitle('Property Owner'),

                      _ownerInfoCard(),

                      _sectionTitle('Property Information'),

                      _infoTile(
                        icon: Icons.category_outlined,
                        title: 'Property Type',
                        value: property.propertyType,
                      ),

                      const SizedBox(height: 10),

                      _infoTile(
                        icon: Icons.square_foot_outlined,
                        title: 'Property Size',
                        value: widget.size,
                      ),

                      const SizedBox(height: 10),

                      _infoTile(
                        icon: Icons.bed_outlined,
                        title: 'Rooms / Bedrooms',
                        value: '${property.bedrooms}',
                      ),

                      const SizedBox(height: 10),

                      _infoTile(
                        icon: Icons.bathtub_outlined,
                        title: 'Bathrooms',
                        value: '${property.bathrooms}',
                      ),

                      const SizedBox(height: 10),

                      _infoTile(
                        icon: Icons.star,
                        title: 'Rating',
                        value: property.rating.toString(),
                      ),

                      _sectionTitle('Facilities'),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _featureChip(
                            icon: Icons.wifi,
                            label: widget.hasWifi ? 'Free Wi-Fi' : 'No Wi-Fi',
                            available: widget.hasWifi,
                          ),
                          _featureChip(
                            icon: Icons.local_parking_outlined,
                            label: widget.hasParking
                                ? 'Parking Available'
                                : 'No Parking',
                            available: widget.hasParking,
                          ),
                          _featureChip(
                            icon: Icons.security_outlined,
                            label: widget.hasSecurity
                                ? 'Security'
                                : 'No Security',
                            available: widget.hasSecurity,
                          ),
                          _featureChip(
                            icon: Icons.ac_unit,
                            label: widget.hasAirConditioner
                                ? 'Air Conditioner'
                                : 'No Air Conditioner',
                            available: widget.hasAirConditioner,
                          ),
                        ],
                      ),

                      _sectionTitle('Description'),

                      Text(
                        widget.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,
                          color: Colors.grey[700],
                        ),
                      ),

                      _sectionTitle('Good For'),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _featureChip(
                            icon: Icons.school_outlined,
                            label: 'Students',
                            available: true,
                          ),
                          _featureChip(
                            icon: Icons.work_outline,
                            label: 'Workers',
                            available: true,
                          ),
                          _featureChip(
                            icon: Icons.family_restroom,
                            label: 'Small Family',
                            available: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _openFloatingForm('Book');
                      },
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: const Text('Book Visit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1E3A8A),
                        side: const BorderSide(
                          color: Color(0xFF1E3A8A),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openFloatingForm('Rent');
                      },
                      icon: const Icon(Icons.key),
                      label: const Text('Rent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const PropertyImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<PropertyImageViewerScreen> createState() =>
      _PropertyImageViewerScreenState();
}

class _PropertyImageViewerScreenState extends State<PropertyImageViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  final TransformationController _transformationController =
  TransformationController();

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _zoomIn() {
    _transformationController.value = Matrix4.identity()..scale(2.0);
  }

  void _zoomOut() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });

              _resetZoom();
            },
            itemBuilder: (context, index) {
              final imageUrl = images[index];

              return Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 5.0,
                  panEnabled: true,
                  scaleEnabled: true,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 44,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            top: 50,
            right: 18,
            child: Text(
              '${_currentIndex + 1}/${images.length}',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _viewerButton(
                  icon: Icons.zoom_out,
                  onTap: _zoomOut,
                ),
                const SizedBox(width: 16),
                _viewerButton(
                  icon: Icons.center_focus_strong,
                  onTap: _resetZoom,
                ),
                const SizedBox(width: 16),
                _viewerButton(
                  icon: Icons.zoom_in,
                  onTap: _zoomIn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewerButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}