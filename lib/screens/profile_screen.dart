import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:house_renting_mobile/screens/onboarding_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1F2937);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'John Doe';
  String email = 'john.doe@example.com';
  String phone = '+1 234 567 8900';
  String password = '';
  String photoUrl = '';

  static const Color primaryColor = ProfileScreen.primaryColor;
  static const Color darkText = ProfileScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: simpleAppBar('My Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileInfoCard(),
            const SizedBox(height: 24),
            _sectionTitle('All dashboard info'),
            const SizedBox(height: 12),
            _dashboardCard(),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: primaryColor,
            backgroundImage: photoUrl.trim().isNotEmpty
                ? NetworkImage(photoUrl.trim())
                : null,
            child: photoUrl.trim().isEmpty
                ? const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
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

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: name,
          email: email,
          phone: phone,
          password: password,
          photoUrl: photoUrl,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        name = result['name'] ?? name;
        email = result['email'] ?? email;
        phone = result['phone'] ?? phone;
        password = result['password'] ?? password;
        photoUrl = result['photoUrl'] ?? photoUrl;
      });
    }
  }

  Widget _dashboardCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              _dashboardItem(
                icon: Icons.home_outlined,
                value: '12',
                label: 'Listed Properties',
                onTap: () {
                  _openPage(
                    const SimpleInfoPage(
                      title: 'Listed Properties',
                      icon: Icons.home_outlined,
                      content:
                      'Here you can view and manage all properties listed by your account.',
                    ),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.message_outlined,
                value: '5',
                label: 'Messages',
                onTap: () {
                  _openPage(
                    const SimpleInfoPage(
                      title: 'Messages',
                      icon: Icons.message_outlined,
                      content:
                      'Here you can view messages from users, property owners, or customers.',
                    ),
                  );
                },
              ),
              _dashboardItem(
                icon: Icons.visibility_outlined,
                value: '240',
                label: 'Profile Views',
                onTap: () {
                  _openPage(
                    const SimpleInfoPage(
                      title: 'Profile Views',
                      icon: Icons.visibility_outlined,
                      content:
                      'Here you can see how many users have viewed your profile.',
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Recent Activity',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),
          const SizedBox(height: 12),
          _activityItem(
            Icons.search,
            'Searched rental homes',
            '15 minutes ago',
          ),
          _activityItem(
            Icons.chat_bubble_outline,
            'New message received',
            '1 hour ago',
          ),
        ],
      ),
    );
  }

  Widget _dashboardItem({
    required IconData icon,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryColor),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
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

  Widget _activityItem(IconData icon, String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor.withValues(alpha: 0.08),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthWelcomeScreen(),
                ),
                    (route) => false,
              );
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
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Logged out successfully',
                      style: GoogleFonts.inter(),
                    ),
                  ),
                );
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
  final String name;
  final String email;
  final String phone;
  final String password;
  final String photoUrl;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.photoUrl,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static const Color primaryColor = ProfileScreen.primaryColor;
  static const Color darkText = ProfileScreen.darkText;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController photoUrlController;

  bool hidePassword = true;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    passwordController = TextEditingController(text: widget.password);
    photoUrlController = TextEditingController(text: widget.photoUrl);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    photoUrlController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'password': passwordController.text.trim(),
      'photoUrl': photoUrlController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = photoUrlController.text.trim();

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
              CircleAvatar(
                radius: 45,
                backgroundColor: primaryColor,
                backgroundImage:
                photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.isEmpty
                    ? const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 45,
                )
                    : null,
              ),
              const SizedBox(height: 20),
              _inputField(
                controller: nameController,
                label: 'Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 14),
              _inputField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _inputField(
                controller: phoneController,
                label: 'Contact Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                style: GoogleFonts.inter(),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: GoogleFonts.inter(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _inputField(
                controller: photoUrlController,
                label: 'Photo URL',
                icon: Icons.image_outlined,
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
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
    void Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: GoogleFonts.inter(),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(),
        prefixIcon: Icon(icon),
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
