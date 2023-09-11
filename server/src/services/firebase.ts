import admin, { ServiceAccount } from "firebase-admin";
import serviceAccountKey from "../service-account-key.json";

export const initializeFirebase = () => {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccountKey as ServiceAccount),
  });
};
