import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { CompletedWorkoutEntity } from "../completedWorkouts/completedWorkoutEntity";
import { WorkoutExerciseEntity } from "../workoutExercises/workoutExerciseEntity";

@Entity('wpt_workouts')
export class WorkoutEntity {
  @PrimaryGeneratedColumn('uuid')
  workout_id!: string;

  @Column()
  user_uid!: string;

  @Column()
  name!: string;

  @Column({ type: 'integer', nullable: true })
  day_of_week?: number;

  @Column({ nullable: true })
  note?: string;

  @Column({ default: false })
  is_archived!: boolean;

  @OneToMany(() => WorkoutExerciseEntity, workoutExercise => workoutExercise.workout)
  workoutExercises!: WorkoutExerciseEntity[];

  @OneToMany(() => CompletedWorkoutEntity, completedWorkout => completedWorkout.workout)
  completedWorkouts!: CompletedWorkoutEntity[];
}

