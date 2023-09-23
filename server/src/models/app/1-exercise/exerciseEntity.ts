import { Column, Entity, JoinTable, ManyToMany, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { CompletedSetEntity } from "../9-completedSet/completedSetEntity";
import { SetEntity } from "../2-set/setEntity";
import { WorkoutEntity } from "../0-workout/workoutEntity";

@Entity("wpt-exercises")
export class ExerciseEntity {
  @PrimaryGeneratedColumn({ name: "exercise_id" })
  exerciseId!: number;

  @Column({ name: "user_uid" })
  userUid!: string;

  @Column({ type: "varchar", length: 255 })
  name!: string;

  @Column({ type: "text", nullable: true })
  note?: string;

  @ManyToMany(() => WorkoutEntity, workout => workout.exercises)
  @JoinTable({
    name: "wpt-workout_exercise_join",
    joinColumn: {
      name: "exercise_id",
      referencedColumnName: "exerciseId",
    },
    inverseJoinColumn: {
      name: "workout_id",
      referencedColumnName: "workoutId",
    },
  })
  workouts!: WorkoutEntity[];

  @OneToMany(() => SetEntity, set => set.exercise)
  sets!: SetEntity[];

  @OneToMany(() => CompletedSetEntity, completedSet => completedSet.exercise)
  completedSets!: CompletedSetEntity[];
}