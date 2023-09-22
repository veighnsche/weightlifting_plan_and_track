import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

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
  dateOfBirth?: string;  // New dateOfBirth field

  @Column({ type: "float", nullable: true })
  weight?: number; // in kg

  @Column({ type: "float", nullable: true })
  height?: number; // in cm

  @Column({ type: "float", nullable: true })
  fatPercentage?: number;

  @Column({ type: "text", nullable: true })
  gymDescription?: string;

  get age(): number | null {
    return calculateAge(this.dateOfBirth);
  }
}

function calculateAge(dateOfBirth: string | null | undefined): number | null {
  if (!dateOfBirth) return null;

  const dateOfBirthString = dateOfBirth.split("-");
  const dateOfBirthYear = parseInt(dateOfBirthString[0]);
  const dateOfBirthMonth = parseInt(dateOfBirthString[1]);
  const dateOfBirthDay = parseInt(dateOfBirthString[2]);

  const dateOfBirthDate = new Date(dateOfBirthYear, dateOfBirthMonth - 1, dateOfBirthDay);

  const today = new Date();
  let age = today.getFullYear() - dateOfBirthDate.getFullYear();
  const monthDiff = today.getMonth() - dateOfBirthDate.getMonth();

  if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dateOfBirthDate.getDate())) {
    age--;
  }

  return age;
}
