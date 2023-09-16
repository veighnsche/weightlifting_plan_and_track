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

## Chat Feature

Welcome to the chat feature of the Weightlifting Plan and Track application. This document provides a detailed breakdown of the chat functionality, ensuring a seamless interaction between users, the assistant, and the system.

### Overview

The chat feature facilitates real-time interactions, allowing users to communicate with an assistant. Messages within the chat can have one of three roles: user, assistant, or system. The flow is designed to be dynamic, with the assistant capable of making function calls that can lead to iterative interactions until a final message is delivered. Crucially, for operations that can create, update, or delete data, the user has the ability to confirm or adjust the function call arguments, ensuring user oversight.

### Databases

- **PostgreSQL Database**: Manages the association between `userIDs` and `conversationIDs`.
- **Firestore**: Stores the chat messages under their respective `conversationID`.

### Data Models

**ChatConversation**:
- `conversationID`: A unique identifier for the conversation.
- `messages`: An array containing individual ChatMessage objects representing the flow of the conversation.

**ChatMessage**:
- `role`: Specifies the sender's role in the conversation. Possible values are:
    - user: Represents the end-user or client.
    - assistant: Represents the AI assistant or bot.
    - system: Represents system-generated messages or notifications.
- `content`: The actual text of the message. For the 'system' role, this might contain data or system-specific information.
- `functionCall`: (Optional) An object present in assistant messages that might call a specific function.
    - `functionName`: The name of the function being called (e.g., OnlyContent, CreateExercise, etc.).
    - `parameters`: Parameters required for the function, provided as a JSON stringified format.
    - `callback`: (Optional) A description or instruction for the next action to be taken after the function call.
    - `status`: Indicates the status of the function call. Possible values are:
        - pending: The function call has been made, but the status is yet to be determined.
        - expired: Another function call has been made, rendering this one invalid.
        - approved: The function call was successful and approved.
        - rejected: The function call was unsuccessful or denied.
        - none: Used for Read* functions & OnlyContent where no specific status is required.

### Chat Flow

1. **Client Initialization**:
    - On pressing "New", a fresh chat screen is presented without any associated `conversationID`.
    - Users compose their initial message.

2. **User Interaction**:
    - Upon sending the first message:
        - The message is transmitted to the backend without a `conversationID`, signaling the initiation of a new conversation.

3. **Backend Processing**:
    - For messages without a `conversationID`:
        - A new `conversationID` is generated.
        - The message is associated with this `conversationID` and stored in the Firestore.
        - The `conversationID` is relayed back to the client.

4. **Client Connection to Real-time Database**:
    - Post-receipt of a `conversationID`, the client establishes a connection to the Firestore using this ID, ensuring real-time updates for the specific conversation.

5. **Assistant Interaction**:
    - The backend communicates the message to the assistant.
    - The assistant processes the message, returning a function call accompanied by metadata.
    - The `functionCallStatus` in the metadata is checked:
        - If "valid", the client displays the function call for user confirmation or adjustment.
        - If "invalid" or "replaced", the function call is either disabled on the client side or replaced with the new valid function call.

6. **User Approval**:
    - For function calls that can create, update, or delete data:
        - The user reviews the function call and its parameters.
        - Upon user approval, the client sends the approved function call and its arguments to the backend.

7. **Backend Processing & System Interaction**:
    - The backend invokes the approved function.
    - The system then adds relevant data to the conversation based on the function's outcome.
    - If the function call has an associated `callback` in its metadata:
        - The assistant is invoked again with the description from the callback, along with all previous messages.
    - This iterative process persists until a conclusive message is determined.

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [TypeORM Documentation](https://typeorm.io/#/)
- [TypeORM Repository](https://github.com/typeorm/typeorm)