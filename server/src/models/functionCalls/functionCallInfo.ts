import { FunctionCallInfo } from "./functionCallUtils";

export const functionCallInfos: FunctionCallInfo[] = [
  {
    name: "findExercise",
    description: "Locate a specific workout.",
    parameters: {
      type: "object",
      properties: {
        exerciseName: {
          type: "string",
          description: "Name of the workout, e.g., Deadlift.",
        },
        muscleGroup: {
          type: "string",
          enum: ["chest", "legs", "back", "arms", "shoulders", "core"],
          description: "Primary muscle targeted.",
        },
      },
      required: ["exercise_name"],
    },
  },
  {
    name: "exerciseActions",
    description: "Manage workout details.",
    parameters: {
      type: "object",
      properties: {
        action: {
          type: "string",
          enum: ["create", "read", "update", "delete"],
          description: "Desired operation.",
        },
        exerciseID: {
          type: "integer",
          description: "Unique workout ID. Required for read, update, and delete.",
        },
        exerciseName: {
          type: "string",
          description: "Workout name. Needed for adding or modifying.",
        },
        muscleGroup: {
          type: "string",
          enum: ["chest", "legs", "back", "arms", "shoulders", "core"],
          description: "Primary muscle involved. Needed for adding or modifying.",
        },
        description: {
          type: "string",
          description: "Short description. Optional for adding or modifying.",
        },
      },
      required: ["action"],
    },
  },
];
