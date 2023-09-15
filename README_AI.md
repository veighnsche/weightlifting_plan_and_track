# README_AI.md for weightlifting_plan_and_track

## Overview

This repository contains the codebase for a weightlifting planning and tracking application. It consists of a backend server and a Flutter-based frontend UI.

## Server

### Initialization

- The server is set up using Express and Socket.io.
- Firebase is utilized for authentication.
- Middleware for CORS and rate limiting is applied.
- Socket.io connections are authenticated using Firebase tokens.

### User Entity

- The user entity is structured with the following fields:
    - `userId`: A unique identifier for the user.
    - `uid`: Firebase UID.
    - `name`: User's name.
    - `age`: User's age.
    - `weight`: User's weight (in kg).
    - `height`: User's height (in cm).
    - `gymDescription`: An optional description of the user's gym.

### User Events

- The server listens for an "upsert-user" event to handle both the creation and updating of user data.
- Upon receiving this event, the server updates the user data and emits a "user-connected" event with an "onboarded" status.

### Dependencies

- Express, Socket.io, TypeORM, Firebase Admin, and other essential libraries.
- Development scripts include starting the server, building the TypeScript code, and running the application in Docker.

## UI

### Onboarding Screen

- The onboarding screen collects user details such as age, weight, height, and an optional gym description.
- The user's name is fetched from Firebase Auth.
- Once the user submits the form, the data is sent to the server using the socket service's `upsertUser` method.

### Authentication Service

- Provides methods for signing in with Google and signing out.
- Uses Firebase Auth and Google Sign-In for authentication.
- Can fetch the current user's Firebase token.

### Socket Service

- Provides methods to connect and disconnect from a Socket.io server.
- Uses the user's Firebase token for authentication with the server.
- Can send user messages and upsert user data to the server.

### Dependencies

- Firebase Core, Firebase Auth, Google Sign-In, Socket.io Client, and other essential Flutter packages.

## Development and Deployment

- Backend: Use the scripts in `package.json` for development and deployment. For Docker deployment, use the `docker` script.
- UI: Follow Flutter's standard development and deployment procedures. Refer to the links provided in the UI's `README.md` for more resources.

## Token Renewal and Error Handling

### Token Renewal:

Firebase ID tokens have a limited lifespan for security reasons. To ensure uninterrupted user experience:

1. **Frontend**:
  - Monitor the expiration time of the Firebase ID token.
  - As the token nears its expiration, automatically request a fresh token from Firebase.
  - Replace the old token with the new one in subsequent requests to the backend.

2. **Backend**:
  - Before processing any request that requires authentication, verify the token's validity.
  - If the token is nearing its expiration, consider sending a preemptive response to the frontend, suggesting a token renewal.

### Error Handling:

1. **Frontend**:
  - If the backend indicates an expired token, either:
    - Prompt the user to re-authenticate.
    - Or, automatically refresh the token if the user session is still active.
  - Display user-friendly error messages for any authentication-related issues.

2. **Backend**:
  - When verifying the token, if it's expired, respond with a specific error code/message indicating the token expiration.
  - Log any authentication errors for monitoring and debugging purposes.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Socket.io Documentation](https://socket.io/docs/v4)
- [Socket.io Repository](https://github.com/socketio/socket.io)
- [TypeORM Documentation](https://typeorm.io/#/)
- [TypeORM Repository](https://github.com/typeorm/typeorm)