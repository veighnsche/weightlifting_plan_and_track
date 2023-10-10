import { FunctionDefinition, FunctionDefinitionProperty } from "./functionDefinitionUtils";

export const functionDefinitions: FunctionDefinition[] = [
  {
    name: "createWorkout",
    description: "Create a new workout.",
    parameters: {
      type: "object",
      properties: {
        name: {
          type: "string",
          description: "The name of the workout.",
        },
        dayOfWeek: {
          type: "number",
          description: "0 = Monday, 6 = Sunday. The day of the week that the workout should be performed on.",
        },
        description: {
          type: "string",
          description: "A brief overview of the workout.",
        },
      },
      required: ["name", "description"],
    },
  },
];

export const functionCallMetadataProperties: Record<string, FunctionDefinitionProperty> = {
  content: {
    type: "string",
    description: "From the assistants perspective, what is the purpose of this function call? (eg. Adding squats to your [exercise list/workout plan])",
  },
  callback: {
    type: "string",
    description: "What to do with the result of the function call. (eg. If the exercise is already in the database then edit it, otherwise add it to the database)",
  },
};

export const functionCallInfosWithMetadata: FunctionDefinition[] = functionDefinitions.map((functionCallInfo) => {
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
