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

async function insertnsertWorkouts(): Promise<WorkoutEntity[]> {
  const workouts: Partial<WorkoutEntity>[] = [
    {
      user_uid,
      name: "Chest",
      day_of_week: 6,
      note: "This chest workout focuses on building strength and hypertrophy in the pectoral muscles. Ensure proper warm-up before starting and maintain good form throughout.",
    },
    {
      user_uid,
      name: "Squats",
      day_of_week: 0,
      note: "Leg day! This workout targets the quads, hamstrings, and glutes. Remember to keep your back straight and push from your heels when performing squats.",
    },
    {
      user_uid,
      name: "Shoulders",
      day_of_week: 2,
      note: "Target your deltoids with this shoulder workout. Focus on controlled movements and avoid using momentum.",
    },
    {
      user_uid,
      name: "Deadlifts",
      day_of_week: 3,
      note: "Strengthen your posterior chain, including your back, glutes, and hamstrings. Always keep a neutral spine and engage your core during deadlifts.",
    },
  ];

  let savedWorkouts: WorkoutEntity[] = [];
  try {
    savedWorkouts = await workoutRepository.save(workouts);
  } catch (error) {
    console.log("Error while saving workouts:", error);
  }

  return savedWorkouts;
}

async function insertExercises() {
  const exercises: Partial<ExerciseEntity>[] = [
    {
      user_uid,
      name: "Bench Press",
      note: "Compound movement using a barbell. Lie flat on a bench and press the barbell up while keeping your feet flat on the ground. Targets the chest, shoulders, and triceps.",
    },
    {
      user_uid,
      name: "Inclined Dumbbell Bench Press",
      note: "Compound movement using dumbbells on an inclined bench. Targets the upper chest and front deltoids.",
    },
    {
      user_uid,
      name: "Lateral Pull-down",
      note: "Compound movement using a cable machine. Sit down, grip the bar wider than shoulder-width, and pull down to chest level. Targets the latissimus dorsi.",
    },
    {
      user_uid,
      name: "Dumbbell Arm Curl",
      note: "Isolation movement for biceps using dumbbells. Keep your elbows close to your torso and curl the weights.",
    },
    {
      user_uid,
      name: "Triceps Cable Extension",
      note: "Isolation movement using a cable machine with a rope or bar attachment. Targets the triceps.",
    },
    {
      user_uid,
      name: "Face Pulls",
      note: "Isolation movement using a cable machine with a rope attachment. Pull the rope towards your face, targeting rear deltoids and upper traps.",
    },
    {
      user_uid,
      name: "Dumbbell Side Raises",
      note: "Isolation movement using dumbbells. Raise arms to the sides until they're parallel with the ground. Targets lateral deltoids.",
    },
    {
      user_uid,
      name: "Barbell Squats",
      note: "Compound movement using a barbell. Keep your back straight and squat down until thighs are parallel with the ground. Targets quads, hamstrings, and glutes.",
    },
    {
      user_uid,
      name: "Leg Press",
      note: "Compound movement using the leg press machine. Place your feet shoulder-width apart and press the weight up. Targets quads and glutes.",
    },
    {
      user_uid,
      name: "Good Mornings",
      note: "Compound movement using a barbell. Keep a slight bend in the knees and hinge at the hips. Targets hamstrings and lower back.",
    },
    {
      user_uid,
      name: "Lying Leg Curls",
      note: "Isolation movement using the leg curl machine. Curl the weight towards your glutes, targeting the hamstrings.",
    },
    {
      user_uid,
      name: "Standing Calf Raises",
      note: "Isolation movement using a calf raise machine or dumbbells. Raise your heels off the ground to work the calves.",
    },
    {
      user_uid,
      name: "Abs leg raises",
      note: "Isolation movement for the abdominal muscles. Lie flat on the ground, keep your legs straight, and raise them up and down.",
    },
    {
      user_uid,
      name: "Overhead Press",
      note: "Compound movement using a barbell. Press the barbell from shoulder level to overhead. Targets deltoids and triceps.",
    },
    {
      user_uid,
      name: "Pull-ups",
      note: "Compound movement using a pull-up bar. Grip the bar wider than shoulder-width and pull yourself up until your chin is above the bar. Targets back and biceps.",
    },
    {
      user_uid,
      name: "Pendley Rows",
      note: "Compound movement using a barbell. Bend over and pull the barbell towards your lower rib cage. Targets mid-back.",
    },
    {
      user_uid,
      name: "Seated Chest Press",
      note: "Isolation movement using the chest press machine. Push the handles forward, targeting the chest and triceps.",
    },
    {
      user_uid,
      name: "Romanian Deadlifts",
      note: "Compound movement using a barbell. Keep a slight bend in the knees and hinge at the hips. Targets hamstrings and glutes.",
    },
    {
      user_uid,
      name: "Front Squats",
      note: "Compound movement using a barbell. Hold the barbell in front of you and squat down. Targets quads and upper back.",
    },
    {
      user_uid,
      name: "Hip Thrusts",
      note: "Compound movement using a barbell and bench. Rest your upper back on a bench and thrust hips upward. Targets glutes.",
    },
    {
      user_uid,
      name: "Leg Extensions",
      note: "Isolation movement using the leg extension machine. Extend your legs to work the quads.",
    },
    {
      user_uid,
      name: "Seated Leg Curls",
      note: "Isolation movement using the leg curl machine. Curl the weight towards your glutes while seated. Targets hamstrings.",
    },
  ];

  // const savedExercises = await exerciseRepository.save(exercises);
  let savedExercises: ExerciseEntity[] = [];
  try {
    savedExercises = await exerciseRepository.save(exercises);
  } catch (error) {
    console.log("Error while saving exercises:", error);
  }
  return savedExercises;
}

