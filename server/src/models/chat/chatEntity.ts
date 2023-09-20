import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  UpdateDateColumn,
} from 'typeorm';

@Entity('chat_metadata')
export class ChatEntity {

  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 255 })
  userUid!: string;

  @Column({ type: 'varchar', length: 255 })
  chatId!: string; // firestore document id

  @Column({ type: 'varchar', length: 255 })
  name!: string;

  @UpdateDateColumn()
  updatedAt!: Date;
}