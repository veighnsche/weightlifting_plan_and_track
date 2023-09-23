import { Column, Entity, ManyToMany, PrimaryGeneratedColumn } from "typeorm";
import { ExerciseEntity } from "../1-exercise/exerciseEntity";

@Entity("wpt-workouts")
export class WorkoutEntity {
  @PrimaryGeneratedColumn({ name: "workout_id" })
  workoutId!: number;

  @Column({ name: "user_uid" })
  userUid!: string;

  @Column({ type: "varchar", length: 255 })
  name!: string;

  @Column({ name: "day_of_week", nullable: true })
  dayOfWeek?: number; // 0 = Monday, 1 = Tuesday, etc.

  @Column({ type: "text", nullable: true })
  note?: string;

  @ManyToMany(() => ExerciseEntity, exercise => exercise.workouts)
  exercises!: ExerciseEntity[];
}