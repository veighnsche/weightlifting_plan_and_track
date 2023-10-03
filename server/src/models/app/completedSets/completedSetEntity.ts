import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { CompletedWorkoutEntity } from "../completedWorkouts/completedWorkoutEntity";
import { SetDetailEntity } from "../setDetails/setDetailEntity";

@Entity("wpt_completed_sets")
export class CompletedSetEntity {
  @PrimaryGeneratedColumn("uuid")
  completed_set_id!: string;

  @Column()
  completed_workout_id!: string;

  @Column()
  set_detail_id!: string;

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

  @ManyToOne(() => CompletedWorkoutEntity, completedWorkout => completedWorkout.completedSets)
  @JoinColumn({ name: "completed_workout_id" })
  completedWorkout!: CompletedWorkoutEntity;

  @ManyToOne(() => SetDetailEntity, setDetail => setDetail.completedSets)
  @JoinColumn({ name: "set_detail_id" })
  setDetail!: SetDetailEntity;
}