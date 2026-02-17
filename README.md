# UniBites - University Outlet Ordering App

A Flutter-based pickup-only food ordering app designed for university outlets. Order from your favorite campus eateries, track preparation status, and pick up when ready!

## Features

✅ **Guest Browsing** - Browse menus without login, cart persists when you sign in
✅ **Outlet Selection** - Choose from multiple university outlets (Oven Express, Kitchenette, etc.)
✅ **Smart Menu Management** - Search, filter by category, and view dietary tags
✅ **Item Details** - Item info, special instructions, quantity selection
✅ **Cart Management** - Add/remove items, adjust quantities
✅ **Pickup-Only Orders** - No delivery, just order and pick up at the outlet
✅ **Order Tracking** - Real-time status: Confirmed → Preparing → Ready
✅ **Firebase Auth** - Email/password and Google Sign-in
✅ **Order History** - View past orders and reorder
✅ **Push Notifications** (MVP prep) - Status updates when order is ready
✅ **Profile Management** - Dietary preferences and account settings

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/
│   ├── routes.dart          # Go Router configuration
│   └── theme.dart           # App theme & styling
├── models/
│   ├── user.dart            # User model
│   ├── outlet.dart          # Outlet model
│   ├── menu_item.dart       # MenuItem model
│   ├── cart_item.dart       # CartItem model
│   ├── order.dart           # Order model
│   ├── order_tracking.dart  # OrderTracking model
│   └── index.dart           # Models export
├── services/
│   ├── local_storage_service.dart   # Hive local storage
│   ├── cart_service.dart            # Cart business logic
│   ├── auth_service.dart            # Firebase Auth
│   ├── outlet_service.dart          # Outlet data
│   ├── menu_service.dart            # Menu data
│   ├── order_service.dart           # Order management
│   ├── payment_service.dart         # Mock payments
│   ├── user_service.dart            # User profile
│   ├── notification_service.dart    # FCM (future)
│   └── index.dart                   # Services export
├── providers/
│   ├── service_providers.dart       # Service injection
│   ├── auth_provider.dart           # Auth state
│   ├── cart_provider.dart           # Cart state
│   ├── outlet_menu_provider.dart    # Outlet & menu state
│   ├── order_provider.dart          # Order state
│   └── index.dart                   # Providers export
├── screens/
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home/
│   │   └── home_screen.dart (coming soon)
│   ├── menu/
│   │   ├── menu_screen.dart (coming soon)
│   │   └── item_detail_screen.dart (coming soon)
│   ├── cart/
│   │   └── cart_screen.dart (coming soon)
│   ├── checkout/
│   │   └── checkout_screen.dart (coming soon)
│   ├── payment/
│   │   └── payment_screen.dart (coming soon)
│   ├── orders/
│   │   ├── order_confirmation_screen.dart (coming soon)
│   │   ├── order_tracking_screen.dart (coming soon)
│   │   └── order_history_screen.dart (coming soon)
│   ├── profile/
│   │   └── profile_screen.dart (coming soon)
│   └── index.dart                   # All screen exports
├── widgets/
│   └── (reusable components - coming soon)
└── assets/
    └── data/
        ├── outlets.json             # Mock outlet data
        ├── menu.json               # Mock menu items
        └── orders.json             # Mock orders
```

## Tech Stack

- **Framework**: Flutter (3.0+)
- **State Management**: Riverpod
- **Backend Services**: Firebase Auth, Firebase Messaging (FCM)
- **Local Storage**: Hive
- **Navigation**: Go Router
- **UI**: Material Design 3
- **JSON Serialization**: json_serializable

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK
- Android SDK / iOS SDK (for mobile development)
- Firebase project (setup optional for MVP)

### Installation

1. **Clone the repository**

   ```bash
   cd UniBites
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate model files**

   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

### Development Commands

```bash
# Build JSON serialization models
flutter pub run build_runner build

# Watch for changes during development
flutter pub run build_runner watch

# Run on specific device
flutter run -d <device_id>

# Run on web
flutter run -d chrome

# Format code
dart format lib/

# Analyze code
flutter analyze
```

