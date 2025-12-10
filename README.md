SugarCare

A small, friendly, open-source app that helps people keep track of their blood sugar, meal timing, and daily activity.

SugarCare is designed to feel calm and simple. It avoids clutter, avoids unwanted features, and focuses on what actually matters: logging sugar levels quickly and reviewing them easily. The interface uses a warm peach–pink–gold theme with soft glass effects and a compact layout that works even on small screens.

The goal of this project is to provide a minimal, privacy-friendly tool that anyone can use without creating an account or relying on cloud services.

Features
Blood Sugar Logging

You can log your readings before or after each meal. The app automatically determines which meal you’re closest to based on the time of day.
If you check your levels outside those time ranges, there is a clear option to log it as an outside-meal reading.

Custom Meal Windows

Everyone follows different schedules. SugarCare allows you to set your breakfast, lunch, and dinner windows once, and uses these to categorize readings.

Activity Tracking

Track steps, walking/running distance, and approximate calories burned. Activity entries appear alongside your sugar logs in the history view.

Local, Private Data

SugarCare stores everything directly on your device using SharedPreferences.
No accounts, no servers, and no internet connection required.

Date-Grouped History

Your logs are neatly organized by date so you can look back and understand your patterns over time. Both sugar readings and activity entries appear in the timeline.

Compact and Responsive UI

The layout adapts to very small screens. All widgets are designed to avoid overflow and maintain readability, even on older devices.

Getting Started
Clone this repository
git clone https://github.com/YOUR_USERNAME/sugarcare.git
cd sugarcare

Install dependencies
flutter pub get

Run the application
flutter run

Building Release Versions
Build an Android APK
flutter build apk --release

Build an Android AppBundle
flutter build appbundle

App Icon

To generate a launcher icon, SugarCare uses flutter_launcher_icons.
Add your icon at:

assets/icon/app_icon.png


Then run:

dart run flutter_launcher_icons

Contributing

SugarCare is intentionally simple, but there is room to grow.
Contributions are welcome, whether it’s bug fixes, UI improvements, documentation, or new features that fit the project’s lightweight philosophy.

If you plan a larger change, consider opening an issue first so the direction can be discussed.

License

This project is released under the MIT License.
You are free to use, modify, and distribute it.