async function associateWorkoutExercises(savedWorkouts: WorkoutEntity[], savedExercises: ExerciseEntity[]) {
  const workoutToExercisesMapping: Record<string, string[]> = {
    "Chest": [
      "Bench Press",
      "Inclined Dumbbell Bench Press",
      "Lateral Pull-down",
      "Dumbbell Arm Curl",
      "Triceps Cable Extension",
      "Face Pulls",
      "Dumbbell Side Raises",
    ],
    "Squats": [
      "Barbell Squats",
      "Leg Press",
      "Good Mornings",
      "Lying Leg Curls",
      "Standing Calf Raises",
      "Abs leg raises",
    ],
    "Shoulders": [
      "Overhead Press",
      "Pull-ups",
      "Pendley Rows",
      "Seated Chest Press",
      "Dumbbell Arm Curl",
      "Triceps Cable Extension",
      "Face Pulls",
      "Dumbbell Side Raises",
    ],
    "Deadlifts": [
      "Romanian Deadlifts",
      "Front Squats",
      "Hip Thrusts",
      "Leg Extensions",
      "Seated Leg Curls",
      "Standing Calf Raises",
      "Abs leg raises",
    ],
  };

  const workoutExercises: Partial<WorkoutExerciseEntity>[] = [];

  savedWorkouts.forEach((workout, workoutIndex) => {
    const exercisesForWorkout = workoutToExercisesMapping[workout.name!];
    exercisesForWorkout.forEach((exerciseName, exerciseOrder) => {
      const exercise = savedExercises.find(e => e.name === exerciseName);
      if (exercise) {
        workoutExercises.push({
          workout_id: savedWorkouts[workoutIndex].workout_id,
          exercise_id: exercise.exercise_id,
          order_number: exerciseOrder,
        });
      } else {
        console.log(`Exercise ${exerciseName} not found`);
      }
    });
  });

  let savedWorkoutExercises: WorkoutExerciseEntity[] = [];
  try {
    savedWorkoutExercises = await workoutExerciseRepository.save(workoutExercises);
  } catch (error) {
    console.log("Error while saving workout exercises:", error);
  }
  return savedWorkoutExercises;
}

async function insertSetReferences(savedWorkoutExercises: WorkoutExerciseEntity[], savedExercises: ExerciseEntity[]) {
  const setReferences: Partial<SetReferenceEntity>[] = [];

  savedWorkoutExercises.forEach(workoutExercise => {
    const exercise = savedExercises.find(e => e.exercise_id === workoutExercise.exercise_id);
    if (!exercise) {
      console.log(`Exercise with id ${workoutExercise.exercise_id} not found`);
      return;
    }
    const exerciseType = inferExerciseTypeFromNote(exercise!.note!);
    const setsStructure = exerciseSetsStructure[exerciseType];

    let orderNumber = 0;
    for (let i = 0; i < setsStructure.warmup; i++) {
      setReferences.push({
        workout_exercise_id: workoutExercise.workout_exercise_id,
        order_number: orderNumber++,
        note: "warmup",
      });
    }

    for (let i = 0; i < setsStructure.working; i++) {
      setReferences.push({
        workout_exercise_id: workoutExercise.workout_exercise_id,
        order_number: orderNumber++,
      });
    }
  });

  let savedSetReferences: SetReferenceEntity[] = [];
  try {
    savedSetReferences = await setReferenceRepository.save(setReferences);
  } catch (error) {
    console.log("Error while saving set references:", error);
  }
  return savedSetReferences;
}

