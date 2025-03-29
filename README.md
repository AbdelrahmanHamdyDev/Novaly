# Novaly

Novaly ("Nova" means "new" in Latin) is a modern and responsive Flutter news app that delivers the latest headlines and allows users to search for and bookmark articles seamlessly.

The app is designed with a clean UI and optimized for performance using Riverpod for state management.

## Architecture

Novaly follows the **MVC (Model-View-Controller)** architectural pattern:

- **Model**: Contains the `Article` model, representing articles fetched from the API.
- **View**: Includes the three main screens (Home, Search, Bookmark) and a `widgets` folder that contains the `ArticleWidget`.
- **Controller**: Handles API calls using **Dio** and manages state with **Riverpod**.

## Features

### Home Screen

- Displays headline articles in a structured X-post layout.
- Uses a **SliverAppBar** containing the app name.
- **SliverList** displays the articles with a keep-alive feature to reduce excessive API calls.
- A **scroll-up button** appears when the user scrolls down, allowing easy navigation back to the top.

### Search Screen

- Similar to the Home Screen but includes a search bar in the **SliverAppBar**.
- Allows users to search for articles dynamically.
- Displays search results using **SliverList**.
- A **scroll-up button** appears when scrolling down for quick access to the top.

### Bookmark Screen

- Displays saved articles in a Tinder card-like swipeable layout.
- Articles can be bookmarked from any screen.

### Article Widget

- Displays the article **author**, **source**, **description**, and **image**.
- Includes a **bookmark button** to save articles.
- Includes a **share button** to share the article description and link to any app.

### Navigation

- Uses **PageView** for smooth page transitions.
- Integrated **BottomNavigationBar** to switch between Home, Search, and Bookmark screens seamlessly.

### Data Fetching

- Uses **Dio** to fetch news data from [NewsAPI.org](https://newsapi.org/).
- Optimized API calls to reduce redundant requests and improve performance.

### Additional Features

- **Native splash screen** for a seamless startup experience.
- **System color adaptation** using dynamic theming.
- **Responsive UI** for different screen sizes.
- **Environment variables** managed securely with `flutter_dotenv`.

## Tech Stack & Packages

```yaml
dio: ^5.8.0+1
url_launcher: ^6.3.1
share_plus: ^10.1.4
flutter_card_swiper: ^7.0.2
dynamic_color: ^1.7.0
flutter_screenutil: ^5.9.3
flutter_dotenv: ^5.2.1
shared_preferences: ^2.5.2
flutter_riverpod: ^2.6.1
flutter_native_splash: ^2.4.5
```

## Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/novaly.git
   ```
2. Navigate to the project directory:
   ```sh
   cd novaly
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Create a `.env` file in `lib` folder and add your API key:
   ```env
   NewsApi=your_newsapi_key
   ```
5. Run the app:
   ```sh
   flutter run
   ```

## Screenshots

### App Screens

<p align="center">
  <img src="screenshots/home_screen.png" width="30%">
  <img src="screenshots/search_screen.png" width="30%">
  <img src="screenshots/bookmark_screen.png" width="30%">
</p>

## Contributions

Feel free to fork the repository and submit pull requests for improvements.
