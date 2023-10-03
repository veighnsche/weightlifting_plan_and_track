import { dataSourceHasura } from "../../../services/databaseHasura";
import { WorkoutEntity } from "./workoutEntity";

const workoutRepository = dataSourceHasura.getRepository(WorkoutEntity);

const findExistingWorkout = async (user_uid: string, workout_id?: string) => {
  return workout_id
    ? workoutRepository.findOneBy({ user_uid, workout_id })
    : null;
};

const mergeWithExistingOrNew = (existingWorkout: WorkoutEntity | null, data: Partial<WorkoutEntity>) => {
  if (existingWorkout) {
    return workoutRepository.merge(existingWorkout, data);
  } else {
    return workoutRepository.create(data);
  }
};

export const upsertWorkout = async (workout: Partial<WorkoutEntity> & { user_uid: string }): Promise<WorkoutEntity> => {
  const existingWorkout = await findExistingWorkout(workout.user_uid, workout.workout_id);
  const finalWorkout = mergeWithExistingOrNew(existingWorkout, workout);
  return workoutRepository.save(finalWorkout);
};
