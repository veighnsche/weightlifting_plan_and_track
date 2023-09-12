import {
  Entity,
  PrimaryGeneratedColumn,
  Column
} from "typeorm";

@Entity("users")
export class UserEntity {

  @PrimaryGeneratedColumn("uuid")
  userId!: string;

  // firebase uid
  @Column({ type: "varchar", length: 255 })
  uid!: string;

  @Column({ type: "varchar", length: 255 })
  name!: string;

  @Column({ type: "varchar", length: 255, nullable: true })
  gender?: string;

  @Column({ type: "date", nullable: true })
  dateOfBirth?: Date;  // New dateOfBirth field

  @Column({ type: "float", nullable: true })
  weight?: number; // in kg

  @Column({ type: "float", nullable: true })
  height?: number; // in cm

  @Column({ type: "float", nullable: true })
  fatPercentage?: number;

  @Column({ type: "text", nullable: true })
  gymDescription?: string;
}
