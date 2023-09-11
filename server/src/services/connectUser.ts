import { Socket } from "socket.io";
import { userExists } from "../repositories/user";

export const connectUser = async (socket: Socket) => {
  const uid = socket.data.decodedToken.uid; // Assuming the uid is in the decodedToken
  const exists = await userExists(uid);

  if (exists) {
    socket.emit("user-connected", { onboarded: true });
  } else {
    socket.emit("user-connected", { onboarded: false });
  }
}
