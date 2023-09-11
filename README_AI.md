# Weightlifting Plan and Track

## Overview

This project provides a chat application with Firebase authentication and a backend server for handling real-time chat using Socket.io.

## Frontend (`ui/lib` folder)

### Firebase Configuration (`firebase_options.dart`)

- Contains default Firebase options for different platforms (Android, iOS).
- Provides a way to initialize Firebase with the default options for the current platform.

### Main Application (`main.dart`)

- Initializes Firebase.
- Contains the main `MyApp` widget which listens to Firebase authentication state changes.
- Displays a login screen if the user is not authenticated and a chat screen if the user is authenticated.

### Chat Screen (`screens/chat.dart`)

- Provides a chat interface where users can send and receive messages.
- Messages are displayed based on their role (user, assistant, system).

### Authentication Service (`services/auth_service.dart`)

- Provides methods for signing in with Google and signing out.
- Uses Firebase authentication and Google Sign-In.

### Socket Service (`services/socket_service.dart`)

- Provides methods to connect and disconnect from a Socket.io server.
- Uses the user's Firebase token for authentication with the server.

## Backend (`server` folder)

### Dependencies (`package.json`)

- Uses Express for the server framework.
- Uses Socket.io for real-time communication.
- Uses Firebase Admin SDK for Firebase authentication.
- Other dependencies include `cors`, `dotenv`, `express-rate-limit`, and more.

### Server Entry Point (`src/index.ts`)

- Sets up an Express server and a Socket.io server.
- Initializes Firebase Admin SDK.
- Uses middleware for CORS and rate limiting.
- Authenticates Socket.io connections using Firebase tokens.
- Listens for incoming Socket.io connections and logs user details.
