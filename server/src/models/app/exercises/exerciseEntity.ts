import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { WorkoutExerciseEntity } from "../workoutExercises/workoutExerciseEntity";

@Entity("wpt_exercises")
export class ExerciseEntity {
  @PrimaryGeneratedColumn("uuid")
  exercise_id!: string;

  @Column()
  user_uid!: string;

  @Column()
  name!: string;

  @Column({ nullable: true })
  note?: string;

  @Column({ default: false })
  is_archived!: boolean;

  @OneToMany(() => WorkoutExerciseEntity, workoutExercise => workoutExercise.exercise)
  workoutExercises!: WorkoutExerciseEntity[];
}