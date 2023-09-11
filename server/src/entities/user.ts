import {
  Entity,
  PrimaryGeneratedColumn,
  Column
} from "typeorm";

@Entity("users")
export class User {

  @PrimaryGeneratedColumn("uuid")
  userId!: string;

  @Column({ type: "varchar", length: 255 })
  name!: string;

  @Column({ type: "int" })
  age!: number;

  @Column({ type: "float" })
  weight!: number; // in kg

  @Column({ type: "float" })
  height!: number; // in cm

  @Column({ type: "text", nullable: true })
  gymDescription?: string;
}
