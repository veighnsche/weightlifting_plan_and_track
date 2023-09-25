import { dataSource } from "../../../services/database";
import { WorkoutEntity } from "./workoutEntity";

const workoutRepository = dataSource.getRepository(WorkoutEntity);

export const findByUserUid = async (userUid: string): Promise<WorkoutEntity[]> => {
  return workoutRepository.findBy({ userUid });
}

export const findByWorkoutId = async (userUid: string, workoutId: number): Promise<WorkoutEntity | null> => {
  return workoutRepository.findOneBy({ userUid, workoutId });
};

export const upsertWorkout = async (userUid: string, workout: Partial<WorkoutEntity>): Promise<WorkoutEntity> => {
  const existingWorkout = workout.workoutId ? await findByWorkoutId(userUid, workout.workoutId) : null;

  let updatedWorkout: WorkoutEntity;

  if (existingWorkout) {
    updatedWorkout = workoutRepository.merge(existingWorkout, workout);
  } else {
    workout.userUid = userUid;  // Add the userUid when creating a new workout.
    updatedWorkout = workoutRepository.create(workout);
  }

  return workoutRepository.save(updatedWorkout);
};