async function insertSetDetails(savedSetReferences: SetReferenceEntity[], savedWorkoutExercises: WorkoutExerciseEntity[], savedExercises: ExerciseEntity[]) {
  const currentWeightMap: Record<string, number> = {
    "Bench Press": 60,
    "Inclined Dumbbell Bench Press": 20,
    "Lateral Pull-down": 49,
    "Dumbbell Arm Curl": 14,
    "Triceps Cable Extension": 23,
    "Face Pulls": 35,
    "Dumbbell Side Raises": 10,
    "Barbell Squats": 80,
    "Leg Press": 200,
    "Good Mornings": 40,
    "Lying Leg Curls": 50,
    "Standing Calf Raises": 60,
    "Abs leg raises": 0,
    "Overhead Press": 45,
    "Pull-ups": 0,
    "Pendley Rows": 40,
    "Seated Chest Press": 75,
    "Romanian Deadlifts": 130,
    "Front Squats": 60,
    "Hip Thrusts": 50,
    "Leg Extensions": 50,
    "Seated Leg Curls": 45,
  };

  const setDetails: Partial<SetDetailEntity>[][] = [[], [], []];

  let isFirstWarmup = true;

  function adjustWeight(weight: number, weeksAgo: 0 | 1 | 2, isWarmup: boolean): number {
    const weekAdjustment = 1 - weeksAgo * 0.05;
    const warmupAdjustment = isWarmup ? (isFirstWarmup ? 0.5 : 0.75) : 1;
    return weight * weekAdjustment * warmupAdjustment;
  }

  savedSetReferences.forEach(setReference => {
    const isWarmup = setReference.note === "warmup";

    const workoutExercise = savedWorkoutExercises.find(e => e.workout_exercise_id === setReference.workout_exercise_id);
    if (!workoutExercise) {
      console.log(`Workout Exercise with id ${setReference.workout_exercise_id} not found`);
      return;
    }

    const exercise = savedExercises.find(e => e.exercise_id === workoutExercise.exercise_id);
    if (!exercise) {
      console.log(`Exercise with id ${workoutExercise.exercise_id} not found`);
      return;
    }

    const exerciseType = inferExerciseTypeFromNote(exercise!.note!);
    const currentWeight = currentWeightMap[exercise.name!];

    [2, 1, 0].forEach(weeksAgo => {
      const weight = adjustWeight(currentWeight, weeksAgo as 0 | 1 | 2, isWarmup);

      const setDetail: Partial<SetDetailEntity> = {
        created_at: new Date(Date.now() - (weeksAgo * 7 * 24 * 60 * 60 * 1000)),
        set_reference_id: setReference.set_reference_id,
        rep_count: 12,
        weight: weight === 0 ? undefined : weight,
        weight_text: weight === 0 ? "body weight" : undefined,
        rest_time_before: exerciseType === "Compound" ? 300 : 120,
      };

      setDetails[weeksAgo].push(setDetail);
    });

    if (isWarmup) {
      isFirstWarmup = !isFirstWarmup;
    }
  });

  let savedSetDetails: SetDetailEntity[][] = [];
  try {
    savedSetDetails = await Promise.all(setDetails.map(sd => setDetailRepository.save(sd)));
  } catch (error) {
    console.log("Error while saving set details:", error);
  }
  return savedSetDetails;
}

async function insertCompletedWorkouts(savedWorkouts: WorkoutEntity[]) {
  const completedWorkouts: Partial<CompletedWorkoutEntity>[][] = [[], []];

  savedWorkouts.forEach((workout) => {
    [1, 0].forEach(weeksAgo => {
      const completedWorkout: Partial<CompletedWorkoutEntity> = {
        user_uid,
        workout_id: workout.workout_id,
        started_at: new Date(Date.now() - (weeksAgo * 7 * 24 * 60 * 60 * 1000)),
        completed_at: new Date(Date.now() - (weeksAgo * 7 * 24 * 60 * 60 * 1000)),
        is_active: false,
      };

      completedWorkouts[weeksAgo].push(completedWorkout);
    });
  });

  let savedCompletedWorkouts: CompletedWorkoutEntity[][] = [];
  try {
    savedCompletedWorkouts = await Promise.all(completedWorkouts.map(cw => completedWorkoutRepository.save(cw)));
  } catch (error) {
    console.log("Error while saving completed workouts:", error);
  }
  return savedCompletedWorkouts;
}

