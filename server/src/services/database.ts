import { DataSource, DataSourceOptions } from "typeorm";
import { User } from "../entities/user";

const options: DataSourceOptions = {
  type: "postgres",
  host: "localhost",
  port: 5432,
  username: "weightlifting_user",
  password: "J8f!2gH#1kP6wQr9",
  database: "weightlifting_db",
  entities: [User],
  synchronize: true,
};

export const dataSource = new DataSource(options);

export const connectDatabase = async () => {
  await dataSource.initialize();
  console.log("DB connected");
};
