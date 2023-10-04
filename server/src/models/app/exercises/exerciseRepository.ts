import { dataSourceHasura } from "../../../services/databaseHasura";
import { ExerciseEntity } from "./exerciseEntity";  // Assuming you have a similar structure for exercises

const exerciseRepository = dataSourceHasura.getRepository(ExerciseEntity);

const findExistingExercise = async (user_uid: string, exercise_id?: string) => {
  return exercise_id
    ? exerciseRepository.findOneBy({ user_uid, exercise_id })
    : null;
};

const mergeWithExistingOrNew = (existingExercise: ExerciseEntity | null, data: Partial<ExerciseEntity>) => {
  if (existingExercise) {
    return exerciseRepository.merge(existingExercise, data);
  } else {
    return exerciseRepository.create(data);
  }
};

export const upsertExercise = async (exercise: Partial<ExerciseEntity> & { user_uid: string }): Promise<ExerciseEntity> => {
  const existingExercise = await findExistingExercise(exercise.user_uid, exercise.exercise_id);
  const finalExercise = mergeWithExistingOrNew(existingExercise, exercise);
  return exerciseRepository.save(finalExercise);
};
