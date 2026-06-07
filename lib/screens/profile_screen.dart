import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/profile_service.dart';
import 'onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1F2937);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String email = '';
  String phone = '';
  String address = '';
  String role = '';
  bool isBlocked = false;
  String photoUrl = '';

  bool isLoading = true;
  String? errorMessage;

  static const Color primaryColor = ProfileScreen.primaryColor;
  static const Color darkText = ProfileScreen.darkText;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ProfileService.getMyProfile();

      if (!mounted) return;

      setState(() {
        fullName = (data['full_name'] ?? data['username'] ?? '').toString();
        email = (data['email'] ?? '').toString();
        phone = (data['phone'] ?? '').toString();
        address = (data['address'] ?? '').toString();
        role = (data['role'] ?? 'user').toString();
        isBlocked = data['is_blocked'] == true;
        photoUrl = (data['profile_image_url'] ?? '').toString();
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

  Future<void> _logout() async {
    await AuthService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthWelcomeScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('My Profile'),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
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
                errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileInfoCard(),
            const SizedBox(height: 24),
            _sectionTitle('Account Info'),
            const SizedBox(height: 12),
            _accountInfoCard(),
            const SizedBox(height: 24),
            _sectionTitle('Settings'),
            const SizedBox(height: 12),
            _menuCard(),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    );
  }

  Widget _profileInfoCard() {
    final displayName = fullName.trim().isNotEmpty ? fullName : 'User';
    final displayPhone = phone.trim().isNotEmpty ? phone : 'No phone number';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: primaryColor,
            backgroundImage:
            photoUrl.trim().isNotEmpty ? NetworkImage(photoUrl.trim()) : null,
            child: photoUrl.trim().isEmpty
                ? const Icon(
              Icons.person,
              size: 42,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displayPhone,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          _statusChip(),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openEditProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip() {
    final statusText = isBlocked ? 'Blocked' : 'Active';
    final statusColor = isBlocked ? Colors.red : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${role.toUpperCase()} • $statusText',
        style: GoogleFonts.inter(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _accountInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: fullName.trim().isNotEmpty ? fullName : '-',
          ),
          _buildDivider(),
          _infoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: email.trim().isNotEmpty ? email : '-',
          ),
          _buildDivider(),
          _infoRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone.trim().isNotEmpty ? phone : '-',
          ),
          _buildDivider(),
          _infoRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: address.trim().isNotEmpty ? address : '-',
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 22),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          fullName: fullName,
          email: email,
          phone: phone,
          address: address,
          photoUrl: photoUrl,
        ),
      ),
    );

    if (result == true) {
      await _loadProfile();
    }
  }

  Widget _menuCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildMenuOption(
            icon: Icons.history,
            title: 'Search History',
            onTap: () {
              _openPage(const SearchHistoryPage());
            },
          ),
          _buildDivider(),
          _buildMenuOption(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              _openPage(const PrivacyPolicyPage());
            },
          ),
          _buildDivider(),
          _buildMenuOption(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              _openPage(const HelpSupportPage());
            },
          ),
          _buildDivider(),
          _buildMenuOption(
            icon: Icons.logout,
            title: 'Logout',
            onTap: _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey[700]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.inter(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : primaryColor,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: isDestructive ? Colors.red : darkText,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }

  BoxDecoration _cardDecoration() {
    return whiteCardDecoration();
  }
}

class EditProfilePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String photoUrl;

  const EditProfilePage({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.photoUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color primaryColor = ProfileScreen.primaryColor;
  static const Color darkText = ProfileScreen.darkText;

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  XFile? selectedImage;
  final ImagePicker imagePicker = ImagePicker();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(text: widget.fullName);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      selectedImage = image;
    });
  }

  ImageProvider? _getProfileImageProvider() {
    if (selectedImage != null) {
      return NetworkImage(selectedImage!.path);
    }

    if (widget.photoUrl.trim().isNotEmpty) {
      return NetworkImage(widget.photoUrl.trim());
    }

    return null;
  }

  Future<void> _saveProfile() async {
    setState(() {
      isSaving = true;
    });

    try {
      await ProfileService.updateProfileWithImage(
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        imageFile: selectedImage,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _getProfileImageProvider();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: whiteCardDecoration(),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: primaryColor,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 45,
                      )
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Tap image to upload profile photo',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              _inputField(
                controller: fullNameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                enabled: false,
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                enabled: false,
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 14),

              _inputField(
                controller: addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : Text(
                    'Save Changes',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: GoogleFonts.inter(
        color: enabled ? darkText : Colors.grey[700],
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    final histories = [
      {
        'title': 'Rental homes in Cambodia',
        'date': '15 minutes ago',
        'keyword': 'Rental homes',
        'location': 'Cambodia',
        'category': 'House',
        'price': '\$5000',
        'result': 'User searched rental homes in Cambodia with house category.',
      },
      {
        'title': 'Apartments near university',
        'date': '1 hour ago',
        'keyword': 'Apartments near university',
        'location': 'Near university',
        'category': 'Apartment',
        'price': '\$3000',
        'result': 'User searched apartments near university.',
      },
      {
        'title': 'Houses with parking',
        'date': 'Yesterday',
        'keyword': 'Parking house',
        'location': 'Phnom Penh',
        'category': 'House',
        'price': '\$5000',
        'result': 'User searched houses that include parking.',
      },
      {
        'title': 'Affordable condos',
        'date': '2 days ago',
        'keyword': 'Affordable condos',
        'location': 'Toul Kork',
        'category': 'Apartment',
        'price': '\$2500',
        'result': 'User searched affordable condos around Toul Kork.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('Search History'),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: histories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final history = histories[index];

          return Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(
                Icons.history,
                color: ProfileScreen.primaryColor,
              ),
              title: Text(
                history['title']!,
                style: GoogleFonts.inter(
                  color: darkText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                history['date']!,
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchHistoryDetailPage(
                      title: history['title']!,
                      date: history['date']!,
                      keyword: history['keyword']!,
                      location: history['location']!,
                      category: history['category']!,
                      price: history['price']!,
                      result: history['result']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SearchHistoryDetailPage extends StatelessWidget {
  final String title;
  final String date;
  final String keyword;
  final String location;
  final String category;
  final String price;
  final String result;

  const SearchHistoryDetailPage({
    super.key,
    required this.title,
    required this.date,
    required this.keyword,
    required this.location,
    required this.category,
    required this.price,
    required this.result,
  });

  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('History Detail'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: whiteCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                date,
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              _detailItem('Keyword', keyword),
              _detailItem('Location', location),
              _detailItem('Category', category),
              _detailItem('Max Price', price),
              const SizedBox(height: 16),
              Text(
                'What user did',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: darkText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Privacy Policy\n\n'
              'We respect your privacy and protect your personal information. '
              'Your name, email, phone number, profile photo, search history, and account information are used only to improve your experience in the app.\n\n'
              'We do not share your personal information with third parties without your permission. '
              'You can update your profile information anytime from the Edit Profile page.\n\n'
              'By using this application, you agree to our privacy policy and data protection practices.',
          style: GoogleFonts.inter(
            fontSize: 15,
            height: 1.6,
            color: darkText,
          ),
        ),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('Help & Support'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _supportCard(
              context: context,
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@example.com',
              pageContent:
              'You can contact our support team by email. Please describe your problem clearly and include your account information if needed.\n\nEmail: support@example.com\n\nOur team will review your message and reply as soon as possible.',
            ),
            const SizedBox(height: 12),
            _supportCard(
              context: context,
              icon: Icons.phone_outlined,
              title: 'Call Support',
              subtitle: '+855 12 345 678',
              pageContent:
              'You can call our support team for urgent help or account problems.\n\nPhone: +855 12 345 678\n\nAvailable support hours: Monday to Friday, 8:00 AM to 5:00 PM.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String pageContent,
  }) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(
          icon,
          color: ProfileScreen.primaryColor,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.inter(
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SupportDetailPage(
                title: title,
                icon: icon,
                content: pageContent,
              ),
            ),
          );
        },
      ),
    );
  }
}

class SupportDetailPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const SupportDetailPage({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
  });

  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar(title),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: whiteCardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 55,
                color: ProfileScreen.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleInfoPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const SimpleInfoPage({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
  });

  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar(title),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: whiteCardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: ProfileScreen.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget simpleAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(
      color: ProfileScreen.darkText,
    ),
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: ProfileScreen.darkText,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

BoxDecoration whiteCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
