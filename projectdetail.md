# Nice Today Weather
**Goal:** Generate a Flutter application named "Nice Today Weather" with robust features, clean architecture, and a polished UI/UX.

**Key Features:**

*   **User Authentication:**
    *   User registration and login using Google Sign-In with Firebase Authentication.
    *   Secure user data management.
*   **Location-Based Weather:**
    *   Automatically detect the user's current location and display relevant weather information.
    *   Accurate and reliable weather data from a reputable weather API (e.g., OpenWeatherMap, WeatherAPI).
*   **Location Search and Focus:**
    *   Allow users to search for specific locations (cities, regions, etc.).
    *   Display weather information for the selected location.
    *   Implement a mechanism to save/manage favorite locations.
*   **Data Persistence:**
    *   Use Hive for local caching of weather data and user preferences (e.g., units, favorite locations).
*   **State Management:**
    *   Implement BLoC (Business Logic Component) for state management, ensuring predictable and testable code.
*   **UI/UX:**
    *   Follow Material Design guidelines for a consistent and intuitive user interface.
    *   Implement responsive design to ensure optimal viewing on various screen sizes (phones, tablets, desktops).
    *   Visually appealing weather display with relevant icons and animations.
*   **Architecture:**
    *   Adhere to Clean Architecture principles (separation of concerns, dependency inversion).
    *   Structure the project into distinct layers (presentation, domain, data, data sources).

**Technical Requirements:**

*   **Framework:** Flutter
*   **Backend:** Firebase (Authentication, Firestore - potentially for user data if needed beyond auth)
*   **Local Database:** Hive
*   **State Management:** BLoC
*   **UI Library:** Material Design
*   **Weather API:** Integrate with a suitable weather API (e.g., OpenWeatherMap, WeatherAPI). Specify which API if possible.
*   **Dependency Injection:** Use a suitable DI solution (e.g. get_it, provider).

**Specific Instructions for Code Generation:**

*   Generate clear and well-commented code.
*   Implement error handling and appropriate user feedback (e.g., loading indicators, error messages).
*   Prioritize code readability and maintainability.
*   Include necessary dependencies in the `pubspec.yaml` file.
*   Provide clear instructions on setting up Firebase and the chosen weather API.
*   Structure the project with clear folders and file names following clean architecture principles (e.g. core, features, data).

**Example UI Elements (Optional):**

*   Consider a main screen with current weather conditions (temperature, icon, description), a forecast section, and a location search bar.
*   Use appropriate icons and animations to represent weather conditions.

**Deliverables:**

*   A fully functional Flutter project that meets the specified requirements.
*   Clear documentation or comments within the code explaining the implementation.

**Focus on generating the core structure and key features first. Don't worry about pixel-perfect UI initially. Prioritize functionality and architecture.**

This detailed prompt should provide Cursor AI with enough information to generate a solid foundation for the "Nice Today Weather" app. Remember to iterate and refine the generated code as needed.