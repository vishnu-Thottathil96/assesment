# inovant

A Flutter application with a modern dark-themed UI.

## Features

- **Splash Screen:** Animated splash screen using Lottie.
- **Home Page:** Main landing page after splash.
- **Influencer List:** Browse influencers (see `influencer_list_page.dart`).
- **Restaurant Search:** Search for restaurants (see `restaurant_search_page.dart`).
- **Responsive Design:** Uses `flutter_screenutil` and custom helpers for scaling UI across devices.

## Folder Structure

```
lib
│   main.dart
│
├───core
│   │   api_client.dart
│   │   api_endpoints.dart
│   │   app_config.dart
│   │   exception_handler.dart
│   │
│   ├───constants
│   │       app_colors.dart
│   │       app_strings.dart
│   │
│   └───util
│           parse_html_string.dart
│           responsive_helper.dart
│
├───models
│       influencer.dart
│       influencer_details_model.dart
│       restaurent_details_model.dart
│
├───screens
│       home_page.dart
│       influencer_detail.dart
│       influencer_list_page.dart
│       restaurant_details.dart
│       restaurant_search_page.dart
│       splash_screen.dart
│
└───widgets
        influencer_card.dart
        influencer_card_demo.dart
        influencer_shimmer_card.dart
        vertical_gap.dart

## Getting Started

1. **Install dependencies:**  
   Run `flutter pub get`.

2. **Run the app:**  
   Use `flutter run` or your IDE’s run button.

3. **Assets:**  
   Ensure `assets/loading_animation.json` exists for the splash animation.

## Packages Used

- [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- [lottie](https://pub.dev/packages/lottie)

## Customization

- Change the splash animation in `lib/screens/splash_screen.dart`.
- Update theme and design in `lib/main.dart`.

---

For more details, see the code in the