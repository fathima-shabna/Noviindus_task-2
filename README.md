# Frijo - Social Video Feed Application

A premium Flutter social media application developed as part of the Noviindus technical task. This app features a dynamic video feed, category-based filtering, and a robust content upload system.

## 🚀 Key Features

### 1. Home Feed
- **Dynamic Video Feed**: Seamless playback of social content with portrait aspect ratios.
- **Category Filtering**: Interactive category chips to filter feeds in real-time.
- **Pull-to-Refresh**: Easily reload content to fetch the latest updates.

### 2. Content Creation (Add Feed)
- **Video Upload**: Multi-part video upload support (MP4 required).
- **Video Validation**: Automatic checks for format and duration (max 5 minutes).
- **Thumbnail Support**: Gallery selection for custom post thumbnails.
- **Success Handling**: Automatic field clearing and state reset upon successful upload.

### 3. My Feeds
- **Personal Content Management**: View all personal uploads in a dedicated screen.
- **Delete Management**: Delete posts with a confirmation dialog and real-time UI updates.
- **Empty State Refresh**: Refined pull-to-refresh logic that works even when no feeds are present.

## 🛠️ Technology Stack
- **Framework**: [Flutter](https://flutter.dev/) (Material 3)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [Dio](https://pub.dev/packages/dio) with Interceptors for Auth
- **UI Components**: Google Fonts (Montserrat), Custom Video Players, Dashed UI Painters.
- **Storage**: SharedPreferences for auth tokens.

## 📂 Architecture
The project follows a clean MVC-inspired architecture:
- `lib/data`: Models, Services (API), and Data Sources.
- `lib/providers`: State management modules for each feature area.
- `lib/presentation`: UI layer containing screens and custom widgets.
- `lib/core`: App constants, theme configuration, and global utilities.

## 🛠️ Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/fathima-shabna/Noviindus_task-2.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

## ✨ Recent Improvements
- ✅ Fixed "Undefined Class Feed" compilation error.
- ✅ Implemented automatic field resetting after successful upload.
- ✅ Added functional category selection and API filtering on the Home screen.
- ✅ Integrated Pull-to-Refresh on both Home and My Feed screens.