## Data Models

### User

- id, email, name, phone, profilePhoto
- dietaryPreferences, pushNotificationEnabled

### Outlet

- id, name, logo, rating, ratingCount
- isOpen, hoursOfOperation, cuisineType
- campusLocation, lat/long

### MenuItem

- id, outletId, name, description, price
- image, category, tags, availability, prepTime

### Order

- id, userId, outletId, items[]
- status (pending/confirmed/preparing/ready/pickedUp)
- total, createdAt, orderNumber, estimatedPickupTime

### OrderTracking

- orderId, currentStatus, statusHistory[]
- estimatedPickupTime, actualPickupTime

## API/Services

### AuthService

- `loginWithEmail()`, `signup()`, `loginWithGoogle()`
- `logout()`, `forgotPassword()`, `getCurrentUser()`

### CartService

- `addItem()`, `removeItem()`, `updateQuantity()`, `clearCart()`
- `syncGuestCartOnLogin()`

### OutletService

- `getOutlets()`, `getOutletById()`, `getOutletInfo()`

### MenuService

- `getMenuByOutlet()`, `searchItems()`, `filterByCategory()`
- `getCategoriesByOutlet()`, `filterByTag()`

### OrderService

- `createOrder()`, `getOrderHistory()`, `getOrderById()`
- `getOrderTracking()`, `updateOrderStatus()`, `markAsPickedUp()`

## Guest Browsing Flow

1. User taps "Browse as Guest" on Login
2. Browses outlets and menu items
3. Adds items to locally-stored cart
4. At checkout, prompted to login
5. After login, guest cart merges with user account

## Order Tracking

**Real-time Status Updates:**

- **Pending** → **Confirmed** → **Preparing** → **Ready** → **Picked Up**
- Polling every 3-5 seconds for status changes
- Push notifications when order is ready (FCM)

## Mock Data

Mock data files located in `assets/data/`:

- **outlets.json** - 2 sample outlets (Oven Express, Kitchenette)
- **menu.json** - 16 sample menu items (Italian & Indian cuisines)
- **orders.json** - Empty (orders created at runtime)

## Firebase Setup (Optional for MVP)

1. Create Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication (Email/Password + Google Sign-In)
3. Enable Firebase Messaging (FCM) for push notifications
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
5. Add to project and configure in `pubspec.yaml`

## Next Steps / Roadmap

### Phase 2

- [ ] Comprehensive Home screen with outlet info card
- [ ] Full Menu listing with search & filtering
- [ ] Item detail screen with special instructions
- [ ] Cart UI with item management
- [ ] Checkout flow with order summary
- [ ] Order confirmation screen with order number

### Phase 3

- [ ] Real-time order tracking screen
- [ ] Order history with details
- [ ] Profile screen with preferences
- [ ] Firebase Messaging for push notifications
- [ ] Responsive design for web and tablet

### Phase 4

- [ ] Ratings & reviews
- [ ] Favorites/Wishlist
- [ ] Real payment integration (Stripe/PayPal)
- [ ] Email verification
- [ ] Multi-language support
- [ ] Dark mode

## Running Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test --concurrency=1
```

## Deployment

### Android

```bash
flutter build apk --split-per-abi
```

### iOS

```bash
flutter build ios
```

### Web

```bash
flutter build web
```

## Troubleshooting

**Build Issues:**

- Run `flutter clean && flutter pub get`
- Regenerate models: `flutter pub run build_runner clean && flutter pub run build_runner build`

**Firebase Issues:**

- Ensure `google-services.json` is in `android/app/`
- Check Firebase console for API key configuration

**Hive Storage Issues:**

- Clear app data: `flutter clean`
- Reinstall: `flutter pub get`

## Contributing

1. Create a feature branch
2. Commit changes
3. Create pull request

## License

MIT License - See LICENSE file for details

## Support

For issues or questions, contact the development team.

---

**Last Updated**: February 2026
**Project Status**: Initial Setup Complete - Screens in Development
