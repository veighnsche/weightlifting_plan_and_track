import { mergeResolvers, mergeTypeDefs } from "@graphql-tools/merge";
import { makeExecutableSchema } from "@graphql-tools/schema";
import { scr1WorkoutListResolvers, scr1WorkoutListTypeDefs } from "../graphql/screens/scr1WorkoutList";
import { scr2ExerciseListResolvers, scr2ExerciseListTypeDefs } from "../graphql/screens/scr2ExerciseList";
import { fetchHasuraSchema } from "./hasura";

export async function getSchema() {
  const hasuraSchema = await fetchHasuraSchema();
  return makeExecutableSchema({
    typeDefs: mergeTypeDefs([hasuraSchema, scr1WorkoutListTypeDefs, scr2ExerciseListTypeDefs]),
    resolvers: mergeResolvers([scr1WorkoutListResolvers, scr2ExerciseListResolvers]),
  });
}