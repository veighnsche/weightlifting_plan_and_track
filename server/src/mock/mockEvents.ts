/*
create table public.wpt_workouts
(
    workout_id  uuid    default uuid_generate_v4() not null
        constraint "PK_3beb3ecc72b6c94869ef3ac0122"
            primary key,
    user_uid    varchar                            not null,
    name        varchar                            not null,
    day_of_week integer,
    note        varchar
);

create table public.wpt_exercises
(
    exercise_id uuid    default uuid_generate_v4() not null
        constraint "PK_be1e54d1c2d007ef7e17e52803a"
            primary key,
    user_uid    varchar                            not null,
    name        varchar                            not null,
    note        varchar
);

create table public.wpt_workout_exercises
(
    workout_exercise_id uuid    default uuid_generate_v4() not null
        constraint "PK_04c52a0759f4cf9974ce44e1b59"
            primary key,
    workout_id          uuid                               not null
        constraint "FK_5abf84cfa37495785c564d50bcb"
            references public.wpt_workouts,
    exercise_id         uuid                               not null
        constraint "FK_ee5251db79673000c607c1b61c8"
            references public.wpt_exercises,
    order_number        integer,
    note                varchar
);

create table public.wpt_set_references
(
    set_reference_id    uuid    default uuid_generate_v4() not null
        constraint "PK_8e18870ef4d67f9672b1ece4098"
            primary key,
    workout_exercise_id uuid                               not null
        constraint "FK_6e8fb7ea3ba6e500706211a558e"
            references public.wpt_workout_exercises,
    order_number        integer                            not null,
    note                varchar
);

create table public.wpt_set_details
(
    set_detail_id     uuid      default uuid_generate_v4() not null
        constraint "PK_b0fbcef57c93115bac7fdda7301"
            primary key,
    set_reference_id  uuid                                 not null
        constraint "FK_30c9a7eb0a3cdbdc40a36de2352"
            references public.wpt_set_references,
    created_at        timestamp default now()              not null,
    rep_count         integer,
    weight            double precision,
    weight_text       varchar,
    weight_adjustment jsonb,
    rest_time_before  integer,
    note              varchar
);

create table public.wpt_completed_workouts
(
    completed_workout_id uuid      default uuid_generate_v4() not null
        constraint "PK_ab1c2cb29a19dec7055bf093129"
            primary key,
    user_uid             varchar                              not null,
    workout_id           uuid                                 not null
        constraint "FK_80301395e81e5b6d6a63f4113d5"
            references public.wpt_workouts,
    started_at           timestamp default now()              not null,
    completed_at         timestamp default now()              not null,
    note                 varchar,
    is_active            boolean                              not null
);

create table public.wpt_completed_sets
(
    completed_set_id     uuid      default uuid_generate_v4() not null
        constraint "PK_148b5f49cf45c0095693d28e6a2"
            primary key,
    completed_workout_id uuid                                 not null
        constraint "FK_d54b7853583bb985e63a7fc111e"
            references public.wpt_completed_workouts,
    set_detail_id        uuid                                 not null
        constraint "FK_405069d7edf65581e61c9a170ee"
            references public.wpt_set_details,
    exercise_id          uuid                                 not null
        constraint "FK_12699e72d47686aa5c61589ad54"
            references public.wpt_exercises,
    completed_at         timestamp default now()              not null,
    rep_count            integer,
    weight               double precision,
    weight_text          varchar,
    weight_adjustment    jsonb,
    rest_time_before     integer,
    note                 varchar,
    is_active            boolean                              not null,
    is_archived          boolean   default false              not null
);
*/

import express from "express";
import { CompletedSetEntity } from "../models/app/completedSets/completedSetEntity";
import { CompletedWorkoutEntity } from "../models/app/completedWorkouts/completedWorkoutEntity";
import { ExerciseEntity } from "../models/app/exercises/exerciseEntity";
import { SetDetailEntity } from "../models/app/setDetails/setDetailEntity";
import { SetReferenceEntity } from "../models/app/setReferences/setReferenceEntity";
import { WorkoutExerciseEntity } from "../models/app/workoutExercises/workoutExerciseEntity";
import { WorkoutEntity } from "../models/app/workouts/workoutEntity";
import { dataSourceHasura } from "../services/databaseHasura";

const router = express.Router();
const workoutRepository = dataSourceHasura.getRepository(WorkoutEntity);
const exerciseRepository = dataSourceHasura.getRepository(ExerciseEntity);
const workoutExerciseRepository = dataSourceHasura.getRepository(WorkoutExerciseEntity);
const setReferenceRepository = dataSourceHasura.getRepository(SetReferenceEntity);
const setDetailRepository = dataSourceHasura.getRepository(SetDetailEntity);
const completedWorkoutRepository = dataSourceHasura.getRepository(CompletedWorkoutEntity);
const completedSetRepository = dataSourceHasura.getRepository(CompletedSetEntity);

const user_uid = "am79ZCgPfrh8Ciurz8ma61Jglu33";

