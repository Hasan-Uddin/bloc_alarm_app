/// API endpoint constants
/// Centralized API configuration for easy environment switching
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // Base URLs
  // Using JSONPlaceholder as example API (you can replace with your own API)
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  
  // Timeout durations
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Endpoints
  // Notes/Posts endpoints (using JSONPlaceholder posts as example)
  static const String notes = '/posts';
  static String noteById(int id) => '/posts/$id';
  
  // User endpoints (if needed)
  static const String users = '/users';
  static String userById(int id) => '/users/$id';
  
  // Comments endpoints (can be used for note comments)
  static const String comments = '/comments';
  static String commentsByNote(int noteId) => '/posts/$noteId/comments';

  // Helper method to build full URL
  static String fullUrl(String endpoint) => baseUrl + endpoint;
}
