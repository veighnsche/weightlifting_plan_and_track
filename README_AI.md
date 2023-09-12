# Weightlifting Plan and Track: Developer Onboarding 🌹📈🔥

## **Project Overview**:
A platform to plan and track weightlifting activities with real-time chat, workout recommendations, and user onboarding.

## **Technical Stack**:
- **Frontend**: Flutter with Firebase and Google Sign-In integrations.
- **Backend**: Node.js with [Socket.io](https://github.com/socketio/socket.io) and [TypeORM](https://github.com/typeorm/typeorm).
- **Database**: PostgreSQL.
- **Authentication**: Firebase.

## **Repository Structure**:
- `ui`: Flutter frontend.
    - 🔍 **Main (`lib/main.dart`)**: App initialization.
    - 🔍 **Onboarding (`lib/screens/onboarding_screen.dart`)**: User detail collection.
    - 🔍 **Chat (`lib/screens/chat_screen.dart`)**: Real-time chat interface.
    - **Socket Service (`lib/services/socket_service.dart`)**: Socket.io connection management.

- `server`: Node.js backend.
    - 🔍 **Initialization (`src/index.ts`)**: Server setup and Firebase configuration.
    - 🔍 **Socket Events (`src/models/socketEvents.ts`)**: Real-time event definitions.
    - **User Entity (`src/models/users/userEnitity.ts`)**: User database structure.
    - **Database Service (`src/services/database.ts`)**: PostgreSQL connection.

## **Development Setup**:
1. Clone the repository.
2. Backend: `npm install`.
3. Frontend: Follow Flutter setup guidelines.
4. Initialize PostgreSQL with Docker.

## **Coding Standards**:
Dart style for frontend and ES6 for backend. Clear and descriptive commit messages.

## **Resources**:
- **Project Repository**: [GitHub Link](https://github.com/veighnsche/weightlifting_plan_and_track)
- **Socket.io**: [GitHub Repository](https://github.com/socketio/socket.io)
- **TypeORM**: [GitHub Repository](https://github.com/typeorm/typeorm)

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

### Server Entry Point (`src/socketEvents.ts`)

- Sets up an Express server and a Socket.io server.
- Initializes Firebase Admin SDK.
- Uses middleware for CORS and rate limiting.
- Authenticates Socket.io connections using Firebase tokens.
- Listens for incoming Socket.io connections and logs user details.
