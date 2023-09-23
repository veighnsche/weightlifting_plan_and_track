import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { ExerciseEntity } from "../1-exercise/exerciseEntity";

@Entity("wpt-sets")
export class SetEntity {
  @PrimaryGeneratedColumn({ name: "set_id" })
  setId!: number;

  @Column({ name: "exercise_id" })
  exerciseId!: number;

  @Column({ name: "order_number", nullable: true })
  orderNumber?: number; // the sets also decide the exercise order

  @Column({ name: "rep_count" })
  repCount!: number;

  @Column({ type: "float", nullable: true })
  weight?: number; // in kg

  @Column({ name: "weight_text", type: "varchar", length: 100, nullable: true })
  weightText?: string; // "bodyweight", "barbell", "dumbbell", "kettlebell", "machine", "cable", "band", "other"

  @Column({ name: "weight_adjustment", type: "jsonb", nullable: true })
  weightAdjustment?: any; // { 4: -5, 8: 3 } after the 4th rep, subtract 5 kg, after the 8th rep, add 3 kg

  @Column({ type: "text", nullable: true })
  note?: string;

  @ManyToOne(() => ExerciseEntity)
  @JoinColumn({ name: "exercise_id" })
  exercise!: ExerciseEntity;
}