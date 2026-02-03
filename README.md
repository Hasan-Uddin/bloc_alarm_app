# Alarm App

A production-ready Flutter application built with Clean Architecture, BLoC pattern, and offline-first approach for managing location-based alarms.

## 🎯 Project Overview

**Alarm App** is a sophisticated alarm management application that demonstrates:
- **Clean Architecture** with clear separation of concerns (Data, Domain, Presentation layers)
- **BLoC Pattern** for predictable state management
- **Dependency Injection** using GetIt
- **Offline-First** architecture with Hive local storage
- **Location Services** integration with GPS and geocoding
- **Background Services** for alarm notifications
- **Industrial Best Practices** following SOLID principles

## ✨ Features Included

- ✅ Beautiful onboarding flow with video support
- ✅ Location-based alarm system
- ✅ GPS location tracking and address geocoding
- ✅ CRUD operations for alarms
- ✅ Active/Inactive alarm states
- ✅ Background alarm notifications
- ✅ Persistent storage with Hive
- ✅ Comprehensive error handling and logging

## 📁 Project Structure
lib/
├── common_widgets/ # Reusable UI components
│ ├── custom_button.dart
│ └── linear_grad.dart
├── constants/ # App-wide constants
│ ├── app_colors.dart
│ ├── app_strings.dart
│ └── app_routes.dart
├── core/ # Core functionality
│ ├── di/ # Dependency injection (GetIt)
│ ├── error/ # Error handling
│ │ ├── failures.dart
│ │ └── exceptions.dart
│ ├── storage/ # Local storage service (Hive)
│ ├── usecases/ # Base use case classes
│ └── services/ # Core services
├── features/ # Feature modules
│ ├── onboarding/
│ │ ├── data/ # Data sources, models, repositories
│ │ ├── domain/ # Entities, use cases, interfaces
│ │ └── presentation/ # BLoCs, pages, widgets
│ ├── location/
│ │ ├── data/
│ │ │ ├── models/ # LocationModel with Hive adapter
│ │ │ ├── datasources/ # Location local data source
│ │ │ └── repositories/ # Repository implementation
│ │ ├── domain/
│ │ │ ├── entities/ # LocationEntity
│ │ │ ├── repositories/ # Repository interface
│ │ │ └── usecases/ # Location use cases
│ │ │ ├── get_current_location.dart
│ │ │ ├── get_saved_location.dart
│ │ │ ├── save_location.dart
│ │ │ └── delete_location.dart
│ │ └── presentation/
│ │ ├── bloc/ # LocationBloc
│ │ ├── pages/ # Location screen
│ │ └── widgets/ # Location widgets
│ ├── alarms/
│ │ ├── data/
│ │ │ ├── models/ # AlarmModel with Hive adapter
│ │ │ ├── datasources/ # Alarm local data source
│ │ │ └── repositories/ # Repository implementation
│ │ ├── domain/
│ │ │ ├── entities/ # AlarmEntity
│ │ │ ├── repositories/ # Repository interface
│ │ │ └── usecases/ # Alarm use cases
│ │ │ ├── get_alarms.dart
│ │ │ ├── add_alarm.dart
│ │ │ ├── delete_alarm.dart
│ │ │ └── toggle_alarm.dart
│ │ └── presentation/
│ │ ├── bloc/ # AlarmBloc
│ │ ├── pages/ # Alarm home page
│ └──── widgets/ # Alarm widgets
├── helpers/ # Utility functions
│ ├── logger.dart # Structured logging
│ └── snackbar_helper.dart
├── networks/ # Network layer
│ ├── dio_client.dart
│ └── network_info.dart
├── app.dart # Root app widget
├── route.dart # App route
└── main.dart # App entry point


## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.10.8)
- Dart SDK (>=3.10.8)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Hasan-Uddin/bloc_alarm_app.git
   cd alarm_app

3. **Generate Hive type adapters:**
   ```bash
   flutter pub run build_runner build
   ```
   This generates the required Hive adapters (e.g., `note_model.g.dart`)

4. **Run the app:**
   ```bash
   flutter run
   ```

### First Run
On first launch, you'll see:
1. **Onboarding screens** (3 screens) - shown only once


## 🏗️ Architecture

### Clean Architecture Layers

#### 1. **Data Layer**
- **Models**: Data transfer objects with JSON/Hive serialization
- **Data Sources**: Local (Hive) and Remote (API) data sources
- **Repositories**: Implementation of domain repository interfaces

#### 2. **Domain Layer**
- **Entities**: Pure business objects
- **Use Cases**: Single-responsibility business logic
- **Repository Interfaces**: Contracts for data operations

#### 3. **Presentation Layer**
- **BLoC**: State management with events and states
- **Pages**: Screen-level widgets
- **Widgets**: Reusable UI components

### Data Flow
```
UI → BLoC (Event) → Use Case → Repository → Data Source → API/Hive
                                    ↓
UI ← BLoC (State) ← Use Case ← Repository
```

## 🔧 Key Technologies

| Technology | Purpose |
|-----------|---------|
| **flutter_bloc** | State management with BLoC pattern |
| **get_it** | Dependency injection / service locator |
| **hive** | Fast, lightweight local database |
| **dio** | HTTP client for API calls |
| **connectivity_plus** | Network connectivity detection |
| **equatable** | Value equality for models |
| **dartz** | Functional programming (Either for error handling) |



## 📦 Dependencies

See `pubspec.yaml` for the complete list of dependencies.

## 🎨 UI Components

Reusable widgets available in `lib/common_widgets/`:
- **CustomButton**: Loading state, outlined variant, icon support
- **CustomTextField**: Validation, formatting, styling options
- **LoadingWidget**: Customizable loaders
- **ErrorDisplayWidget**: Error display with retry
- **EmptyStateWidget**: Empty state with action button


## 🔐 Best Practices Implemented

- ✅ **Separation of Concerns**: Each layer has a single responsibility
- ✅ **Dependency Inversion**: Layers depend on abstractions
- ✅ **Single Responsibility**: Classes do one thing well
- ✅ **Open/Closed**: Open for extension, closed for modification
- ✅ **Offline-First**: Local caching with API sync
- ✅ **Error Handling**: Centralized with Either pattern
- ✅ **Logging**: Structured logging throughout
- ✅ **Type Safety**: Strong typing with Dart

## 📚 Learning Resources

- [Flutter Clean Architecture Guide](https://resocoder.com/flutter-clean-architecture-tdd/)
- [BLoC Pattern Documentation](https://bloclibrary.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)

## 🤝 Contributing

This is a template project. Feel free to customize it for your needs!

## 📄 License

This template is free to use for any purpose.