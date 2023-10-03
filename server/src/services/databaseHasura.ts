import { DataSource, DataSourceOptions } from "typeorm";
import { CompletedSetEntity } from "../models/app/completedSets/completedSetEntity";
import { CompletedWorkoutEntity } from "../models/app/completedWorkouts/completedWorkoutEntity";
import { ExerciseEntity } from "../models/app/exercises/exerciseEntity";
import { SetDetailEntity } from "../models/app/setDetails/setDetailEntity";
import { SetReferenceEntity } from "../models/app/setReferences/setReferenceEntity";
import { WorkoutExerciseEntity } from "../models/app/workoutExercises/workoutExerciseEntity";
import {
  WorkoutEntity,

} from "../models/app/workouts/workoutEntity";

const options: DataSourceOptions = {
  type: "postgres",
  host: "localhost",
  port: 5433,
  username: "hasura_user",
  password: "b43X2y3ynSNq",
  database: "weightlifting_hasura_db",
  entities: [
    WorkoutEntity,
    ExerciseEntity,
    WorkoutExerciseEntity,
    SetDetailEntity,
    SetReferenceEntity,
    CompletedWorkoutEntity,
    CompletedSetEntity,
  ],
  synchronize: true,
};

export const dataSourceHasura = new DataSource(options);

export const connectDatabaseHasura = async () => {
  await dataSourceHasura.initialize();
  console.log("DB Hasura connected");
};
