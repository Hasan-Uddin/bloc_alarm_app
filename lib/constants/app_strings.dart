/// Application-wide string constants
/// Centralizing strings makes localization easier and maintains consistency
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // App Info
  static const String appName = 'Flutter Clean App';
  static const String appTagline = 'Built with Clean Architecture & Best Practices';

  // Onboarding
  static const String onboardingTitle1 = 'Welcome to Clean Architecture';
  static const String onboardingDescription1 =
      'Experience a well-structured Flutter app with separation of concerns and industry best practices.';
  
  static const String onboardingTitle2 = 'Powerful Features';
  static const String onboardingDescription2 =
      'Built with BLoC for state management, Hive for local storage, and Dio for seamless API integration.';
  
  static const String onboardingTitle3 = 'Get Started';
  static const String onboardingDescription3 =
      'Create, update, and manage your notes effortlessly with offline support and real-time sync.';
  
  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';

  // Notes Feature
  static const String notesTitle = 'My Notes';
  static const String addNote = 'Add Note';
  static const String editNote = 'Edit Note';
  static const String deleteNote = 'Delete Note';
  static const String noteTitle = 'Note Title';
  static const String noteContent = 'Note Content';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String confirmDelete = 'Are you sure you want to delete this note?';
  static const String noNotes = 'No notes yet';
  static const String noNotesDescription = 'Tap the + button to create your first note';
  static const String searchNotes = 'Search notes...';

  // Common UI
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String pullToRefresh = 'Pull to refresh';

  // Validation Messages
  static const String required = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String passwordTooShort = 'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Error Messages
  static const String networkError = 'Network connection error';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String noInternetConnection = 'No internet connection';
  static const String timeoutError = 'Request timeout';
  static const String notFound = 'Resource not found';

  // Success Messages
  static const String noteCreated = 'Note created successfully';
  static const String noteUpdated = 'Note updated successfully';
  static const String noteDeleted = 'Note deleted successfully';
}
