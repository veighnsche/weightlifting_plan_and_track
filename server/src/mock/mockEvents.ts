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


    // Insert workouts into the database
    const savedWorkouts = await workoutRepository.save(workouts);

    // Define and insert exercises, and associate them with the workouts
    // For simplicity, we assume all exercises are unique and are inserted every time
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

    workouts.forEach((workout, workoutIndex) => {
      const exercisesForWorkout = workoutToExercisesMapping[workout.name!];
      exercisesForWorkout.forEach((exerciseName, exerciseOrder) => {
        const exercise = savedExercises.find(e => e.name === exerciseName);
        if (exercise) {
          workoutExercises.push({
            workout_id: savedWorkouts[workoutIndex].workout_id,
            exercise_id: exercise.exercise_id,
            order_number: exerciseOrder,
          });
        }
      });
    });

    let savedWorkoutExercises: WorkoutExerciseEntity[] = [];
    try {
      savedWorkoutExercises = await workoutExerciseRepository.save(workoutExercises);
    } catch (error) {
      console.log("Error while saving workout exercises:", error);
    }

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

    const inferExerciseTypeFromNote = (note: string): keyof typeof exerciseSetsStructure => {
      if (note.includes("Compound")) return "Compound";
      if (note.includes("Isolation")) return "Isolation";
      return "Other";
    };

    const setReferences: Partial<SetReferenceEntity>[] = [];

    savedWorkoutExercises.forEach(workoutExercise => {
      const exercise = exercises.find(e => e.exercise_id === workoutExercise.exercise_id);
      const exerciseType = inferExerciseTypeFromNote(exercise!.note!);
      const setsStructure = exerciseSetsStructure[exerciseType];

      for (let i = 0; i < setsStructure.warmup; i++) {
        setReferences.push({
          workout_exercise_id: workoutExercise.workout_exercise_id,
          order_number: setReferences.length,
          note: "warmup",
        });
      }

      for (let i = 0; i < setsStructure.working; i++) {
        setReferences.push({
          workout_exercise_id: workoutExercise.workout_exercise_id,
          order_number: setReferences.length,
        });
      }
    });

    let savedSetReferences: SetReferenceEntity[] = [];
    try {
      savedSetReferences = await setReferenceRepository.save(setReferences);
    } catch (error) {
      console.log("Error while saving set references:", error);
    }

    const userOneRepMax = {
      "Bench Press": 60, // Assuming the user can bench press 100kg for one rep
      "Inclined Dumbbell Bench Press": 20, // Assuming each dumbbell weighs 30kg
      "Lateral Pull-down": 49,
      "Dumbbell Arm Curl": 14, // Assuming each dumbbell weighs 15kg
      "Triceps Cable Extension": 23,
      "Face Pulls": 35,
      "Dumbbell Side Raises": 10, // Assuming each dumbbell weighs 10kg
      "Barbell Squats": 80,
      "Leg Press": 200,
      "Good Mornings": 40,
      "Lying Leg Curls": 50,
      "Standing Calf Raises": 60,
      "Abs leg raises": 0, // This exercise doesn't typically involve weights
      "Overhead Press": 45,
      "Pull-ups": 0, // Body weight exercise; can add user's body weight if needed
      "Pendley Rows": 40,
      "Seated Chest Press": 75,
      "Romanian Deadlifts": 130,
      "Front Squats": 60,
      "Hip Thrusts": 50,
      "Leg Extensions": 50,
      "Seated Leg Curls": 45,
    };

    const generateSetDetailsForReference = (exercise: Partial<ExerciseEntity>, setReference: SetReferenceEntity, weeksAgo: number): Partial<SetDetailEntity> => {
      let reps;
      let weightPercentage;

      if (exercise.note!.includes("Compound")) {
        reps = Math.random() > 0.5 ? 5 : 10;
        weightPercentage = reps === 5 ? 0.8 : 0.7;
      } else if (exercise.note!.includes("Isolation")) {
        reps = 12;
        weightPercentage = 0.5;
      } else {
        reps = 10;
        weightPercentage = 0.7;
      }

      const baseWeight = userOneRepMax[exercise.name as keyof typeof userOneRepMax] * weightPercentage;

      const weight = baseWeight * (1 - 0.05 * weeksAgo); // Decrease by 5% for each week ago

      return {
        set_reference_id: setReference.set_reference_id,
        rep_count: reps,
        weight: weight,
        weight_text: weight === 0 ? "body weight" : undefined,
        created_at: new Date(Date.now() - weeksAgo * 6048e5), // weeksAgo * 7 days in milliseconds
      };
    };

    const allSetDetails: Partial<SetDetailEntity>[] = [];

    savedSetReferences.forEach(setReference => {
      const associatedWorkoutExercise = savedWorkoutExercises.find(we => we.workout_exercise_id === setReference.workout_exercise_id);
      const exercise = exercises.find(e => e.exercise_id === associatedWorkoutExercise!.exercise_id);

      allSetDetails.push(generateSetDetailsForReference(exercise!, setReference, 0));
      allSetDetails.push(generateSetDetailsForReference(exercise!, setReference, 1));
      allSetDetails.push(generateSetDetailsForReference(exercise!, setReference, 2));
    });

    allSetDetails.forEach((setDetail, index) => {
      try {
        const setReferenceIndex = index % savedSetReferences.length;
        setDetail.set_reference_id = savedSetReferences[setReferenceIndex].set_reference_id;
      } catch (error) {
        console.log("Error while setting set reference id:", error);
      }
    });

    let savedSetDetails: SetDetailEntity[] = [];
    try {
      savedSetDetails = await setDetailRepository.save(allSetDetails);
    } catch (error) {
      console.log("Error while saving set details:", error);
    }

    const generateCompletedWorkout = (workout: Partial<WorkoutEntity>, user_uid: string, timeModifier: number, isActive: boolean): Partial<CompletedWorkoutEntity> => {
      return {
        user_uid,
        workout_id: workout.workout_id,
        started_at: new Date(Date.now() + timeModifier),
        is_active: isActive,
      };
    };

    const oneWeekAgo = -6048e5; // 1 week in milliseconds
    const currentTime = 0;

    const completedWorkouts: Partial<CompletedWorkoutEntity>[] = [];

    savedWorkouts.forEach(workout => {
      completedWorkouts.push(generateCompletedWorkout(workout, user_uid, oneWeekAgo, false)); // 1 week ago
      completedWorkouts.push(generateCompletedWorkout(workout, user_uid, currentTime, false)); // Current time
    });

    let savedCompletedWorkouts: CompletedWorkoutEntity[] = [];
    try {
      savedCompletedWorkouts = await completedWorkoutRepository.save(completedWorkouts);
    } catch (error) {
      console.log("Error while saving completed workouts:", error);
    }

