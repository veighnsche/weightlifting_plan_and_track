import { upsertUser } from "./userRepository";
import { AppSocket } from "../socketEvents";

export const registerUserHandlers = async (socket: AppSocket) => {

  socket.on("check-onboarding", async (_, ackCallback) => {
    const { uid } = socket.data.decodedToken;
    const user = await upsertUser({ uid });
    ackCallback({ onboarded: !!user });
  });

  // socket.on("upsert-user", async ({ user }) => {
  //   const { uid, name } = socket.data.decodedToken;
  //   await upsertUser({ ...user, name, uid });
  // });
};
