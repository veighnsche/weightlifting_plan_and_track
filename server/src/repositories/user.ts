import { User } from "../entities/user";
import { dataSource } from "../services/database";

const userRepository = dataSource.getRepository(User);

export const userExists = async (uid: string): Promise<boolean> => {
  const user = await userRepository.findOneBy({ uid })
  return !!user;
}