// Helper function to adjust weight and reps by 5-10%
    const adjustValue = (value: number): number => {
      const adjustment = 1 + (Math.random() * 0.1 - 0.05); // Random value between -5% to 5%
      return Math.round(value * adjustment);
    };

// Loop through each completed workout to create completed sets
    const completedSets: Partial<CompletedSetEntity>[] = [];
    for (const completedWorkout of savedCompletedWorkouts) {
      // Find workout exercises associated with the workout
      const associatedWorkoutExercises = savedWorkoutExercises.filter(we => we.workout_id === completedWorkout.workout_id);

      for (const workoutExercise of associatedWorkoutExercises) {
        // Find set references associated with the workout exercise
        const associatedSetReferences = savedSetReferences.filter(sr => sr.workout_exercise_id === workoutExercise.workout_exercise_id);

        for (const setReference of associatedSetReferences) {
          // Find the set detail created one week before the workout was done
          const oneWeekBeforeCompletedWorkout = new Date(completedWorkout.started_at.getTime() - 6048e5); // Subtract 7 days
          const matchingSetDetail = savedSetDetails.find(sd => sd.set_reference_id === setReference.set_reference_id && sd.created_at <= oneWeekBeforeCompletedWorkout);

          if (matchingSetDetail) {
            completedSets.push({
              completed_workout_id: completedWorkout.completed_workout_id,
              set_detail_id: matchingSetDetail.set_detail_id,
              exercise_id: workoutExercise.exercise_id,
              completed_at: completedWorkout.completed_at,
              rep_count: adjustValue(matchingSetDetail.rep_count!),
              weight: adjustValue(matchingSetDetail.weight!),
              weight_text: matchingSetDetail.weight_text,
              is_active: false,
              is_archived: false,
            });
          }
        }
      }
    }

    try {
      await completedSetRepository.save(completedSets);
    } catch (error) {
      console.log("Error while saving completed sets:", error);
    }

    res.json({ message: "Data initialized successfully" });
  } catch (error) {
    console.error("Error while initializing data:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});

export default router;