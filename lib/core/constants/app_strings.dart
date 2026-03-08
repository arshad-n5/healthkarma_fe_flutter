// lib/core/constants/app_strings.dart
//
// All text content in one place.
// Makes it easy to update copy or add translations later.

class AppStrings {
  AppStrings._();

  // ── App name ──────────────────────────────────
  static const String appName      = 'Healthkarma.ai';
  static const String appNameBrand = 'Health';       // purple part
  static const String appNameRest  = 'karma.ai';     // white part

  // ── Onboarding slides ─────────────────────────
  static const List<Map<String, String>> onboardingSlides = [
    {
      'title':       'Track your health,\neffortlessly',
      'description': 'Monitor your vitals and progress daily. Sync with '
                     'wearables and remote devices to keep your care team updated.',
    },
    {
      'title':       'Your care,\nyour way',
      'description': 'Get personalized insights, asthma and allergy alerts, '
                     'and daily plans tailored to your lifestyle and condition.',
    },
    {
      'title':       'Never miss a dose\nor visit',
      'description': 'Set medication reminders, track appointments, and chat '
                     'with your care team — all in one place.',
    },
  ];

  // ── Common actions ────────────────────────────
  static const String skip       = 'Skip';
  static const String next       = 'Next';
  static const String getStarted = 'Get Started';
  static const String login      = 'Log In';
  static const String signUp     = 'Sign Up';
}
