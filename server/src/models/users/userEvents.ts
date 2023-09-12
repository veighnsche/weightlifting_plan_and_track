import { upsertUser } from "./userRepository";
import { connectUser } from "../../services/connectUser";
import { AppSocket } from "../socketEvents";

export const registerUserHandlers = async (socket: AppSocket) => {
  await connectUser(socket);

  socket.on("upsert-user", async ({ user }) => {
    const { uid, name } = socket.data.decodedToken;
    await upsertUser({ ...user, name, uid });
    socket.emit("user-connected", { onboarded: true });
  });
};
