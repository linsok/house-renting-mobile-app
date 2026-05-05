# My Rentor - House Renting Mobile App

A modern Flutter mobile application for finding and renting properties. Built with a clean, intuitive interface and comprehensive features for property seekers.

## Features

### Core Functionality
- **Property Browsing**: Browse available rental properties with detailed information
- **Search & Filter**: Advanced search functionality with location and property type filters
- **Property Categories**: Filter by House, Apartment, Office Space, and Shop
- **Favorites System**: Save and manage favorite properties
- **User Profile**: Personalized user experience with profile management

### Navigation & UI
- **Modern Bottom Navigation**: Clean tab-based navigation
- **Onboarding Screen**: User-friendly introduction to the app
- **Responsive Design**: Optimized for various screen sizes
- **Beautiful UI**: Modern Material Design with custom styling
- **Location Selection**: Dynamic location filtering (Toul Kork, Phnom Penh, Sen Sok, BKK)

## Project Structure

```
lib/
├── main.dart                 # App entry point and navigation
├── models/
│   └── property.dart        # Property data model
├── screens/
│   ├── home_screen.dart      # Main home screen
│   ├── rent_screen.dart      # Rental properties listing
│   ├── saved_screen.dart     # Saved/favorite properties
│   ├── profile_screen.dart   # User profile
│   └── onboarding_screen.dart # App introduction
└── widgets/
    └── property_card.dart    # Reusable property card widget
```

## Technologies Used

- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language
- **Google Fonts**: Typography and font management
- **Cached Network Image**: Efficient image loading and caching

## Getting Started

### Prerequisites
- Flutter SDK (version 3.10.8 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android emulator or physical device for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/linsok/house-renting-mobile-app.git
   cd house_renting_mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS Bundle:**
```bash
flutter build ios --release
```

## App Screens

### 1. Onboarding Screen
- Welcome screens to introduce the app
- Smooth transitions and engaging visuals

### 2. Home Screen
- Featured properties display
- Quick search functionality
- Property category filters
- Location-based browsing

### 3. Rent Screen
- Dedicated rental properties listing
- Horizontal and vertical property cards
- Advanced search and filtering options
- Property type selection

### 4. Saved Screen
- User's favorite properties
- Quick access to saved listings

### 5. Profile Screen
- User information and settings
- Account management options

## Design Features

- **Color Scheme**: Professional blue (#1E3A8A) and amber (#F59E0B) accents
- **Typography**: Clean Inter font family via Google Fonts
- **Card Design**: Modern property cards with image previews
- **Responsive Layout**: Adaptive designs for different screen sizes
- **Smooth Animations**: Subtle transitions and micro-interactions

## Dependencies

- `google_fonts: ^6.2.1` - Custom typography
- `cached_network_image: ^3.4.1` - Efficient image loading
- `cupertino_icons: ^1.0.8` - iOS-style icons

## Development

### Code Style
- Following Flutter/Dart best practices
- Clean architecture with separation of concerns
- Reusable widgets and components
- Consistent naming conventions

### State Management
- StatefulWidget for local state management
- Efficient widget rebuilding patterns

## Live Demo

The app is available for download and testing on Android devices. Features include:
- Real-time property browsing
- Interactive property cards
- Smooth navigation between screens
- Responsive design for various screen sizes

## License

This project is open source and available under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## Support

For any questions or support regarding this project, please open an issue on GitHub.

---

**Built with ❤️ using Flutter**
