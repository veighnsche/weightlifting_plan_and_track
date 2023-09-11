import { User } from "../entities/user";
import { dataSource } from "../services/database";

const userRepository = dataSource.getRepository(User);

export const findByUid = async (uid: string): Promise<User | null> => {
  return userRepository.findOneBy({ uid });
};

export const userExists = async (uid: string): Promise<boolean> => {
  const user = await findByUid(uid);
  return !!user;
};

export const upsertUser = async (user: User): Promise<User> => {
  const existingUser = await findByUid(user.uid);


  if (existingUser) {
    return userRepository.merge(existingUser, user);
  } else {
    return userRepository.create(user);
  }
};