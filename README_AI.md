# README_AI.md for weightlifting_plan_and_track

## Overview

This repository houses the codebase for the weightlifting planning and tracking application. It's a harmonious blend of a robust backend server and a dynamic Flutter-based frontend UI.

## Server

### Initialization

- The server is crafted using Express.
- Firebase stands as the guardian of authentication.
- Middleware for CORS and rate limiting ensures a seamless and secure user experience.

### User Entity

- The user entity is a tapestry of the following fields:
    - `userId`: A unique beacon identifying the user.
    - `uid`: Firebase UID.
    - `name`: The name of the user, echoing their identity.
    - `age`: The age of the user, representing their journey in years.
    - `weight`: The user's weight, measured in the universal metric of kg.
    - `height`: The stature of the user, captured in cm.
    - `gymDescription`: A canvas for users to paint a description of their gym.

### User Events

- The server is ever-vigilant, listening for an "upsert-user" event. This event is the key to both the creation and updating of user data.
- Upon receiving this beacon, the server rejuvenates the user data and heralds a "user-connected" event with an "onboarded" status.

### Dependencies

- The server's compass is set with Express, TypeORM, Firebase Admin, and other essential libraries that form its backbone.
- Development scripts are the guiding stars, including starting the server, transmuting the TypeScript code, and running the application in the embrace of Docker.

## UI

### Onboarding Screen

- The onboarding screen is a gateway, collecting user details like age, weight, height, and an optional gym description.
- The user's name is a treasure fetched from Firebase Auth.
- Upon the user's decree (form submission), the data embarks on a journey to the server.

### Authentication Service

- This service is the sentinel, offering methods for signing in with Google and signing out.
- It harnesses the power of Firebase Auth and Google Sign-In for authentication.
- It's equipped to fetch the current user's Firebase token, ensuring a seamless experience.

### Chat Capabilities

- The chat capabilities are powered by either Firestore or the Real-Time Database, ensuring real-time interactions and a seamless chat experience.
- The user and gym planning and tracking data remain anchored in PostgreSQL, ensuring depth and clarity.

### Dependencies

- The UI's compass points to Firebase Core, Firebase Auth, Google Sign-In, and other essential Flutter packages that form its foundation.

## Development and Deployment

- **Backend**: The scripts in `package.json` are the guiding lights for development and deployment. For those who seek the embrace of Docker, the `docker` script is the path.
- **UI**: The path is illuminated by Flutter's standard development and deployment procedures. For those who seek further enlightenment, the links provided in the UI's `README.md` are the guiding stars.

## Token Renewal and Error Handling

### Token Renewal:

Firebase ID tokens are ephemeral, ensuring security. To guarantee an uninterrupted odyssey:

1. **Frontend**:
- Be ever-watchful of the expiration time of the Firebase ID token.
- As the token approaches its twilight, seek a fresh token from Firebase.
- Let the new token replace the old, ensuring a seamless journey to the backend.

2. **Backend**:
- Before embarking on any request that demands authentication, verify the token's authenticity.
- If the token's twilight is near, send a beacon to the frontend, suggesting a token renewal.

### Error Handling:

1. **Frontend**:
- If the backend sends a signal of an expired token, either:
    - Summon the user to re-authenticate.
    - Or, rejuvenate the token if the user's session is still vibrant.
- Illuminate the path with user-friendly messages for any authentication-related detours.

2. **Backend**:
- During the token's verification, if it's found to be in its twilight, respond with a beacon indicating the token's end.
- Chronicle any authentication detours for future voyages.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [TypeORM Documentation](https://typeorm.io/#/)
- [TypeORM Repository](https://github.com/typeorm/typeorm)