import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { ExerciseEntity } from "../exercises/exerciseEntity";
import { SetReferenceEntity } from "../setReferences/setReferenceEntity";
import { WorkoutEntity } from "../workouts/workoutEntity";

@Entity("wpt_workout_exercises")
export class WorkoutExerciseEntity {
  @PrimaryGeneratedColumn("uuid")
  workout_exercise_id!: string;

  @Column()
  workout_id!: string;

  @Column()
  exercise_id!: string;

  @Column({ type: "integer", nullable: true })
  order_number?: number;

  @Column({ nullable: true })
  note?: string;

  @Column({ default: false })
  is_archived!: boolean;

  @ManyToOne(() => WorkoutEntity, workout => workout.workoutExercises)
  @JoinColumn({ name: "workout_id" })
  workout!: WorkoutEntity;

  @ManyToOne(() => ExerciseEntity, exercise => exercise.workoutExercises)
  @JoinColumn({ name: "exercise_id" })
  exercise!: ExerciseEntity;

  @OneToMany(() => SetReferenceEntity, setReference => setReference.workoutExercise)
  setReferences!: SetReferenceEntity[];
}