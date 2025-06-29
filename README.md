# AIInsights

AIInsights is a cross-platform AI-powered learning and course creation platform. It features a Flutter-based frontend and a Node.js backend, enabling users to generate, manage, and launch courses with the help of AI tools.

## API Setup

### Frontend (Flutter)

For the Flutter frontend to work with AI and backend features, you must set your API keys and backend endpoints:

- Open `lib/api/api.dart` or the relevant config files.
- Add your API keys (e.g., for Gemini, Firebase, etc.).
- Set your backend URLs as needed.

### Backend (Node.js)

For the backend to connect to databases, cloud services, or external APIs:

- Open `aiinsights_backend/config/` and review files like `db.js` and `schema.js`.
- Set your database connection strings, API keys, and any other required environment variables.
- You may use a `.env` file for sensitive configuration (make sure to add `.env` to `.gitignore`).

## Features

- AI-powered image and content generation
- User authentication (login/signup)
- Course creation and management
- Responsive UI for web, desktop, and mobile
- Backend API for data management

## Folder Structure

```
aiinsights/           # Flutter frontend
aiinsights_backend/   # Node.js backend
```

## Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (3.x or later)
- [Node.js](https://nodejs.org/) (16.x or later)
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html) (for macOS/iOS)

## Setup Instructions

### 1. Clone the Repository

```sh
git clone https://github.com/surajacharya12/aiinsights.git
cd aiinsights
```

### 2. Flutter Frontend Setup

```sh
cd aiinsights
flutter pub get
# For macOS/iOS:
cd macos && pod install && cd ..
# For web:
flutter run -d chrome
# For Android/iOS:
flutter run
```

### 3. Backend Setup

```sh
cd ../aiinsights_backend
npm install
node server.js
```

## Usage

- Run the backend server first (`node server.js` in `aiinsights_backend`)
- Run the Flutter app for your desired platform
- Access the app via emulator, device, or browser

## Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](LICENSE)
