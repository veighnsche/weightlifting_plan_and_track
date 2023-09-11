import { User } from "../entities/user";
import { dataSource } from "../services/database";

const userRepository = dataSource.getRepository(User);

export const findByUid = async (uid: string): Promise<User | null> => {
  return userRepository.findOneBy({ uid });
};

export const userExists = async (uid: string): Promise<boolean> => {
  const user = await findByUid(uid);
  console.log("userExists:", { user });
  return !!user;
};

export const upsertUser = async (user: Partial<User> & { uid: string }): Promise<User> => {
  const existingUser = await findByUid(user.uid);

  try {
    if (existingUser) {
      console.info("User already exists, merging...");
      const mergedUser = userRepository.merge(existingUser, user);
      return await userRepository.save(mergedUser); // Saving the merged user
    } else {
      console.info("User does not exist, creating...");
      const newUser = userRepository.create(user);
      return await userRepository.save(newUser); // Saving the new user
    }
  } catch (error) {
    console.error("Error upserting user:", error);
    throw error;
  }
};
