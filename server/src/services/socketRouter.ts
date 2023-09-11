import type { Server } from "socket.io";

export const socketRouter: Parameters<Server["use"]>[0] = async (socket, next) => {
  console.log(`user ${socket.data.decodedToken.name} connected`);

  // here I need to check if the user is already in the database
  // if not, then I need to emit "user-connected" with onboarded = false
  // if yes, then I need to emit "user-connected" with onboarded = true


  socket.on("disconnect", () => {
    console.log(`user ${socket.data.decodedToken.name} disconnected`);
  });
}