async function insertCompletedSets(savedSetDetails: SetDetailEntity[][], savedSetReferences: SetReferenceEntity[], savedWorkoutExercises: WorkoutExerciseEntity[], savedCompletedWorkouts: CompletedWorkoutEntity[][], savedExercises: ExerciseEntity[]) {
  const completedSets: Partial<CompletedSetEntity>[] = [];

  [savedSetDetails[2], savedSetDetails[1]].forEach((setDetailsForWeek, weekIndex) => {
    setDetailsForWeek.forEach(setDetail => {
      const setReference = savedSetReferences.find(sr => sr.set_reference_id === setDetail.set_reference_id);
      if (!setReference) {
        console.log(`Set reference with id ${setDetail.set_reference_id} not found`);
        return false;
      }

      const workoutExercise = savedWorkoutExercises.find(we => we.workout_exercise_id === setReference.workout_exercise_id);
      if (!workoutExercise) {
        console.log(`Workout exercise with id ${setReference.workout_exercise_id} not found`);
        return false;
      }

      const completedWorkout = [savedCompletedWorkouts[1], savedCompletedWorkouts[0]][weekIndex].find(cw => cw.workout_id === workoutExercise.workout_id);
      if (!completedWorkout) {
        console.log(`Completed workout with id ${workoutExercise.workout_id} not found`);
        return;
      }

      const exercise = savedExercises.find(e => e.exercise_id === workoutExercise.exercise_id);
      if (!exercise) {
        console.log(`Exercise with id ${workoutExercise.exercise_id} not found`);
        return;
      }

      const completedSet: Partial<CompletedSetEntity> = {
        completed_workout_id: completedWorkout.completed_workout_id,
        set_detail_id: setDetail.set_detail_id,
        exercise_id: exercise.exercise_id,
        completed_at: completedWorkout.completed_at,
        rep_count: varyRepCount(setDetail.rep_count),
        weight: varyWeight(setDetail.weight),
        weight_text: setDetail.weight_text,
        rest_time_before: varyRestTime(setDetail.rest_time_before),
        is_active: false,
      };

      completedSets.push(completedSet);
    });
  });

  try {
    await completedSetRepository.save(completedSets);
  } catch (error) {
    console.log("Error while saving completed sets:", error);
  }
}

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
*/
router.get("/", async (req, res) => {
  try {
    const savedWorkouts = await insertnsertWorkouts();
    const savedExercises = await insertExercises();
    const savedWorkoutExercises = await associateWorkoutExercises(savedWorkouts, savedExercises);
    const savedSetReferences = await insertSetReferences(savedWorkoutExercises, savedExercises);
    const savedSetDetails = await insertSetDetails(savedSetReferences, savedWorkoutExercises, savedExercises);
    const savedCompletedWorkouts = await insertCompletedWorkouts(savedWorkouts);
    await insertCompletedSets(savedSetDetails, savedSetReferences, savedWorkoutExercises, savedCompletedWorkouts, savedExercises);

    res.json({ message: "Data initialized successfully" });
  } catch (error) {
    console.error("Error while initializing data:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});

function varyRepCount(repCount: number | undefined): number | undefined {
  // 50% chance of varying the rep count
  if (Math.random() < 0.5) {
    const variation = Math.floor(Math.random() * 11) - 5;
    return Math.max(0, (repCount || 0) + variation);
  }

  return repCount;
}

function varyWeight(weight: number | undefined): number | undefined {
  if (weight === undefined || 0) return weight;

  // 50% chance of varying the weight
  if (Math.random() < 0.5) {
    const variation = Math.floor(Math.random() * 21) - 10;
    return Math.max(0, (weight || 0) + variation);
  }

  return weight;
}

function varyRestTime(restTime: number | undefined): number | undefined {
  // 50% chance of varying the rest time
  if (Math.random() < 0.5) {
    const variation = Math.floor(Math.random() * 61) - 30;
    return Math.max(0, (restTime || 0) + variation);
  }

  return restTime;
}


const inferExerciseTypeFromNote = (note: string): keyof typeof exerciseSetsStructure => {
  if (note.includes("Compound")) return "Compound";
  if (note.includes("Isolation")) return "Isolation";
  return "Other";
};

const exerciseSetsStructure: {
  Isolation: { working: number; warmup: number };
  Compound: { working: number; warmup: number };
  Other: { working: number; warmup: number };
} = {
  "Compound": {
    warmup: 2,
    working: 3,
  },
  "Isolation": {
    warmup: 0,
    working: 3,
  },
  "Other": {
    warmup: 0,
    working: 3,
  },
};

export default router;