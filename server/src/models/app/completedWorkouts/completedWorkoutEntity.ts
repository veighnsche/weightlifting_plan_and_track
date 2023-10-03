import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { CompletedSetEntity } from "../completedSets/completedSetEntity";
import { WorkoutEntity } from "../workouts/workoutEntity";

@Entity("wpt_completed_workouts")
export class CompletedWorkoutEntity {
  @PrimaryGeneratedColumn("uuid")
  completed_workout_id!: string;

  @Column()
  workout_id!: string;

  @CreateDateColumn()
  started_at!: Date;

  @Column()
  user_uid!: string;

  @CreateDateColumn()
  completed_at!: Date;

  @Column({ nullable: true })
  note?: string;

  @Column()
  is_active!: boolean;

  @Column({ default: false })
  is_archived!: boolean;

  @ManyToOne(() => WorkoutEntity, workout => workout.completedWorkouts)
  @JoinColumn({ name: "workout_id" })
  workout!: WorkoutEntity;

  @OneToMany(() => CompletedSetEntity, completedSet => completedSet.completedWorkout)
  completedSets!: CompletedSetEntity[];
}