/*
This is a mock endpoint for inserting data into the database. All needs informative notes.

What I want is 4 workouts with associated exercises.
Chest (Sunday: day 6):
 - Bench Press: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
 - Inclined Dumbbell Bench Press: 2 warmup sets (12 reps) (12kg, 16kg), 3 working sets (12 reps) (20kg) [compound]
 - Lateral Pull-down: 3 sets (12 reps) (45kg) [compound]
 - Dumbbell Arm Curl: 3 sets (15 reps) (10kg) [isolation]
 - Triceps Cable Extension: 3 sets (12 reps) (21kg) [isolation]
 - Face Pulls: 3 sets (12 reps) (21kg) [isolation]
 - Dumbbell Side Raises: 3 sets (12 reps) (7kg) [isolation]

Squats (Monday: day 0):
 - Barbell Squats: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
 - Leg Press: 3 sets (12 reps) (100kg) [compound]
 - Good Mornings: 3 sets (12 reps) (20kg) [compound]
 - Lying Leg Curls: 3 sets (12 reps) (45kg) [isolation]
 - Standing Calf Raises: 3 sets (15 reps) (50kg) [isolation]
 - Abs leg raises: 3 sets (15 reps) (body weight) [isolation]

Shoulders (Wednesday: day 2):
 - Overhead Press: 2 warmup sets (5 reps) (20kg, 30kg), 3 working sets (5 reps) (40kg) [compound]
 - Pull-ups: 1 set (15 reps) (body weight) [compound]
 - Pendley Rows: 3 sets (12 reps) (40kg) [compound]
 - Seated Chest Press: 3 sets (12 reps) (60kg) [isolation]
 - Dumbbell Arm Curl: 3 sets (15 reps) (12kg) [isolation] (exercise already exists, but unique set details)
 - Triceps Cable Extension: 3 sets (12 reps) (23kg) [isolation] (exercise already exists, but unique set details)
 - Face Pulls: 3 sets (12 reps) (23kg) [isolation] (exercise already exists, but unique set details)
 - Dumbbell Side Raises: 3 sets (12 reps) (8kg) [isolation] (exercise already exists, but unique set details)

Deadlifts (Thursday: day 3):
 - Romanian Deadlifts: 2 warmup sets (7 reps) (60kg, 80kg), 3 working sets (7 reps) (100kg) [compound]
 - Front Squats: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
 - Hip Thrusts: 3 sets (12 reps) (30kg) [compound]
 - Leg Extensions: 3 sets (12 reps) (45kg) [isolation]
 - Seated Leg Curls: 3 sets (12 reps) (45kg) [isolation]
 - Standing Calf Raises: 3 sets (15 reps) (52kg) [isolation] (exercise already exists, but unique set details)
 - Abs leg raises: 3 sets (15 reps) (body weight) [isolation] (exercise already exists, but unique set details)

Then I want 2 weeks of completed workouts.
*/
router.get("/", async (req, res) => {
  try {
    // Define workouts
    const workouts: Partial<WorkoutEntity>[] = [
      { user_uid, name: "Chest", day_of_week: 6, note: "Chest workout" },
      { user_uid, name: "Squats", day_of_week: 0, note: "Leg workout" },
      { user_uid, name: "Shoulders", day_of_week: 2, note: "Shoulders workout" },
      { user_uid, name: "Deadlifts", day_of_week: 3, note: "Back and deadlifts workout" },
    ];

    // Insert workouts into the database
    const savedWorkouts = await workoutRepository.save(workouts);

    // Define and insert exercises, and associate them with the workouts
    // For simplicity, we assume all exercises are unique and are inserted every time
    const exercises: Partial<ExerciseEntity>[] = [
      { user_uid, name: "Bench Press", note: "Compound movement" },
      { user_uid, name: "Inclined Dumbbell Bench Press", note: "Compound movement" },
      { user_uid, name: "Lateral Pull-down", note: "Compound movement" },
      { user_uid, name: "Dumbbell Arm Curl", note: "Isolation movement" },
      { user_uid, name: "Triceps Cable Extension", note: "Isolation movement" },
      { user_uid, name: "Face Pulls", note: "Isolation movement" },
      { user_uid, name: "Dumbbell Side Raises", note: "Isolation movement" },
      { user_uid, name: "Barbell Squats", note: "Compound movement" },
      { user_uid, name: "Leg Press", note: "Compound movement" },
      { user_uid, name: "Good Mornings", note: "Compound movement" },
      { user_uid, name: "Lying Leg Curls", note: "Isolation movement" },
      { user_uid, name: "Standing Calf Raises", note: "Isolation movement" },
      { user_uid, name: "Abs leg raises", note: "Isolation movement" },
      { user_uid, name: "Overhead Press", note: "Compound movement" },
      { user_uid, name: "Pull-ups", note: "Compound movement" },
      { user_uid, name: "Pendley Rows", note: "Compound movement" },
      { user_uid, name: "Seated Chest Press", note: "Isolation movement" },
      { user_uid, name: "Romanian Deadlifts", note: "Compound movement" },
      { user_uid, name: "Front Squats", note: "Compound movement" },
      { user_uid, name: "Hip Thrusts", note: "Compound movement" },
      { user_uid, name: "Leg Extensions", note: "Isolation movement" },
      { user_uid, name: "Seated Leg Curls", note: "Isolation movement" },
    ];

    const savedExercises = await exerciseRepository.save(exercises);

    // Associate exercises with workouts
    const workoutExercises: Partial<WorkoutExerciseEntity>[] = [
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[0].exercise_id, order_number: 0 }, // 0 Chest - Bench Press
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[1].exercise_id, order_number: 1 }, // 1 Chest - Inclined Dumbbell Bench Press
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[2].exercise_id, order_number: 2 }, // 2 Chest - Lateral Pull-down
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[3].exercise_id, order_number: 3 }, // 3 Chest - Dumbbell Arm Curl
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[4].exercise_id, order_number: 4 }, // 4 Chest - Triceps Cable Extension
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[5].exercise_id, order_number: 5 }, // 5 Chest - Face Pulls
      { workout_id: savedWorkouts[0].workout_id, exercise_id: savedExercises[6].exercise_id, order_number: 6 }, // 6 Chest - Dumbbell Side Raises
      { workout_id: savedWorkouts[1].workout_id, exercise_id: savedExercises[7].exercise_id, order_number: 0 }, // 7 Squats - Barbell Squats
      { workout_id: savedWorkouts[1].workout_id, exercise_id: savedExercises[8].exercise_id, order_number: 1 }, // 8 Squats - Leg Press
      { workout_id: savedWorkouts[1].workout_id, exercise_id: savedExercises[9].exercise_id, order_number: 2 }, // 9 Squats - Good Mornings
      { workout_id: savedWorkouts[1].workout_id, exercise_id: savedExercises[10].exercise_id, order_number: 3 }, // 10 Squats - Lying Leg Curls
      { workout_id: savedWorkouts[1].workout_id, exercise_id: savedExercises[11].exercise_id, order_number: 4 }, // 11 Squats - Standing Calf Raises
      { workout_id: savedWorkouts[1].workout_id, exercise_id: savedExercises[12].exercise_id, order_number: 5 }, // 12 Squats - Abs leg raises
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[13].exercise_id, order_number: 0 }, // 13 Shoulders - Overhead Press
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[14].exercise_id, order_number: 1 }, // 14 Shoulders - Pull-ups
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[15].exercise_id, order_number: 2 }, // 15 Shoulders - Pendley Rows
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[16].exercise_id, order_number: 3 }, // 16 Shoulders - Seated Chest Press
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[3].exercise_id, order_number: 4 }, // 17 Shoulders - Dumbbell Arm Curl
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[4].exercise_id, order_number: 5 }, // 18 Shoulders - Triceps Cable Extension
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[5].exercise_id, order_number: 6 }, // 19 Shoulders - Face Pulls
      { workout_id: savedWorkouts[2].workout_id, exercise_id: savedExercises[6].exercise_id, order_number: 7 }, // 20 Shoulders - Dumbbell Side Raises
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[17].exercise_id, order_number: 0 }, // 21 Deadlifts - Romanian Deadlifts
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[18].exercise_id, order_number: 1 }, // 22 Deadlifts - Front Squats
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[19].exercise_id, order_number: 2 }, // 23 Deadlifts - Hip Thrusts
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[20].exercise_id, order_number: 3 }, // 24 Deadlifts - Leg Extensions
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[21].exercise_id, order_number: 4 }, // 25 Deadlifts - Seated Leg Curls
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[11].exercise_id, order_number: 5 }, // 26 Deadlifts - Standing Calf Raises
      { workout_id: savedWorkouts[3].workout_id, exercise_id: savedExercises[12].exercise_id, order_number: 6 }, // 27 Deadlifts - Abs leg raises
    ];

    const savedWorkoutExercises = await workoutExerciseRepository.save(workoutExercises);

    // Define and insert set references, and associate them with the workout exercises
    const setReferences: Partial<SetReferenceEntity>[] = [
      { workout_exercise_id: savedWorkoutExercises[0].workout_exercise_id, order_number: 0, note: "warmup" }, // 0 Chest - Bench Press (warmup)
      { workout_exercise_id: savedWorkoutExercises[0].workout_exercise_id, order_number: 1, note: "warmup" }, // 1 Chest - Bench Press (warmup)
      { workout_exercise_id: savedWorkoutExercises[0].workout_exercise_id, order_number: 2 }, // 2 Chest - Bench Press (working)
      { workout_exercise_id: savedWorkoutExercises[0].workout_exercise_id, order_number: 3 }, // 3 Chest - Bench Press (working)
      { workout_exercise_id: savedWorkoutExercises[0].workout_exercise_id, order_number: 4 }, // 4 Chest - Bench Press (working)

      { workout_exercise_id: savedWorkoutExercises[1].workout_exercise_id, order_number: 0, note: "warmup" }, // 5 Chest - Inclined Dumbbell Bench Press (warmup)
      { workout_exercise_id: savedWorkoutExercises[1].workout_exercise_id, order_number: 1, note: "warmup" }, // 6 Chest - Inclined Dumbbell Bench Press (warmup)
      { workout_exercise_id: savedWorkoutExercises[1].workout_exercise_id, order_number: 2 }, // 7 Chest - Inclined Dumbbell Bench Press (working)
      { workout_exercise_id: savedWorkoutExercises[1].workout_exercise_id, order_number: 3 }, // 8 Chest - Inclined Dumbbell Bench Press (working)
      { workout_exercise_id: savedWorkoutExercises[1].workout_exercise_id, order_number: 4 }, // 9 Chest - Inclined Dumbbell Bench Press (working)

      { workout_exercise_id: savedWorkoutExercises[2].workout_exercise_id, order_number: 0 }, // 10 Chest - Lateral Pull-down (working)
      { workout_exercise_id: savedWorkoutExercises[2].workout_exercise_id, order_number: 1 }, // 11 Chest - Lateral Pull-down (working)
      { workout_exercise_id: savedWorkoutExercises[2].workout_exercise_id, order_number: 2 }, // 12 Chest - Lateral Pull-down (working)

      { workout_exercise_id: savedWorkoutExercises[3].workout_exercise_id, order_number: 0 }, // 13 Chest - Dumbbell Arm Curl (working)
      { workout_exercise_id: savedWorkoutExercises[3].workout_exercise_id, order_number: 1 }, // 14 Chest - Dumbbell Arm Curl (working)
      { workout_exercise_id: savedWorkoutExercises[3].workout_exercise_id, order_number: 2 }, // 15 Chest - Dumbbell Arm Curl (working)

      { workout_exercise_id: savedWorkoutExercises[4].workout_exercise_id, order_number: 0 }, // 16 Chest - Triceps Cable Extension (working)
      { workout_exercise_id: savedWorkoutExercises[4].workout_exercise_id, order_number: 1 }, // 17 Chest - Triceps Cable Extension (working)
      { workout_exercise_id: savedWorkoutExercises[4].workout_exercise_id, order_number: 2 }, // 18 Chest - Triceps Cable Extension (working)

      { workout_exercise_id: savedWorkoutExercises[5].workout_exercise_id, order_number: 0 }, // 19 Chest - Face Pulls (working)
      { workout_exercise_id: savedWorkoutExercises[5].workout_exercise_id, order_number: 1 }, // 20 Chest - Face Pulls (working)
      { workout_exercise_id: savedWorkoutExercises[5].workout_exercise_id, order_number: 2 }, // 21 Chest - Face Pulls (working)

      { workout_exercise_id: savedWorkoutExercises[6].workout_exercise_id, order_number: 0 }, // 22 Chest - Dumbbell Side Raises (working)
      { workout_exercise_id: savedWorkoutExercises[6].workout_exercise_id, order_number: 1 }, // 23 Chest - Dumbbell Side Raises (working)
      { workout_exercise_id: savedWorkoutExercises[6].workout_exercise_id, order_number: 2 }, // 24 Chest - Dumbbell Side Raises (working)

      { workout_exercise_id: savedWorkoutExercises[7].workout_exercise_id, order_number: 0, note: "warmup" }, // 25 Squats - Barbell Squats (warmup)
      { workout_exercise_id: savedWorkoutExercises[7].workout_exercise_id, order_number: 1, note: "warmup" }, // 26 Squats - Barbell Squats (warmup)
      { workout_exercise_id: savedWorkoutExercises[7].workout_exercise_id, order_number: 2 }, // 27 Squats - Barbell Squats (working)
      { workout_exercise_id: savedWorkoutExercises[7].workout_exercise_id, order_number: 3 }, // 28 Squats - Barbell Squats (working)
      { workout_exercise_id: savedWorkoutExercises[7].workout_exercise_id, order_number: 4 }, // 29 Squats - Barbell Squats (working)

      { workout_exercise_id: savedWorkoutExercises[8].workout_exercise_id, order_number: 0 }, // 30 Squats - Leg Press (working)
      { workout_exercise_id: savedWorkoutExercises[8].workout_exercise_id, order_number: 1 }, // 31 Squats - Leg Press (working)
      { workout_exercise_id: savedWorkoutExercises[8].workout_exercise_id, order_number: 2 }, // 32 Squats - Leg Press (working)

      { workout_exercise_id: savedWorkoutExercises[9].workout_exercise_id, order_number: 0 }, // 33 Squats - Good Mornings (working)
      { workout_exercise_id: savedWorkoutExercises[9].workout_exercise_id, order_number: 1 }, // 34 Squats - Good Mornings (working)
      { workout_exercise_id: savedWorkoutExercises[9].workout_exercise_id, order_number: 2 }, // 35 Squats - Good Mornings (working)

      { workout_exercise_id: savedWorkoutExercises[10].workout_exercise_id, order_number: 0 }, // 36 Squats - Lying Leg Curls (working)
      { workout_exercise_id: savedWorkoutExercises[10].workout_exercise_id, order_number: 1 }, // 37 Squats - Lying Leg Curls (working)
      { workout_exercise_id: savedWorkoutExercises[10].workout_exercise_id, order_number: 2 }, // 38 Squats - Lying Leg Curls (working)

      { workout_exercise_id: savedWorkoutExercises[11].workout_exercise_id, order_number: 0 }, // 39 Squats - Standing Calf Raises (working)
      { workout_exercise_id: savedWorkoutExercises[11].workout_exercise_id, order_number: 1 }, // 40 Squats - Standing Calf Raises (working)
      { workout_exercise_id: savedWorkoutExercises[11].workout_exercise_id, order_number: 2 }, // 41 Squats - Standing Calf Raises (working)

      { workout_exercise_id: savedWorkoutExercises[12].workout_exercise_id, order_number: 0 }, // 42 Squats - Abs leg raises (working)
      { workout_exercise_id: savedWorkoutExercises[12].workout_exercise_id, order_number: 1 }, // 43 Squats - Abs leg raises (working)
      { workout_exercise_id: savedWorkoutExercises[12].workout_exercise_id, order_number: 2 }, // 44 Squats - Abs leg raises (working)

      { workout_exercise_id: savedWorkoutExercises[13].workout_exercise_id, order_number: 0, note: "warmup" }, // 45 Shoulders - Overhead Press (warmup)
      { workout_exercise_id: savedWorkoutExercises[13].workout_exercise_id, order_number: 1, note: "warmup" }, // 46 Shoulders - Overhead Press (warmup)
      { workout_exercise_id: savedWorkoutExercises[13].workout_exercise_id, order_number: 2 }, // 47 Shoulders - Overhead Press (working)
      { workout_exercise_id: savedWorkoutExercises[13].workout_exercise_id, order_number: 3 }, // 48 Shoulders - Overhead Press (working)
      { workout_exercise_id: savedWorkoutExercises[13].workout_exercise_id, order_number: 4 }, // 49 Shoulders - Overhead Press (working)

      { workout_exercise_id: savedWorkoutExercises[14].workout_exercise_id, order_number: 0 }, // 50 Shoulders - Pull-ups (working)
      { workout_exercise_id: savedWorkoutExercises[14].workout_exercise_id, order_number: 1 }, // 51 Shoulders - Pull-ups (working)
      { workout_exercise_id: savedWorkoutExercises[14].workout_exercise_id, order_number: 2 }, // 52 Shoulders - Pull-ups (working)

      { workout_exercise_id: savedWorkoutExercises[15].workout_exercise_id, order_number: 0 }, // 53 Shoulders - Pendley Rows (working)
      { workout_exercise_id: savedWorkoutExercises[15].workout_exercise_id, order_number: 1 }, // 54 Shoulders - Pendley Rows (working)
      { workout_exercise_id: savedWorkoutExercises[15].workout_exercise_id, order_number: 2 }, // 55 Shoulders - Pendley Rows (working)

      { workout_exercise_id: savedWorkoutExercises[16].workout_exercise_id, order_number: 0 }, // 56 Shoulders - Seated Chest Press (working)
      { workout_exercise_id: savedWorkoutExercises[16].workout_exercise_id, order_number: 1 }, // 57 Shoulders - Seated Chest Press (working)
      { workout_exercise_id: savedWorkoutExercises[16].workout_exercise_id, order_number: 2 }, // 58 Shoulders - Seated Chest Press (working)

      { workout_exercise_id: savedWorkoutExercises[17].workout_exercise_id, order_number: 0 }, // 59 Shoulders - Dumbbell Arm Curl (working)
      { workout_exercise_id: savedWorkoutExercises[17].workout_exercise_id, order_number: 1 }, // 60 Shoulders - Dumbbell Arm Curl (working)
      { workout_exercise_id: savedWorkoutExercises[17].workout_exercise_id, order_number: 2 }, // 61 Shoulders - Dumbbell Arm Curl (working)

      { workout_exercise_id: savedWorkoutExercises[18].workout_exercise_id, order_number: 0 }, // 62 Shoulders - Triceps Cable Extension (working)
      { workout_exercise_id: savedWorkoutExercises[18].workout_exercise_id, order_number: 1 }, // 63 Shoulders - Triceps Cable Extension (working)
      { workout_exercise_id: savedWorkoutExercises[18].workout_exercise_id, order_number: 2 }, // 64 Shoulders - Triceps Cable Extension (working)

      { workout_exercise_id: savedWorkoutExercises[19].workout_exercise_id, order_number: 0 }, // 65 Shoulders - Face Pulls (working)
      { workout_exercise_id: savedWorkoutExercises[19].workout_exercise_id, order_number: 1 }, // 66 Shoulders - Face Pulls (working)
      { workout_exercise_id: savedWorkoutExercises[19].workout_exercise_id, order_number: 2 }, // 67 Shoulders - Face Pulls (working)

      { workout_exercise_id: savedWorkoutExercises[20].workout_exercise_id, order_number: 0 }, // 68 Shoulders - Dumbbell Side Raises (working)
      { workout_exercise_id: savedWorkoutExercises[20].workout_exercise_id, order_number: 1 }, // 69 Shoulders - Dumbbell Side Raises (working)
      { workout_exercise_id: savedWorkoutExercises[20].workout_exercise_id, order_number: 2 }, // 70 Shoulders - Dumbbell Side Raises (working)

      { workout_exercise_id: savedWorkoutExercises[21].workout_exercise_id, order_number: 0, note: "warmup" }, // 71 Deadlifts - Romanian Deadlifts (warmup)
      { workout_exercise_id: savedWorkoutExercises[21].workout_exercise_id, order_number: 1, note: "warmup" }, // 72 Deadlifts - Romanian Deadlifts (warmup)
      { workout_exercise_id: savedWorkoutExercises[21].workout_exercise_id, order_number: 2 }, // 73 Deadlifts - Romanian Deadlifts (working)
      { workout_exercise_id: savedWorkoutExercises[21].workout_exercise_id, order_number: 3 }, // 74 Deadlifts - Romanian Deadlifts (working)
      { workout_exercise_id: savedWorkoutExercises[21].workout_exercise_id, order_number: 4 }, // 75 Deadlifts - Romanian Deadlifts (working)

      { workout_exercise_id: savedWorkoutExercises[22].workout_exercise_id, order_number: 0, note: "warmup" }, // 76 Deadlifts - Front Squats (warmup)
      { workout_exercise_id: savedWorkoutExercises[22].workout_exercise_id, order_number: 1, note: "warmup" }, // 77 Deadlifts - Front Squats (warmup)
      { workout_exercise_id: savedWorkoutExercises[22].workout_exercise_id, order_number: 2 }, // 78 Deadlifts - Front Squats (working)
      { workout_exercise_id: savedWorkoutExercises[22].workout_exercise_id, order_number: 3 }, // 79 Deadlifts - Front Squats (working)
      { workout_exercise_id: savedWorkoutExercises[22].workout_exercise_id, order_number: 4 }, // 80 Deadlifts - Front Squats (working)

      { workout_exercise_id: savedWorkoutExercises[23].workout_exercise_id, order_number: 0 }, // 81 Deadlifts - Hip Thrusts (working)
      { workout_exercise_id: savedWorkoutExercises[23].workout_exercise_id, order_number: 1 }, // 82 Deadlifts - Hip Thrusts (working)
      { workout_exercise_id: savedWorkoutExercises[23].workout_exercise_id, order_number: 2 }, // 83 Deadlifts - Hip Thrusts (working)

      { workout_exercise_id: savedWorkoutExercises[24].workout_exercise_id, order_number: 0 }, // 84 Deadlifts - Leg Extensions (working)
      { workout_exercise_id: savedWorkoutExercises[24].workout_exercise_id, order_number: 1 }, // 85 Deadlifts - Leg Extensions (working)
      { workout_exercise_id: savedWorkoutExercises[24].workout_exercise_id, order_number: 2 }, // 86 Deadlifts - Leg Extensions (working)

      { workout_exercise_id: savedWorkoutExercises[25].workout_exercise_id, order_number: 0 }, // 87 Deadlifts - Seated Leg Curls (working)
      { workout_exercise_id: savedWorkoutExercises[25].workout_exercise_id, order_number: 1 }, // 88 Deadlifts - Seated Leg Curls (working)
      { workout_exercise_id: savedWorkoutExercises[25].workout_exercise_id, order_number: 2 }, // 89 Deadlifts - Seated Leg Curls (working)

      { workout_exercise_id: savedWorkoutExercises[26].workout_exercise_id, order_number: 0 }, // 90 Deadlifts - Standing Calf Raises (working)
      { workout_exercise_id: savedWorkoutExercises[26].workout_exercise_id, order_number: 1 }, // 91 Deadlifts - Standing Calf Raises (working)
      { workout_exercise_id: savedWorkoutExercises[26].workout_exercise_id, order_number: 2 }, // 92 Deadlifts - Standing Calf Raises (working)

      { workout_exercise_id: savedWorkoutExercises[27].workout_exercise_id, order_number: 0 }, // 93 Deadlifts - Abs leg raises (working)
      { workout_exercise_id: savedWorkoutExercises[27].workout_exercise_id, order_number: 1 }, // 94 Deadlifts - Abs leg raises (working)
      { workout_exercise_id: savedWorkoutExercises[27].workout_exercise_id, order_number: 2 }, // 95 Deadlifts - Abs leg raises (working)
    ];

    const savedSetReferences = await setReferenceRepository.save(setReferences);

    // Define and insert set details, and associate them with the set references
    const setDetails: Partial<SetDetailEntity>[] = [
      //   Chest (Sunday: day 6):
      // - Bench Press: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
      { set_reference_id: savedSetReferences[0].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 0 Chest - Bench Press (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[0].set_reference_id, weight: 39, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 1 Chest - Bench Press (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[0].set_reference_id, weight: 40, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 2 Chest - Bench Press (warmup) (now)

      { set_reference_id: savedSetReferences[1].set_reference_id, weight: 48, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 3 Chest - Bench Press (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[1].set_reference_id, weight: 49, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 4 Chest - Bench Press (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[1].set_reference_id, weight: 50, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 5 Chest - Bench Press (warmup) (now)

      { set_reference_id: savedSetReferences[2].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 6 Chest - Bench Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[2].set_reference_id, weight: 59, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 7 Chest - Bench Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[2].set_reference_id, weight: 60, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 8 Chest - Bench Press (working) (now)

      { set_reference_id: savedSetReferences[3].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 9 Chest - Bench Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[3].set_reference_id, weight: 59, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 10 Chest - Bench Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[3].set_reference_id, weight: 60, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 11 Chest - Bench Press (working) (now)

      { set_reference_id: savedSetReferences[4].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 12 Chest - Bench Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[4].set_reference_id, weight: 59, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 13 Chest - Bench Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[4].set_reference_id, weight: 60, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 14 Chest - Bench Press (working) (now)

      // - Inclined Dumbbell Bench Press: 2 warmup sets (12 reps) (12kg, 16kg), 3 working sets (12 reps) (20kg) [compound]
      { set_reference_id: savedSetReferences[5].set_reference_id, weight: 10, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 15 Chest - Inclined Dumbbell Bench Press (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[5].set_reference_id, weight: 11, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 16 Chest - Inclined Dumbbell Bench Press (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[5].set_reference_id, weight: 12, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 17 Chest - Inclined Dumbbell Bench Press (warmup) (now)

      { set_reference_id: savedSetReferences[6].set_reference_id, weight: 14, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 18 Chest - Inclined Dumbbell Bench Press (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[6].set_reference_id, weight: 15, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 19 Chest - Inclined Dumbbell Bench Press (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[6].set_reference_id, weight: 16, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 20 Chest - Inclined Dumbbell Bench Press (warmup) (now)

      { set_reference_id: savedSetReferences[7].set_reference_id, weight: 18, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 21 Chest - Inclined Dumbbell Bench Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[7].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 22 Chest - Inclined Dumbbell Bench Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[7].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 23 Chest - Inclined Dumbbell Bench Press (working) (now)

      { set_reference_id: savedSetReferences[8].set_reference_id, weight: 18, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 24 Chest - Inclined Dumbbell Bench Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[8].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 25 Chest - Inclined Dumbbell Bench Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[8].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 26 Chest - Inclined Dumbbell Bench Press (working) (now)

      { set_reference_id: savedSetReferences[9].set_reference_id, weight: 18, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 27 Chest - Inclined Dumbbell Bench Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[9].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 28 Chest - Inclined Dumbbell Bench Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[9].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 29 Chest - Inclined Dumbbell Bench Press (working) (now)

      // - Lateral Pull-down: 3 sets (8 reps) (45kg) [compound]
      { set_reference_id: savedSetReferences[10].set_reference_id, weight: 43, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 30 Chest - Lateral Pull-down (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[10].set_reference_id, weight: 44, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 31 Chest - Lateral Pull-down (working) (1 week ago)
      { set_reference_id: savedSetReferences[10].set_reference_id, weight: 45, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now()) }, // 32 Chest - Lateral Pull-down (working) (now)

      { set_reference_id: savedSetReferences[11].set_reference_id, weight: 43, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 33 Chest - Lateral Pull-down (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[11].set_reference_id, weight: 44, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 34 Chest - Lateral Pull-down (working) (1 week ago)
      { set_reference_id: savedSetReferences[11].set_reference_id, weight: 45, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now()) }, // 35 Chest - Lateral Pull-down (working) (now)

      { set_reference_id: savedSetReferences[12].set_reference_id, weight: 43, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 36 Chest - Lateral Pull-down (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[12].set_reference_id, weight: 44, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 37 Chest - Lateral Pull-down (working) (1 week ago)
      { set_reference_id: savedSetReferences[12].set_reference_id, weight: 45, rep_count: 8, rest_time_before: 120, created_at: new Date(Date.now()) }, // 38 Chest - Lateral Pull-down (working) (now)

      // - Dumbbell Arm Curl: 3 sets (15 reps) (10kg) [isolation]
      { set_reference_id: savedSetReferences[13].set_reference_id, weight: 8, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 39 Chest - Dumbbell Arm Curl (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[13].set_reference_id, weight: 9, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 40 Chest - Dumbbell Arm Curl (working) (1 week ago)
      { set_reference_id: savedSetReferences[13].set_reference_id, weight: 10, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 41 Chest - Dumbbell Arm Curl (working) (now)

      { set_reference_id: savedSetReferences[14].set_reference_id, weight: 8, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 42 Chest - Dumbbell Arm Curl (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[14].set_reference_id, weight: 9, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 43 Chest - Dumbbell Arm Curl (working) (1 week ago)
      { set_reference_id: savedSetReferences[14].set_reference_id, weight: 10, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 44 Chest - Dumbbell Arm Curl (working) (now)

      { set_reference_id: savedSetReferences[15].set_reference_id, weight: 8, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 45 Chest - Dumbbell Arm Curl (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[15].set_reference_id, weight: 9, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 46 Chest - Dumbbell Arm Curl (working) (1 week ago)
      { set_reference_id: savedSetReferences[15].set_reference_id, weight: 10, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 47 Chest - Dumbbell Arm Curl (working) (now)

      // - Triceps Cable Extension: 3 sets (12 reps) (21kg) [isolation]
      { set_reference_id: savedSetReferences[16].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 48 Chest - Triceps Cable Extension (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[16].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 49 Chest - Triceps Cable Extension (working) (1 week ago)
      { set_reference_id: savedSetReferences[16].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 50 Chest - Triceps Cable Extension (working) (now)

      { set_reference_id: savedSetReferences[17].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 51 Chest - Triceps Cable Extension (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[17].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 52 Chest - Triceps Cable Extension (working) (1 week ago)
      { set_reference_id: savedSetReferences[17].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 53 Chest - Triceps Cable Extension (working) (now)

      { set_reference_id: savedSetReferences[18].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 54 Chest - Triceps Cable Extension (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[18].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 55 Chest - Triceps Cable Extension (working) (1 week ago)
      { set_reference_id: savedSetReferences[18].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 56 Chest - Triceps Cable Extension (working) (now)

      // - Face Pulls: 3 sets (12 reps) (21kg) [isolation]
      { set_reference_id: savedSetReferences[19].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 57 Chest - Face Pulls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[19].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 58 Chest - Face Pulls (working) (1 week ago)
      { set_reference_id: savedSetReferences[19].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 59 Chest - Face Pulls (working) (now)

      { set_reference_id: savedSetReferences[20].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 60 Chest - Face Pulls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[20].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 61 Chest - Face Pulls (working) (1 week ago)
      { set_reference_id: savedSetReferences[20].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 62 Chest - Face Pulls (working) (now)

      { set_reference_id: savedSetReferences[21].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 63 Chest - Face Pulls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[21].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 64 Chest - Face Pulls (working) (1 week ago)
      { set_reference_id: savedSetReferences[21].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 65 Chest - Face Pulls (working) (now)

      // - Dumbbell Side Raises: 3 sets (12 reps) (7kg) [isolation]
      { set_reference_id: savedSetReferences[22].set_reference_id, weight: 5, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 66 Chest - Dumbbell Side Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[22].set_reference_id, weight: 6, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 67 Chest - Dumbbell Side Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[22].set_reference_id, weight: 7, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 68 Chest - Dumbbell Side Raises (working) (now)

      { set_reference_id: savedSetReferences[23].set_reference_id, weight: 5, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 69 Chest - Dumbbell Side Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[23].set_reference_id, weight: 6, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 70 Chest - Dumbbell Side Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[23].set_reference_id, weight: 7, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 71 Chest - Dumbbell Side Raises (working) (now)

      { set_reference_id: savedSetReferences[24].set_reference_id, weight: 5, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 72 Chest - Dumbbell Side Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[24].set_reference_id, weight: 6, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 73 Chest - Dumbbell Side Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[24].set_reference_id, weight: 7, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 74 Chest - Dumbbell Side Raises (working) (now)


      //   Squats (Monday: day 0):
      // - Barbell Squats: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
      { set_reference_id: savedSetReferences[25].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 75 Squats - Barbell Squats (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[25].set_reference_id, weight: 39, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 76 Squats - Barbell Squats (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[25].set_reference_id, weight: 40, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 77 Squats - Barbell Squats (warmup) (now)

      { set_reference_id: savedSetReferences[26].set_reference_id, weight: 48, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 78 Squats - Barbell Squats (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[26].set_reference_id, weight: 49, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 79 Squats - Barbell Squats (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[26].set_reference_id, weight: 50, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 80 Squats - Barbell Squats (warmup) (now)

      { set_reference_id: savedSetReferences[27].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 81 Squats - Barbell Squats (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[27].set_reference_id, weight: 59, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 82 Squats - Barbell Squats (working) (1 week ago)
      { set_reference_id: savedSetReferences[27].set_reference_id, weight: 60, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 83 Squats - Barbell Squats (working) (now)

      { set_reference_id: savedSetReferences[28].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 84 Squats - Barbell Squats (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[28].set_reference_id, weight: 59, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 85 Squats - Barbell Squats (working) (1 week ago)
      { set_reference_id: savedSetReferences[28].set_reference_id, weight: 60, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 86 Squats - Barbell Squats (working) (now)

      { set_reference_id: savedSetReferences[29].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 87 Squats - Barbell Squats (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[29].set_reference_id, weight: 59, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 88 Squats - Barbell Squats (working) (1 week ago)
      { set_reference_id: savedSetReferences[29].set_reference_id, weight: 60, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 89 Squats - Barbell Squats (working) (now)

      // - Leg Press: 3 sets (12 reps) (100kg) [compound]
      { set_reference_id: savedSetReferences[30].set_reference_id, weight: 98, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 90 Squats - Leg Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[30].set_reference_id, weight: 99, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 91 Squats - Leg Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[30].set_reference_id, weight: 100, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 92 Squats - Leg Press (working) (now)

      { set_reference_id: savedSetReferences[31].set_reference_id, weight: 98, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 93 Squats - Leg Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[31].set_reference_id, weight: 99, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 94 Squats - Leg Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[31].set_reference_id, weight: 100, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 95 Squats - Leg Press (working) (now)

      { set_reference_id: savedSetReferences[32].set_reference_id, weight: 98, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 96 Squats - Leg Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[32].set_reference_id, weight: 99, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 97 Squats - Leg Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[32].set_reference_id, weight: 100, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 98 Squats - Leg Press (working) (now)

      // - Good Mornings: 3 sets (12 reps) (20kg) [compound]
      { set_reference_id: savedSetReferences[33].set_reference_id, weight: 18, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 99 Squats - Good Mornings (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[33].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 100 Squats - Good Mornings (working) (1 week ago)
      { set_reference_id: savedSetReferences[33].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 101 Squats - Good Mornings (working) (now)

      { set_reference_id: savedSetReferences[34].set_reference_id, weight: 18, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 102 Squats - Good Mornings (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[34].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 103 Squats - Good Mornings (working) (1 week ago)
      { set_reference_id: savedSetReferences[34].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 104 Squats - Good Mornings (working) (now)

      { set_reference_id: savedSetReferences[35].set_reference_id, weight: 18, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 105 Squats - Good Mornings (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[35].set_reference_id, weight: 19, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 106 Squats - Good Mornings (working) (1 week ago)
      { set_reference_id: savedSetReferences[35].set_reference_id, weight: 20, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 107 Squats - Good Mornings (working) (now)

      // - Lying Leg Curls: 3 sets (12 reps) (45kg) [isolation]
      { set_reference_id: savedSetReferences[36].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 108 Squats - Lying Leg Curls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[36].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 109 Squats - Lying Leg Curls (working) (1 week ago)
      { set_reference_id: savedSetReferences[36].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 110 Squats - Lying Leg Curls (working) (now)

      { set_reference_id: savedSetReferences[37].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 111 Squats - Lying Leg Curls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[37].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 112 Squats - Lying Leg Curls (working) (1 week ago)
      { set_reference_id: savedSetReferences[37].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 113 Squats - Lying Leg Curls (working) (now)

      { set_reference_id: savedSetReferences[38].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 114 Squats - Lying Leg Curls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[38].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 115 Squats - Lying Leg Curls (working) (1 week ago)
      { set_reference_id: savedSetReferences[38].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 116 Squats - Lying Leg Curls (working) (now)

      // - Standing Calf Raises: 3 sets (15 reps) (50kg) [isolation]
      { set_reference_id: savedSetReferences[39].set_reference_id, weight: 48, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 117 Squats - Standing Calf Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[39].set_reference_id, weight: 49, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 118 Squats - Standing Calf Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[39].set_reference_id, weight: 50, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 119 Squats - Standing Calf Raises (working) (now)

      { set_reference_id: savedSetReferences[40].set_reference_id, weight: 48, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 120 Squats - Standing Calf Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[40].set_reference_id, weight: 49, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 121 Squats - Standing Calf Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[40].set_reference_id, weight: 50, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 122 Squats - Standing Calf Raises (working) (now)

      { set_reference_id: savedSetReferences[41].set_reference_id, weight: 48, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 123 Squats - Standing Calf Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[41].set_reference_id, weight: 49, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 124 Squats - Standing Calf Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[41].set_reference_id, weight: 50, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 125 Squats - Standing Calf Raises (working) (now)

      // - Abs leg raises: 3 sets (15 reps) (body weight) [isolation]
      { set_reference_id: savedSetReferences[42].set_reference_id, weight_text: "body weight", rep_count: 13, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 126 Squats - Abs leg raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[42].set_reference_id, weight_text: "body weight", rep_count: 14, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 127 Squats - Abs leg raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[42].set_reference_id, weight_text: "body weight", rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 128 Squats - Abs leg raises (working) (now)

      { set_reference_id: savedSetReferences[43].set_reference_id, weight_text: "body weight", rep_count: 13, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 129 Squats - Abs leg raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[43].set_reference_id, weight_text: "body weight", rep_count: 14, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 130 Squats - Abs leg raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[43].set_reference_id, weight_text: "body weight", rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 131 Squats - Abs leg raises (working) (now)

      { set_reference_id: savedSetReferences[44].set_reference_id, weight_text: "body weight", rep_count: 13, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 132 Squats - Abs leg raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[44].set_reference_id, weight_text: "body weight", rep_count: 14, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 133 Squats - Abs leg raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[44].set_reference_id, weight_text: "body weight", rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 134 Squats - Abs leg raises (working) (now)

      //   Shoulders (Wednesday: day 2):
      // - Overhead Press: 2 warmup sets (5 reps) (20kg, 30kg), 3 working sets (5 reps) (40kg) [compound]
      { set_reference_id: savedSetReferences[45].set_reference_id, weight: 18, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 135 Shoulders - Overhead Press (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[45].set_reference_id, weight: 19, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 136 Shoulders - Overhead Press (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[45].set_reference_id, weight: 20, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 137 Shoulders - Overhead Press (warmup) (now)

      { set_reference_id: savedSetReferences[46].set_reference_id, weight: 28, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 138 Shoulders - Overhead Press (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[46].set_reference_id, weight: 29, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 139 Shoulders - Overhead Press (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[46].set_reference_id, weight: 30, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 140 Shoulders - Overhead Press (warmup) (now)

      { set_reference_id: savedSetReferences[47].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 141 Shoulders - Overhead Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[47].set_reference_id, weight: 39, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 142 Shoulders - Overhead Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[47].set_reference_id, weight: 40, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 143 Shoulders - Overhead Press (working) (now)

      { set_reference_id: savedSetReferences[48].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 144 Shoulders - Overhead Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[48].set_reference_id, weight: 39, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 145 Shoulders - Overhead Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[48].set_reference_id, weight: 40, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 146 Shoulders - Overhead Press (working) (now)

      { set_reference_id: savedSetReferences[49].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 147 Shoulders - Overhead Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[49].set_reference_id, weight: 39, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 148 Shoulders - Overhead Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[49].set_reference_id, weight: 40, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 149 Shoulders - Overhead Press (working) (now)

      // - Pull-ups: 3 set (5 reps) (body weight) [compound]
      { set_reference_id: savedSetReferences[50].set_reference_id, weight_text: "body weight", rep_count: 3, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 150 Shoulders - Pull-ups (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[50].set_reference_id, weight_text: "body weight", rep_count: 4, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 151 Shoulders - Pull-ups (working) (1 week ago)
      { set_reference_id: savedSetReferences[50].set_reference_id, weight_text: "body weight", rep_count: 5, rest_time_before: 120, created_at: new Date(Date.now()) }, // 152 Shoulders - Pull-ups (working) (now)

      { set_reference_id: savedSetReferences[51].set_reference_id, weight_text: "body weight", rep_count: 3, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 153 Shoulders - Pull-ups (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[51].set_reference_id, weight_text: "body weight", rep_count: 4, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 154 Shoulders - Pull-ups (working) (1 week ago)
      { set_reference_id: savedSetReferences[51].set_reference_id, weight_text: "body weight", rep_count: 5, rest_time_before: 120, created_at: new Date(Date.now()) }, // 155 Shoulders - Pull-ups (working) (now)

      { set_reference_id: savedSetReferences[52].set_reference_id, weight_text: "body weight", rep_count: 3, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 156 Shoulders - Pull-ups (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[52].set_reference_id, weight_text: "body weight", rep_count: 4, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 157 Shoulders - Pull-ups (working) (1 week ago)
      { set_reference_id: savedSetReferences[52].set_reference_id, weight_text: "body weight", rep_count: 5, rest_time_before: 120, created_at: new Date(Date.now()) }, // 158 Shoulders - Pull-ups (working) (now)

      // - Pendley Rows: 3 sets (12 reps) (40kg) [compound]
      { set_reference_id: savedSetReferences[53].set_reference_id, weight: 38, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 159 Shoulders - Pendley Rows (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[53].set_reference_id, weight: 39, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 160 Shoulders - Pendley Rows (working) (1 week ago)
      { set_reference_id: savedSetReferences[53].set_reference_id, weight: 40, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 161 Shoulders - Pendley Rows (working) (now)

      { set_reference_id: savedSetReferences[54].set_reference_id, weight: 38, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 162 Shoulders - Pendley Rows (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[54].set_reference_id, weight: 39, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 163 Shoulders - Pendley Rows (working) (1 week ago)
      { set_reference_id: savedSetReferences[54].set_reference_id, weight: 40, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 164 Shoulders - Pendley Rows (working) (now)

      { set_reference_id: savedSetReferences[55].set_reference_id, weight: 38, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 165 Shoulders - Pendley Rows (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[55].set_reference_id, weight: 39, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 166 Shoulders - Pendley Rows (working) (1 week ago)
      { set_reference_id: savedSetReferences[55].set_reference_id, weight: 40, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 167 Shoulders - Pendley Rows (working) (now)

      // - Seated Chest Press: 3 sets (12 reps) (60kg) [isolation]
      { set_reference_id: savedSetReferences[56].set_reference_id, weight: 58, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 168 Shoulders - Seated Chest Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[56].set_reference_id, weight: 59, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 169 Shoulders - Seated Chest Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[56].set_reference_id, weight: 60, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 170 Shoulders - Seated Chest Press (working) (now)

      { set_reference_id: savedSetReferences[57].set_reference_id, weight: 58, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 171 Shoulders - Seated Chest Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[57].set_reference_id, weight: 59, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 172 Shoulders - Seated Chest Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[57].set_reference_id, weight: 60, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 173 Shoulders - Seated Chest Press (working) (now)

      { set_reference_id: savedSetReferences[58].set_reference_id, weight: 58, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 174 Shoulders - Seated Chest Press (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[58].set_reference_id, weight: 59, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 175 Shoulders - Seated Chest Press (working) (1 week ago)
      { set_reference_id: savedSetReferences[58].set_reference_id, weight: 60, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 176 Shoulders - Seated Chest Press (working) (now)

      // - Dumbbell Arm Curl: 3 sets (15 reps) (12kg) [isolation] (exercise already exists, but unique set details)
      { set_reference_id: savedSetReferences[59].set_reference_id, weight: 10, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 177 Shoulders - Dumbbell Arm Curl (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[59].set_reference_id, weight: 11, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 178 Shoulders - Dumbbell Arm Curl (working) (1 week ago)
      { set_reference_id: savedSetReferences[59].set_reference_id, weight: 12, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 179 Shoulders - Dumbbell Arm Curl (working) (now)

      { set_reference_id: savedSetReferences[60].set_reference_id, weight: 10, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 180 Shoulders - Dumbbell Arm Curl (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[60].set_reference_id, weight: 11, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 181 Shoulders - Dumbbell Arm Curl (working) (1 week ago)
      { set_reference_id: savedSetReferences[60].set_reference_id, weight: 12, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 182 Shoulders - Dumbbell Arm Curl (working) (now)

      { set_reference_id: savedSetReferences[61].set_reference_id, weight: 10, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 183 Shoulders - Dumbbell Arm Curl (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[61].set_reference_id, weight: 11, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 184 Shoulders - Dumbbell Arm Curl (working) (1 week ago)
      { set_reference_id: savedSetReferences[61].set_reference_id, weight: 12, rep_count: 15, rest_time_before: 120, created_at: new Date(Date.now()) }, // 185 Shoulders - Dumbbell Arm Curl (working) (now)

      // - Triceps Cable Extension: 3 sets (12 reps) (23kg) [isolation] (exercise already exists, but unique set details)
      { set_reference_id: savedSetReferences[62].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 186 Shoulders - Triceps Cable Extension (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[62].set_reference_id, weight: 22, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 187 Shoulders - Triceps Cable Extension (working) (1 week ago)
      { set_reference_id: savedSetReferences[62].set_reference_id, weight: 23, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 188 Shoulders - Triceps Cable Extension (working) (now)

      { set_reference_id: savedSetReferences[63].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 189 Shoulders - Triceps Cable Extension (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[63].set_reference_id, weight: 22, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 190 Shoulders - Triceps Cable Extension (working) (1 week ago)
      { set_reference_id: savedSetReferences[63].set_reference_id, weight: 23, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 191 Shoulders - Triceps Cable Extension (working) (now)

      { set_reference_id: savedSetReferences[64].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 192 Shoulders - Triceps Cable Extension (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[64].set_reference_id, weight: 22, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 193 Shoulders - Triceps Cable Extension (working) (1 week ago)
      { set_reference_id: savedSetReferences[64].set_reference_id, weight: 23, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 194 Shoulders - Triceps Cable Extension (working) (now)

      // - Face Pulls: 3 sets (12 reps) (23kg) [isolation] (exercise already exists, but unique set details)
      { set_reference_id: savedSetReferences[65].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 195 Shoulders - Face Pulls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[65].set_reference_id, weight: 22, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 196 Shoulders - Face Pulls (working) (1 week ago)
      { set_reference_id: savedSetReferences[65].set_reference_id, weight: 23, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 197 Shoulders - Face Pulls (working) (now)

      { set_reference_id: savedSetReferences[66].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 198 Shoulders - Face Pulls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[66].set_reference_id, weight: 22, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 199 Shoulders - Face Pulls (working) (1 week ago)
      { set_reference_id: savedSetReferences[66].set_reference_id, weight: 23, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 200 Shoulders - Face Pulls (working) (now)

      { set_reference_id: savedSetReferences[67].set_reference_id, weight: 21, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 201 Shoulders - Face Pulls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[67].set_reference_id, weight: 22, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 202 Shoulders - Face Pulls (working) (1 week ago)
      { set_reference_id: savedSetReferences[67].set_reference_id, weight: 23, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 203 Shoulders - Face Pulls (working) (now)

      // - Dumbbell Side Raises: 3 sets (12 reps) (8kg) [isolation] (exercise already exists, but unique set details)
      { set_reference_id: savedSetReferences[68].set_reference_id, weight: 6, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 204 Shoulders - Dumbbell Side Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[68].set_reference_id, weight: 7, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 205 Shoulders - Dumbbell Side Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[68].set_reference_id, weight: 8, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 206 Shoulders - Dumbbell Side Raises (working) (now)

      { set_reference_id: savedSetReferences[69].set_reference_id, weight: 6, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 207 Shoulders - Dumbbell Side Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[69].set_reference_id, weight: 7, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 208 Shoulders - Dumbbell Side Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[69].set_reference_id, weight: 8, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 209 Shoulders - Dumbbell Side Raises (working) (now)

      { set_reference_id: savedSetReferences[70].set_reference_id, weight: 6, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 12096e5) }, // 210 Shoulders - Dumbbell Side Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[70].set_reference_id, weight: 7, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now() - 6048e5) }, // 211 Shoulders - Dumbbell Side Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[70].set_reference_id, weight: 8, rep_count: 12, rest_time_before: 120, created_at: new Date(Date.now()) }, // 212 Shoulders - Dumbbell Side Raises (working) (now)

      //   Deadlifts (Thursday: day 3):
      // - Romanian Deadlifts: 2 warmup sets (7 reps) (60kg, 80kg), 3 working sets (7 reps) (100kg) [compound]
      { set_reference_id: savedSetReferences[71].set_reference_id, weight: 58, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 213 Deadlifts - Romanian Deadlifts (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[71].set_reference_id, weight: 78, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 214 Deadlifts - Romanian Deadlifts (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[71].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now()) }, // 215 Deadlifts - Romanian Deadlifts (warmup) (now)

      { set_reference_id: savedSetReferences[72].set_reference_id, weight: 58, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 216 Deadlifts - Romanian Deadlifts (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[72].set_reference_id, weight: 78, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 217 Deadlifts - Romanian Deadlifts (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[72].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now()) }, // 218 Deadlifts - Romanian Deadlifts (warmup) (now)

      { set_reference_id: savedSetReferences[73].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 219 Deadlifts - Romanian Deadlifts (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[73].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 220 Deadlifts - Romanian Deadlifts (working) (1 week ago)
      { set_reference_id: savedSetReferences[73].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now()) }, // 221 Deadlifts - Romanian Deadlifts (working) (now)

      { set_reference_id: savedSetReferences[74].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 222 Deadlifts - Romanian Deadlifts (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[74].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 223 Deadlifts - Romanian Deadlifts (working) (1 week ago)
      { set_reference_id: savedSetReferences[74].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now()) }, // 224 Deadlifts - Romanian Deadlifts (working) (now)

      { set_reference_id: savedSetReferences[75].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 225 Deadlifts - Romanian Deadlifts (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[75].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 226 Deadlifts - Romanian Deadlifts (working) (1 week ago)
      { set_reference_id: savedSetReferences[75].set_reference_id, weight: 98, rep_count: 7, rest_time_before: 300, created_at: new Date(Date.now()) }, // 227 Deadlifts - Romanian Deadlifts (working) (now)

      // - Front Squats: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
      { set_reference_id: savedSetReferences[76].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 228 Deadlifts - Front Squats (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[76].set_reference_id, weight: 48, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 229 Deadlifts - Front Squats (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[76].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 230 Deadlifts - Front Squats (warmup) (now)

      { set_reference_id: savedSetReferences[77].set_reference_id, weight: 38, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 231 Deadlifts - Front Squats (warmup) (2 weeks ago)
      { set_reference_id: savedSetReferences[77].set_reference_id, weight: 48, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 232 Deadlifts - Front Squats (warmup) (1 week ago)
      { set_reference_id: savedSetReferences[77].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 233 Deadlifts - Front Squats (warmup) (now)

      { set_reference_id: savedSetReferences[78].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 234 Deadlifts - Front Squats (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[78].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 235 Deadlifts - Front Squats (working) (1 week ago)
      { set_reference_id: savedSetReferences[78].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 236 Deadlifts - Front Squats (working) (now)

      { set_reference_id: savedSetReferences[79].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 237 Deadlifts - Front Squats (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[79].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 238 Deadlifts - Front Squats (working) (1 week ago)
      { set_reference_id: savedSetReferences[79].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 239 Deadlifts - Front Squats (working) (now)

      { set_reference_id: savedSetReferences[80].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 240 Deadlifts - Front Squats (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[80].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 241 Deadlifts - Front Squats (working) (1 week ago)
      { set_reference_id: savedSetReferences[80].set_reference_id, weight: 58, rep_count: 5, rest_time_before: 300, created_at: new Date(Date.now()) }, // 242 Deadlifts - Front Squats (working) (now)

      // - Hip Thrusts: 3 sets (12 reps) (30kg) [compound]
      { set_reference_id: savedSetReferences[81].set_reference_id, weight: 28, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 243 Deadlifts - Hip Thrusts (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[81].set_reference_id, weight: 29, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 244 Deadlifts - Hip Thrusts (working) (1 week ago)
      { set_reference_id: savedSetReferences[81].set_reference_id, weight: 30, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 245 Deadlifts - Hip Thrusts (working) (now)

      { set_reference_id: savedSetReferences[82].set_reference_id, weight: 28, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 246 Deadlifts - Hip Thrusts (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[82].set_reference_id, weight: 29, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 247 Deadlifts - Hip Thrusts (working) (1 week ago)
      { set_reference_id: savedSetReferences[82].set_reference_id, weight: 30, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 248 Deadlifts - Hip Thrusts (working) (now)

      { set_reference_id: savedSetReferences[83].set_reference_id, weight: 28, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 249 Deadlifts - Hip Thrusts (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[83].set_reference_id, weight: 29, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 250 Deadlifts - Hip Thrusts (working) (1 week ago)
      { set_reference_id: savedSetReferences[83].set_reference_id, weight: 30, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 251 Deadlifts - Hip Thrusts (working) (now)

      // - Leg Extensions: 3 sets (12 reps) (45kg) [isolation]
      { set_reference_id: savedSetReferences[84].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 252 Deadlifts - Leg Extensions (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[84].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 253 Deadlifts - Leg Extensions (working) (1 week ago)
      { set_reference_id: savedSetReferences[84].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 254 Deadlifts - Leg Extensions (working) (now)

      { set_reference_id: savedSetReferences[85].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 255 Deadlifts - Leg Extensions (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[85].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 256 Deadlifts - Leg Extensions (working) (1 week ago)
      { set_reference_id: savedSetReferences[85].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 257 Deadlifts - Leg Extensions (working) (now)

      { set_reference_id: savedSetReferences[86].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 258 Deadlifts - Leg Extensions (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[86].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 259 Deadlifts - Leg Extensions (working) (1 week ago)
      { set_reference_id: savedSetReferences[86].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 260 Deadlifts - Leg Extensions (working) (now)

      // - Seated Leg Curls: 3 sets (12 reps) (45kg) [isolation]
      { set_reference_id: savedSetReferences[87].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 261 Deadlifts - Seated Leg Curls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[87].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 262 Deadlifts - Seated Leg Curls (working) (1 week ago)
      { set_reference_id: savedSetReferences[87].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 263 Deadlifts - Seated Leg Curls (working) (now)

      { set_reference_id: savedSetReferences[88].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 264 Deadlifts - Seated Leg Curls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[88].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 265 Deadlifts - Seated Leg Curls (working) (1 week ago)
      { set_reference_id: savedSetReferences[88].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 266 Deadlifts - Seated Leg Curls (working) (now)

      { set_reference_id: savedSetReferences[89].set_reference_id, weight: 43, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 267 Deadlifts - Seated Leg Curls (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[89].set_reference_id, weight: 44, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 268 Deadlifts - Seated Leg Curls (working) (1 week ago)
      { set_reference_id: savedSetReferences[89].set_reference_id, weight: 45, rep_count: 12, rest_time_before: 300, created_at: new Date(Date.now()) }, // 269 Deadlifts - Seated Leg Curls (working) (now)

      // - Standing Calf Raises: 3 sets (15 reps) (52kg) [isolation] (exercise already exists, but unique set details)
      { set_reference_id: savedSetReferences[90].set_reference_id, weight: 50, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 270 Deadlifts - Standing Calf Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[90].set_reference_id, weight: 51, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 271 Deadlifts - Standing Calf Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[90].set_reference_id, weight: 52, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now()) }, // 272 Deadlifts - Standing Calf Raises (working) (now)

      { set_reference_id: savedSetReferences[91].set_reference_id, weight: 50, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 273 Deadlifts - Standing Calf Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[91].set_reference_id, weight: 51, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 274 Deadlifts - Standing Calf Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[91].set_reference_id, weight: 52, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now()) }, // 275 Deadlifts - Standing Calf Raises (working) (now)

      { set_reference_id: savedSetReferences[92].set_reference_id, weight: 50, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 276 Deadlifts - Standing Calf Raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[92].set_reference_id, weight: 51, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 277 Deadlifts - Standing Calf Raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[92].set_reference_id, weight: 52, rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now()) }, // 278 Deadlifts - Standing Calf Raises (working) (now)

      // - Abs leg raises: 3 sets (15 reps) (body weight) [isolation] (exercise already exists, but unique set details)
      { set_reference_id: savedSetReferences[93].set_reference_id, weight_text: "body weight", rep_count: 13, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 279 Deadlifts - Abs leg raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[93].set_reference_id, weight_text: "body weight", rep_count: 14, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 280 Deadlifts - Abs leg raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[93].set_reference_id, weight_text: "body weight", rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now()) }, // 281 Deadlifts - Abs leg raises (working) (now)

      { set_reference_id: savedSetReferences[94].set_reference_id, weight_text: "body weight", rep_count: 13, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 282 Deadlifts - Abs leg raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[94].set_reference_id, weight_text: "body weight", rep_count: 14, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 283 Deadlifts - Abs leg raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[94].set_reference_id, weight_text: "body weight", rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now()) }, // 284 Deadlifts - Abs leg raises (working) (now)

      { set_reference_id: savedSetReferences[95].set_reference_id, weight_text: "body weight", rep_count: 13, rest_time_before: 300, created_at: new Date(Date.now() - 12096e5) }, // 285 Deadlifts - Abs leg raises (working) (2 weeks ago)
      { set_reference_id: savedSetReferences[95].set_reference_id, weight_text: "body weight", rep_count: 14, rest_time_before: 300, created_at: new Date(Date.now() - 6048e5) }, // 286 Deadlifts - Abs leg raises (working) (1 week ago)
      { set_reference_id: savedSetReferences[95].set_reference_id, weight_text: "body weight", rep_count: 15, rest_time_before: 300, created_at: new Date(Date.now()) }, // 287 Deadlifts - Abs leg raises (working) (now)
    ];

    const savedSetDetails = await setDetailRepository.save(setDetails);

    const completedWorkouts: Partial<CompletedWorkoutEntity>[] = [
      { user_uid, workout_id: savedWorkouts[0].workout_id, started_at: new Date(Date.now() - 6048e5), is_active: false }, // 0 Chest (1 week ago)
      { user_uid, workout_id: savedWorkouts[1].workout_id, started_at: new Date(Date.now() - 6048e5), is_active: false }, // 1 Squats (1 week ago)
      { user_uid, workout_id: savedWorkouts[2].workout_id, started_at: new Date(Date.now() - 6048e5), is_active: false }, // 2 Shoulders (1 week ago)
      { user_uid, workout_id: savedWorkouts[3].workout_id, started_at: new Date(Date.now() - 6048e5), is_active: false }, // 3 Deadlifts (1 week ago)

      { user_uid, workout_id: savedWorkouts[0].workout_id, started_at: new Date(Date.now()), is_active: false }, // 4 Chest
      { user_uid, workout_id: savedWorkouts[1].workout_id, started_at: new Date(Date.now()), is_active: false }, // 5 Squats
      { user_uid, workout_id: savedWorkouts[2].workout_id, started_at: new Date(Date.now()), is_active: false }, // 6 Shoulders
      { user_uid, workout_id: savedWorkouts[3].workout_id, started_at: new Date(Date.now()), is_active: false }, // 7 Deadlifts
    ];

    const savedCompletedWorkouts = await completedWorkoutRepository.save(completedWorkouts);

    const completedSets: Partial<CompletedSetEntity>[] = [
      //   Chest (Sunday: day 6):
      // - Bench Press: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
      { set_detail_id: savedSetDetails[0].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 38, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[1].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 39, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[3].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 48, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[4].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 49, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[6].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[7].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[9].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[10].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[12].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[13].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[0].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      // - Incline Bench Press: 2 warmup sets (12 reps) (12kg, 16kg), 3 working sets (12 reps) (20kg) [compound]
      { set_detail_id: savedSetDetails[15].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 10, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[16].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 11, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[18].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 14, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[19].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 15, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[21].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 18, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[22].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[24].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 18, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[25].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[27].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 18, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[28].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[1].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Lateral Pull-down: 3 sets (8 reps) (45kg) [compound]
      { set_detail_id: savedSetDetails[30].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[2].exercise_id, rep_count: 8, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[31].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[2].exercise_id, rep_count: 8, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[33].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[2].exercise_id, rep_count: 8, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[34].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[2].exercise_id, rep_count: 8, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[36].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[2].exercise_id, rep_count: 8, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[37].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[2].exercise_id, rep_count: 8, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Dumbbell Arm Curl: 3 sets (15 reps) (10kg) [isolation]
      { set_detail_id: savedSetDetails[39].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 8, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[40].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 9, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[42].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 8, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[43].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 9, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[45].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 8, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[46].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 9, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Triceps Cable Extension: 3 sets (12 reps) (21kg) [isolation]
      { set_detail_id: savedSetDetails[48].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[49].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 20, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[51].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[52].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 20, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[54].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[55].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 20, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Face Pulls: 3 sets (12 reps) (21kg) [isolation]
      { set_detail_id: savedSetDetails[57].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[58].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 20, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[60].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[61].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 20, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[63].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[64].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 20, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Dumbbell Side Raises: 3 sets (12 reps) (7kg) [isolation]
      { set_detail_id: savedSetDetails[66].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 5, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[67].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 6, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[69].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 5, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[70].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 6, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[72].set_detail_id, completed_workout_id: savedCompletedWorkouts[0].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 5, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[73].set_detail_id, completed_workout_id: savedCompletedWorkouts[4].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 6, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      //   Squats (Monday: day 0):
      // - Barbell Squats: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
      { set_detail_id: savedSetDetails[75].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 38, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[76].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 39, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[78].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 48, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[79].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 49, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[81].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[82].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[84].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[85].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[87].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[88].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[7].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      // - Leg Press: 3 sets (12 reps) (100kg) [compound]
      { set_detail_id: savedSetDetails[90].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[8].exercise_id, rep_count: 12, weight: 98, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[91].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[8].exercise_id, rep_count: 12, weight: 99, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[93].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[8].exercise_id, rep_count: 12, weight: 98, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[94].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[8].exercise_id, rep_count: 12, weight: 99, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[96].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[8].exercise_id, rep_count: 12, weight: 98, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[97].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[8].exercise_id, rep_count: 12, weight: 99, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Good Mornings: 3 sets (12 reps) (20kg) [compound]
      { set_detail_id: savedSetDetails[99].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[9].exercise_id, rep_count: 12, weight: 18, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[100].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[9].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[102].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[9].exercise_id, rep_count: 12, weight: 18, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[103].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[9].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[105].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[9].exercise_id, rep_count: 12, weight: 18, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[106].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[9].exercise_id, rep_count: 12, weight: 19, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Lying Leg Curls: 3 sets (12 reps) (45kg) [isolation]
      { set_detail_id: savedSetDetails[108].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[10].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[109].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[10].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[111].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[10].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[112].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[10].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[114].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[10].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[115].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[10].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Standing Calf Raises: 3 sets (15 reps) (50kg) [isolation]
      { set_detail_id: savedSetDetails[117].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 48, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[118].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 49, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[120].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 48, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[121].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 49, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[123].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 48, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[124].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 49, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Abs leg raises: 3 sets (15 reps) (body weight) [isolation]
      { set_detail_id: savedSetDetails[126].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight: 0, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[127].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight: 0, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[129].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight: 0, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[130].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight: 0, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[132].set_detail_id, completed_workout_id: savedCompletedWorkouts[1].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight: 0, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[133].set_detail_id, completed_workout_id: savedCompletedWorkouts[5].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight: 0, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      //   Shoulders (Wednesday: day 2):
      // - Overhead Press: 2 warmup sets (5 reps) (20kg, 30kg), 3 working sets (5 reps) (40kg) [compound]
      { set_detail_id: savedSetDetails[135].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 18, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[136].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 19, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[138].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 28, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[139].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 29, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[141].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 38, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[142].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 39, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[144].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 38, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[145].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 39, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[147].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 38, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[148].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[13].exercise_id, rep_count: 5, weight: 39, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      // - Pull-ups: 3 set (5 reps) (body weight) [compound]
      { set_detail_id: savedSetDetails[150].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[14].exercise_id, rep_count: 5, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[151].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[14].exercise_id, rep_count: 5, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[153].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[14].exercise_id, rep_count: 5, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[154].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[14].exercise_id, rep_count: 5, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[156].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[14].exercise_id, rep_count: 5, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[157].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[14].exercise_id, rep_count: 5, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Pendley Rows: 3 sets (12 reps) (40kg) [compound]
      { set_detail_id: savedSetDetails[159].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[15].exercise_id, rep_count: 12, weight: 38, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[160].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[15].exercise_id, rep_count: 12, weight: 39, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[162].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[15].exercise_id, rep_count: 12, weight: 38, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[163].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[15].exercise_id, rep_count: 12, weight: 39, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[165].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[15].exercise_id, rep_count: 12, weight: 38, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[166].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[15].exercise_id, rep_count: 12, weight: 39, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Seated Chest Press: 3 sets (12 reps) (60kg) [isolation]
      { set_detail_id: savedSetDetails[168].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[16].exercise_id, rep_count: 12, weight: 58, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[169].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[16].exercise_id, rep_count: 12, weight: 59, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[171].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[16].exercise_id, rep_count: 12, weight: 58, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[172].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[16].exercise_id, rep_count: 12, weight: 59, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[174].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[16].exercise_id, rep_count: 12, weight: 58, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[175].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[16].exercise_id, rep_count: 12, weight: 59, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Dumbbell Arm Curl: 3 sets (15 reps) (12kg) [isolation] (exercise already exists, but unique set details)
      { set_detail_id: savedSetDetails[177].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 10, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[178].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 11, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[180].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 10, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[181].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 11, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[183].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 10, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[184].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[3].exercise_id, rep_count: 15, weight: 11, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Triceps Cable Extension: 3 sets (12 reps) (23kg) [isolation] (exercise already exists, but unique set details)
      { set_detail_id: savedSetDetails[186].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 21, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[187].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 22, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[189].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 21, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[190].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 22, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[192].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 21, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[193].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[4].exercise_id, rep_count: 12, weight: 22, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Face Pulls: 3 sets (12 reps) (23kg) [isolation] (exercise already exists, but unique set details)
      { set_detail_id: savedSetDetails[195].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 21, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[196].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 22, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[198].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 21, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[199].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 22, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[201].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 21, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[202].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[5].exercise_id, rep_count: 12, weight: 22, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Dumbbell Side Raises: 3 sets (12 reps) (8kg) [isolation] (exercise already exists, but unique set details)
      { set_detail_id: savedSetDetails[204].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 6, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[205].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 7, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[207].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 6, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[208].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 7, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[210].set_detail_id, completed_workout_id: savedCompletedWorkouts[2].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 6, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[211].set_detail_id, completed_workout_id: savedCompletedWorkouts[6].completed_workout_id, exercise_id: savedExercises[6].exercise_id, rep_count: 12, weight: 7, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      //   Deadlifts (Thursday: day 3):
      // - Romanian Deadlifts: 2 warmup sets (7 reps) (60kg, 80kg), 3 working sets (7 reps) (100kg) [compound]
      { set_detail_id: savedSetDetails[213].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[214].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[216].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 78, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[217].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 79, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[219].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 98, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[220].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 99, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[222].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 98, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[223].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 99, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[225].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 98, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[226].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[17].exercise_id, rep_count: 7, weight: 99, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      // - Front Squats: 2 warmup sets (5 reps) (40kg, 50kg), 3 working sets (5 reps) (60kg) [compound]
      { set_detail_id: savedSetDetails[228].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 38, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[229].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 39, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[231].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 48, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[232].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 49, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[234].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[235].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[237].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[238].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[240].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 58, rest_time_before: 300, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[241].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[18].exercise_id, rep_count: 5, weight: 59, rest_time_before: 300, completed_at: new Date(Date.now()), is_active: false },

      // - Hip Thrusts: 3 sets (12 reps) (30kg) [compound]
      { set_detail_id: savedSetDetails[243].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[19].exercise_id, rep_count: 12, weight: 28, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[244].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[19].exercise_id, rep_count: 12, weight: 29, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[246].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[19].exercise_id, rep_count: 12, weight: 28, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[247].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[19].exercise_id, rep_count: 12, weight: 29, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[249].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[19].exercise_id, rep_count: 12, weight: 28, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[250].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[19].exercise_id, rep_count: 12, weight: 29, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Leg Extensions: 3 sets (12 reps) (45kg) [isolation]
      { set_detail_id: savedSetDetails[252].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[20].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[253].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[20].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[255].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[20].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[256].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[20].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[258].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[20].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[259].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[20].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Seated Leg Curls: 3 sets (12 reps) (45kg) [isolation]
      { set_detail_id: savedSetDetails[261].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[21].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[262].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[21].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[264].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[21].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[265].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[21].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[267].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[21].exercise_id, rep_count: 12, weight: 43, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[268].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[21].exercise_id, rep_count: 12, weight: 44, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Standing Calf Raises: 3 sets (15 reps) (52kg) [isolation] (exercise already exists, but unique set details)
      { set_detail_id: savedSetDetails[270].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 50, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[271].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 51, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[273].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 50, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[274].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 51, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[276].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 50, rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[277].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[11].exercise_id, rep_count: 15, weight: 51, rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      // - Abs leg raises: 3 sets (15 reps) (body weight) [isolation] (exercise already exists, but unique set details)
      { set_detail_id: savedSetDetails[279].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[280].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[282].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[283].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },

      { set_detail_id: savedSetDetails[285].set_detail_id, completed_workout_id: savedCompletedWorkouts[3].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now() - 6048e5), is_active: false },
      { set_detail_id: savedSetDetails[286].set_detail_id, completed_workout_id: savedCompletedWorkouts[7].completed_workout_id, exercise_id: savedExercises[12].exercise_id, rep_count: 15, weight_text: "body weight", rest_time_before: 120, completed_at: new Date(Date.now()), is_active: false },
    ];

    await completedSetRepository.save(completedSets);

    res.json({ message: "Data initialized successfully" });
  } catch (error) {
    console.error("Error while initializing data:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});

export default router;