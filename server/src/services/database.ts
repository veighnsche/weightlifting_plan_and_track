import { DataSource, DataSourceOptions } from "typeorm";
import { ChatEntity } from "../models/chat/chatEntity";
import { UserEntity } from "../models/users/userEnitity";
import { UserSettingsEntity } from "../models/users/userSettingsEntity";

const options: DataSourceOptions = {
  type: "postgres",
  host: "localhost",
  port: 5432,
  username: "weightlifting_user",
  password: "J8f!2gH#1kP6wQr9",
  database: "weightlifting_db",
  entities: [
    UserEntity,
    ChatEntity,
    UserSettingsEntity,
  ],
  synchronize: true,
};

export const dataSource = new DataSource(options);

export const connectDatabase = async () => {
  await dataSource.initialize();
  console.log("DB connected");
};
