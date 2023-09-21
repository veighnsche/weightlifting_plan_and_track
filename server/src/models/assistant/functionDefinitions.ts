import { FunctionCallInfo, FunctionCallProperty } from "./functionCallUtils";

export const functionDefinitions: FunctionCallInfo[] = [
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

export const functionCallMetadataProperties: Record<string, FunctionCallProperty> = {
  content: {
    type: "string",
    description: "From the assistants perspective, what is the purpose of this function call? (eg. Adding squats to your [exercise list/workout plan])",
  },
  callback: {
    type: "string",
    description: "What to do with the result of the function call. (eg. If the exercise is already in the database then edit it, otherwise add it to the database)",
  },
};

export const functionCallInfosWithMetadata: FunctionCallInfo[] = functionDefinitions.map((functionCallInfo) => {
  // Merge the original properties with the metadata properties
  const mergedProperties = {
    ...functionCallMetadataProperties,
    ...functionCallInfo.parameters.properties,
  };

  // Merge the original required properties with the metadata properties
  const mergedRequired = [
    "content",
    ...functionCallInfo.parameters.required,
  ];

  // Return the updated function call info with the merged properties
  return {
    ...functionCallInfo,
    parameters: {
      ...functionCallInfo.parameters,
      properties: mergedProperties,
      required: mergedRequired,
    },
  };
});
