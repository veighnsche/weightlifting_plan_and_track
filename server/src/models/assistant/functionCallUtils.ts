export interface FunctionCallInfo {
  name: string;
  description: string;
  parameters: {
    type: string;
    properties: Record<string, FunctionCallProperty>;
    required: string[];
  };
}

export interface FunctionCallProperty {
  type: string;
  description?: string;
  enum?: string[];
}