import { UserEntity } from "./userEnitity";
import { dataSource } from "../../services/database";

const userRepository = dataSource.getRepository(UserEntity);

export const findByUid = async (uid: string): Promise<UserEntity | null> => {
  return userRepository.findOneBy({ uid });
};

export const userExists = async (uid: string): Promise<boolean> => {
  const user = await findByUid(uid);
  return !!user;
};

export const upsertUser = async (user: Partial<UserEntity> & { uid: string }): Promise<UserEntity> => {
  const existingUser = await findByUid(user.uid);

  const updatedUser: UserEntity = existingUser
    ? userRepository.merge(existingUser, user)
    : userRepository.create(user);
  return userRepository.save(updatedUser);
};
