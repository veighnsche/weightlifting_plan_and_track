import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { SetDetailEntity } from "../setDetails/setDetailEntity";
import { WorkoutExerciseEntity } from "../workoutExercises/workoutExerciseEntity";

@Entity("wpt_set_references")
export class SetReferenceEntity {
  @PrimaryGeneratedColumn("uuid")
  set_reference_id!: string;

  @Column()
  workout_exercise_id!: string;

  @Column({ type: "integer" })
  order_number!: number;

  @Column({ nullable: true })
  note?: string;

  @Column({ default: false })
  is_archived!: boolean;

  @ManyToOne(() => WorkoutExerciseEntity, workoutExercise => workoutExercise.setReferences)
  @JoinColumn({ name: "workout_exercise_id" })
  workoutExercise!: WorkoutExerciseEntity;

  @OneToMany(() => SetDetailEntity, setDetail => setDetail.setReference)
  setDetails!: SetDetailEntity[];
}