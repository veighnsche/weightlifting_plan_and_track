import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from "typeorm";
import { CompletedSetEntity } from "../completedSets/completedSetEntity";
import { SetReferenceEntity } from "../setReferences/setReferenceEntity";

@Entity("wpt_set_details")
export class SetDetailEntity {
  @PrimaryGeneratedColumn("uuid")
  set_detail_id!: string;

  @Column()
  set_reference_id!: string;

  @CreateDateColumn()
  created_at!: Date;

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

  @Column({ default: false })
  is_archived!: boolean;

  @ManyToOne(() => SetReferenceEntity, setReference => setReference.setDetails)
  @JoinColumn({ name: "set_reference_id" })
  setReference!: SetReferenceEntity;

  @OneToMany(() => CompletedSetEntity, completedSet => completedSet.setDetail)
  completedSets!: CompletedSetEntity[];
}