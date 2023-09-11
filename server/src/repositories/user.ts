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

export const upsertUser = async (user: Partial<User> & { uid: string }): Promise<User> => {
  const existingUser = await findByUid(user.uid);

  try {
    if (existingUser) {
      console.info("User already exists, merging...");
      return userRepository.merge(existingUser, user);
    } else {
      console.info("User does not exist, creating...");
      return userRepository.create(user);
    }
  } catch (error) {
    console.error("Error upserting user:", error);
    throw error;
  }
};