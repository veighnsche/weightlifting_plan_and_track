const fs = require('fs');

// Read the contents of schema.graphql
const schema = fs.readFileSync('schema.graphql', 'utf8');

// Function to extract and replace content
function manipulateSchema(typeName, currentSchema) {
  const regex = new RegExp(`type ${typeName} \\{([\\s\\S]*?)\\}`, 'm');
  const match = currentSchema.match(regex);
  if (match) {
    const contentToCopy = match[1].trim();
    return currentSchema.replace(`type ${typeName.toLowerCase()}_root {`, `type ${typeName.toLowerCase()}_root {\n${contentToCopy}\n`);
  }
  return currentSchema;
}

// Manipulate the schema for Query, Mutation, and Subscription
let modifiedSchema = manipulateSchema('Query', schema);
modifiedSchema = manipulateSchema('Mutation', modifiedSchema);
modifiedSchema = manipulateSchema('Subscription', modifiedSchema);

// Replace the schema definitions
modifiedSchema = modifiedSchema.replace('query: Query', 'query: query_root');
modifiedSchema = modifiedSchema.replace('mutation: Mutation', 'mutation: mutation_root');
modifiedSchema = modifiedSchema.replace('subscription: Subscription', 'subscription: subscription_root');

// Save the modified contents back to schema.graphql
fs.writeFileSync('schema.graphql', modifiedSchema, 'utf8');
