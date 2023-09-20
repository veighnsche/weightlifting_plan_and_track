import { FunctionCallInfo } from "./functionCallUtils";

export const functionCallInfos: FunctionCallInfo[] = [
  {
    name: "findExercise",
    description: "Search for a specific workout by its name or the main muscle it targets.",
    parameters: {
      type: "object",
      properties: {
        exerciseName: {
          type: "string",
          description: "The workout's name, like 'Deadlift'.",
        },
        muscleGroup: {
          type: "string",
          enum: ["chest", "legs", "back", "arms", "shoulders", "core"],
          description: "The main muscle the workout focuses on.",
        },
      },
      required: ["exerciseName"],
    },
  },
  {
    name: "exerciseActions",
    description: "Handle the details of a workout, such as adding, viewing, updating, or removing it.",
    parameters: {
      type: "object",
      properties: {
        action: {
          type: "string",
          enum: ["add", "view", "change", "remove"],
          description: "What you want to do: add, view, change, or remove a workout.",
        },
        exerciseID: {
          type: "integer",
          description: "The unique ID for the workout. You'll need this to view, change, or remove a workout.",
        },
        exerciseName: {
          type: "string",
          description: "The name of the workout. Use this when you're adding or changing a workout.",
        },
        muscleGroup: {
          type: "string",
          enum: ["chest", "legs", "back", "arms", "shoulders", "core"],
          description: "The main muscle the workout targets. Use this when adding or changing a workout.",
        },
        description: {
          type: "string",
          description: "A brief overview of the workout. You can add this when you're adding or changing a workout, but it's optional.",
        },
      },
      required: ["action"],
    },
  },
];
