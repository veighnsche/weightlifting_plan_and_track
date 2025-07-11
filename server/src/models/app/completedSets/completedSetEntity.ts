import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { CompletedWorkoutEntity } from "../completedWorkouts/completedWorkoutEntity";
import { ExerciseEntity } from "../exercises/exerciseEntity";
import { SetDetailEntity } from "../setDetails/setDetailEntity";

@Entity("wpt_completed_sets")
export class CompletedSetEntity {
  @PrimaryGeneratedColumn("uuid")
  completed_set_id!: string;

  @Column({ nullable: true })
  completed_workout_id?: string;

  @Column({ nullable: true })
  set_detail_id?: string;

  @Column()
  exercise_id!: string;

  @CreateDateColumn()
  completed_at!: Date;

  @Column({ type: "integer", nullable: true })
  rep_count?: number;

  @Column({ type: "double precision", nullable: true })
  weight?: number;

  @Column({ nullable: true })
  weight_text?: string;

  @Column({ type: "jsonb", nullable: true })
  weight_adjustment?: Object;

  @Column({ type: "integer", nullable: true })
  rest_time_before?: number;

  @Column({ nullable: true })
  note?: string;

  @Column()
  is_active!: boolean;

  @Column({ default: false })
  is_archived!: boolean;

  @ManyToOne(() => CompletedWorkoutEntity, completedWorkout => completedWorkout.completedSets, {
    nullable: true
  })
  @JoinColumn({ name: "completed_workout_id" })
  completedWorkout?: CompletedWorkoutEntity;

  @ManyToOne(() => SetDetailEntity, setDetail => setDetail.completedSets, {
    nullable: true
  })
  @JoinColumn({ name: "set_detail_id" })
  setDetail?: SetDetailEntity;

  @ManyToOne(() => ExerciseEntity, exercise => exercise.completedSets, {
    nullable: true
  })
  @JoinColumn({ name: "exercise_id" })
  exercise!: ExerciseEntity;
}
