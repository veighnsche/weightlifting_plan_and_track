// routes.ts (or setupRoutes.ts)

import express from 'express';
import mockRouter from '../mock/mockEvents';
import exerciseRouter from '../models/app/exercises/exerciseEvents';
import workoutRouter from '../models/app/workouts/workoutEvents';
import chatRouter from '../models/chat/chatEvents';
import initRouter from '../models/init/initEvents';
import userRouter from '../models/users/userEvents';

export function setupRoutes(app: express.Application) {
  // Init routes
  app.use('/init', initRouter);

  // User routes
  app.use('/user', userRouter);

  // Chat routes
  app.use('/chat', chatRouter);

  // App routes
  app.use('/app/workouts', workoutRouter);
  app.use('/app/exercises', exerciseRouter);

  // Mock routes
  app.use('/mock', mockRouter);
}
