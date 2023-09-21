export interface FunctionDefinition {
  name: string;
  description: string;
  parameters: {
    type: string;
    properties: Record<string, FunctionDefinitionProperty>;
    required: string[];
  };
}

export interface FunctionDefinitionProperty {
  type: string;
  description?: string;
  enum?: string[];
}