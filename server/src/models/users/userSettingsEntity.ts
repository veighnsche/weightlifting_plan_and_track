import { Column, Entity, PrimaryColumn } from "typeorm";

@Entity()
export class UserSettingsEntity {

  @PrimaryColumn({ type: "varchar", length: 255 })
  userId!: string;

  @PrimaryColumn({ type: "varchar", length: 255 })
  settingKey!: string;

  @Column({ type: "varchar" })
  settingValue!: string;
}
