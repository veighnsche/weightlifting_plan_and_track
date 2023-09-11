import { upsertUser } from "../repositories/user";
import { AppSocket } from "./index";

export const registerUserHandlers = (socket: AppSocket) => {
  socket.on("upsert-user", async (user) => {
    const { uid, name } = socket.data.decodedToken;
    await upsertUser({ ...user, name, uid });
    socket.emit("user-connected", { onboarded: true });
  });
};
