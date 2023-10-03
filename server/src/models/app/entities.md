# Tech Stack

- Mobile Client
  - Dart
  - Flutter
  - Provider
  - GraphQL (only real-time subscriptions to Hasura Server)
- General Server
  - Node.js
  - TypeScript
  - Express
  - TypeORM
  - PostgreSQL (for saving the user data)
  - GraphQL (client for Hasura Server, manages the workout data)
- Hasura Server
  - PostgreSQL (for saving the workout data)
  - GraphQL
- Firebase
  - Authentication
  - Firestore (for saving the chat data)


# Entities

## 1. WorkoutEntity

### Table Name: `wpt_workouts`

- `workout_id`: _uuid_ **(Primary Key)**
- `user_uid`: _string_ User who created the workout
- `name`: _string_
- `day_of_week`: _number_ **(Optional)** Specifies which day the workout is scheduled, with Monday as 0 and Sunday as 6
- `note`: _string_ **(Optional)** Natural language for the assistant about the workout
- `is_archived`: _bool_
- get list `workout_exercises`: where `wpt_workout_exercises.workout_id = workout_id` 

## 2. ExerciseEntity

### Table Name: `wpt_exercises`

- `exercise_id` _uuid_ **(Primary Key)**
- `user_uid`: _string_ User who created the exercise
- `name`: _string_
- `note`: _string_ **(Optional)** Natural language for the assistant about the exercise (e.g. variants and alternatives)
- `is_archived`: _bool_
- get list `workout_exercises`: where `wpt_workout_exercises.exercise_id = exercise_id`

## 3. WorkoutExerciseEntity

### Table Name: `wpt_workout_exercises`

- `workout_exercise_id`: _uuid_ **(Primary Key)**
- `workout_id`: _uuid_ **(Foreign Key)** Connects to a `workout_id` from `wpt_workouts`
- `exercise_id`: _uuid_ **(Foreign Key)** Connects to an `exercise_id` from `wpt_exercises`
- `order_number`: _number_ **(Optional)** Denotes the sequence of the exercise within the workout, null means inactive
- `note`: _string_ **(Optional)** Natural language for the assistant about the exercise in the workout (e.g. choice of variant)
- `is_archived`: _bool_
- get `workout`: where `wpt_workouts.workout_id = workout_id`
- get `exercise`: where `wpt_exercises.exercise_id = exercise_id`
- get list `set_references`: where `wpt_set_references.workout_exercise_id = workout_exercise_id`

## 4. SetReferenceEntity

### Table Name: `wpt_set_references`

- `set-reference_id`: _uuid_ **(Primary Key)**
- `workout_exercise_id`: _uuid_ **(Foreign Key)** Connects to a `workout_exercise_id` from `wpt_workout_exercises`
- `order_number`: _number_ Denotes the sequence of the set within the exercise in the workout
- `note`: _string_ **(Optional)** Natural language for the assistant about the set reference (e.g. "warm up set", "super set")
- `is_archived`: _bool_
- get `workout_exercise`: where `wpt_workout_exercises.workout_exercise_id = workout_exercise_id`
- get list `set_details`: where `wpt_set_details.set_reference_id = set_reference_id`

## 5. SetDetailEntity

### Table Name: `wpt_set_details`

- `set_detail_id`: _uuid_ **(Primary Key)**
- `set_reference_id`: _uuid_ **(Foreign Key)** Connects to a `set_reference_id` from `wpt_set_references`
- `created_at`: _timestamp_ To get the latest set detail, sort by `created_at` in descending order
- `rep_count`: _number_ **(Optional)**
- `weight`: _number_ **(Optional)**
- `weight_text`: _string_ **(Optional)** e.g. "bodyweight", "high resistance band", "low setting"
- `weight_adjustment`: _json_ **(Optional)** e.g. `{"5": 5}` means increase weight by 5 after the 5th rep
- `rest_time_before`: _number_ **(Optional)** Time in seconds to rest before the set
- `note`: _string_ **(Optional)** Natural language for the assistant about the set details
- `is_archived`: _bool_
- get `set_reference`: Retrieves the set reference where `wpt_set_references.set_reference_id = set_reference_id`
- get list `completed_sets`: Retrieves completed sets where `wpt_completed_sets.set_detail_id = set_detail_id`

## 6. CompletedWorkoutEntity

### Table Name: `wpt_completed_workouts`

- `completed_workout_id`: _uuid_ **(Primary Key)**
- `workout_id`: _uuid_ **(Foreign Key)** Connects to a `workout_id` from `wpt_workouts`
- `user_uid`: _string_ User who completed the workout
- `started_at`: _timestamp_
- `completed_at`: _timestamp_
- `note`: _string_ **(Optional)** Natural language for the assistant about the workout (e.g. "felt good", "felt tired")
- `is_active`: _bool_
- `is_archived`: _bool_
- get `workout`: where `wpt_workouts.workout_id = workout_id`
- get list `completed_sets`: where `wpt_completed_sets.completed_workout_id = completed_workout_id`

## 7. CompletedSetEntity

### Overview`wpt_completed_sets`

- `completed_set_id`: _uuid_ **(Primary Key)**
- `completed_workout_id`: _uuid_ **(Foreign Key)** Connects to a `completed_workout_id` from `wpt_completed_workouts`
- `set_detail_id`: _uuid_ **(Foreign Key)** Connects to a `set_detail_id` from `wpt_set_details`
- `exercise_id`: _uuid_ **(Foreign Key)** Connects to an `exercise_id` from `wpt_exercises`
- `completed_at`: _timestamp_
- `rep_count`: _number_ **(Optional)** Actual reps done
- `weight`: _number_ **(Optional)** Actual weight used
- `weight_text`: _string_ **(Optional)** Actual weight text used
- `weight_adjustment`: _json_ **(Optional)** Actual weight adjustment used
- `rest_time_before`: _number_ **(Optional)** Actual rest time before the set
- `note`: _string_ **(Optional)** Natural language for the assistant about the completed set (e.g. "felt good", "felt tired")
- `is_active`: _bool_
- `is_archived`: _bool_
- get `completedWorkout`: where `wpt_completed_workouts.completed_workout_id = completed_workout_id`
- get `setDetail`: where `wpt_set_details.set_detail_id = set_detail_id`

# Screens

## 1. Workout list Screen

### Overview

List of workouts that the user has created.
Each workout is represented by a card with the following details:

- Workout name
- Day of the week (if applicable)
- Note (if applicable)
- Names of the first 3 exercises
- Number of exercises
- Number of sets

### Query

```graphql
subscription GetWorkouts {
  wpt_workouts {
    workout_id
    name
    day_of_week
    note
    wpt_workout_exercises(limit: 3) {
      wpt_exercise {
        name
      }
    }
    totalExercises: wpt_workout_exercises_aggregate {
      aggregate {
        count
      }
    }
    totalSets: wpt_workout_exercises {
      wpt_set_references_aggregate {
        aggregate {
          count
        }
      }
    }
  }
}
```

## 1.1. Workout details Screen

### Overview

Details of a specific workout.
The workout details screen is divided into 3 sections:

- Workout details
  - Workout name
  - Day of the week (if applicable)
  - Note (if applicable)
- Workout Exercise list
  - Exercise name
  - Note (if applicable)
  - Number of sets
  - The highest weight used for the exercise
- Completed workout list
  - Date of completion
  - Note (if applicable)
  - Number of sets
  - Total time taken

### Query

```graphql
query GetWorkoutDetails($workoutId: uuid!) {
  workout(where: {workout_id: {_eq: $workoutId}}) {
    name
    day_of_week
    note
    workout_exercises {
      exercise {
        name
        note
      }
      set_references_aggregate {
        aggregate {
          count
        }
      }
    }
    completed_workouts {
      started_at
      completed_at
      note
      completedSets: completed_sets_aggregate {
        aggregate {
          count
        }
      }
    }
  }
}
```

## 2. Exercise list Screen

### Overview

List of exercises that the user has created.
Each exercise is represented by a card with the following details:

- Exercise name
- Note (if applicable)
- Names of the workouts that the exercise is in and the day of the week (if applicable)

### Query

```graphql
subscription GetExercises {
  wpt_exercises {
    exercise_id
    name
    note
    workouts: wpt_workout_exercises {
      wpt_workout {
        name
        day_of_week
      }
      wpt_set_references(limit: 1, order_by: {wpt_set_details_aggregate: {max: {weight: desc}}}) {
        wpt_set_details(order_by: {created_at: desc}, limit: 1) {
          workingWeight: weight
        }
      }
    }
    wpt_completed_sets_aggregate {
      aggregate {
        max {
          personalRecord: weight
        }
      }
    }
  }
}
```

## 2.1. Exercise details Screen

### Overview

Details of a specific exercise.
The exercise details screen is divided into 3 sections:

- Exercise details
  - Exercise name
  - Note (if applicable)
- Set Reference list
  - Note (if applicable)
  - Latest Set Details
    - Rep count
    - Weight
    - Weight text (if applicable)
    - Weight adjustment (if applicable)
    - Rest time before
    - Note (if applicable)
- Completed Set list
  - Date of completion
  - Note (if applicable)
  - Rep count
  - Weight
  - Weight text (if applicable)
  - Weight adjustment (if applicable)
  - Rest time before

### Query

```graphql
query GetExerciseDetails($exerciseId: uuid!) {
  exercise(where: {exercise_id: {_eq: $exerciseId}}) {
    name
    note
    set_references {
      note
      setDetails: set_details(order_by: {created_at: desc}, limit: 1) {
        rep_count
        weight
        weight_text
        weight_adjustment
        rest_time_before
        note
      }
    }
    completed_sets {
      completed_at
      rep_count
      weight
      weight_text
      weight_adjustment
      rest_time_before
      note
    }
  }
}
```

## 3. Completed Workouts Screen

### Overview

List of completed workouts.
Each completed workout is represented by a card with the following details:
- Workout name
- Date of completion
- Note (if applicable)
- Number of sets
- Total time taken
- Names of the first 3 exercises (derived from the first 3 completed sets with unique exercise names)
- Number of exercises (derived from the number of completed sets with unique exercise names)
- Number of sets

### Query

```graphql
query GetCompletedWorkouts {
  completed_workouts {
    completed_workout_id
    workout {
      name
    }
    started_at
    completed_at
    note
    completedSets: completed_sets_aggregate {
      aggregate {
        count
      }
    }
    totalExercises: completed_sets(distinct_on: {set_detail: {set_reference: {workout_exercise: {exercise_id: {_is_null: false}}}}}) {
      set_detail {
        set_reference {
          workout_exercise {
            exercise {
              name
            }
          }
        }
      }
    }
    totalSets: completed_sets {
      set_detail {
        set_reference {
          workout_exercise {
            exercise {
              name
            }
          }
        }
      }
    }
  }
}
```

## 3.1. Completed Workout details Screen

### Overview

Details of a specific completed workout.
The completed workout details screen is divided into 2 sections:

- Completed workout details
  - Workout name
  - Date of completion
  - Note (if applicable)
  - Total time taken
- Completed Workout Exercise list (derived from the completed sets with unique exercise names)
  - Exercise name
  - Note (if applicable)
  - Completed Set list
    - Date of completion
    - Note (if applicable)
    - Rep count
    - Weight
    - Weight text (if applicable)
    - Weight adjustment (if applicable)
    - Rest time before

### Query

```graphql
query GetCompletedWorkoutDetails($completedWorkoutId: uuid!) {
  completed_workout(where: {completed_workout_id: {_eq: $completedWorkoutId}}) {
    workout {
      name
    }
    started_at
    completed_at
    note
    completedSets: completed_sets_aggregate {
      aggregate {
        count
      }
    }
    totalExercises: completed_sets(distinct_on: {set_detail: {set_reference: {workout_exercise: {exercise_id: {_is_null: false}}}}}) {
      set_detail {
        set_reference {
          workout_exercise {
            exercise {
              name
            }
          }
        }
      }
    }
    completed_sets {
      completed_at
      rep_count
      weight
      weight_text
      weight_adjustment
      rest_time_before
      note
    }
  }
}
```

## 3.2 Completed Set details Screen

### Overview

Details of a specific completed set.
The completed set details screen is divided into 3 sections:

- Workout Exercise details
  - Workout details
    - Workout name
    - Day of the week (if applicable)
    - Note (if applicable)
  - Exercise details
    - Exercise name
    - Note (if applicable)
- Completed set details
  - Date of completion
  - Note (if applicable)
  - Rep count
  - Weight
  - Weight text (if applicable)
  - Weight adjustment (if applicable)
  - Rest time before
- Planned set details
  - Date of completion
  - Note (if applicable)
  - Rep count
  - Weight
  - Weight text (if applicable)
  - Weight adjustment (if applicable)
  - Rest time before

### Query

```graphql
query GetCompletedSetDetails($completedSetId: uuid!) {
  completed_set(where: {completed_set_id: {_eq: $completedSetId}}) {
    completed_at
    rep_count
    weight
    weight_text
    weight_adjustment
    rest_time_before
    note
    completedWorkout: completed_workout {
      workout {
        name
        day_of_week
        note
      }
      workout_exercise {
        exercise {
          name
          note
        }
      }
    }
    plannedSet: set_detail {
      set_reference {
        set_details(order_by: {created_at: desc}, limit: 1) {
          rep_count
          weight
          weight_text
          weight_adjustment
          rest_time_before
          note
        }
      }
    }
  }
}
```

## 4. Tracking Screen

### Overview

The remaining sets for the workout are displayed in a list.
Each set is represented by a card with the following details:

- Exercise details
  - Exercise name
  - Note (if applicable)
- Note (if applicable)
- Rep count
- Weight
- Weight text (if applicable)
- Weight adjustment (if applicable)
- Rest time before

### Query

```graphql
query GetTracking($workoutId: uuid!) {
  workout(where: {workout_id: {_eq: $workoutId}}) {
    workout_id
    name
    day_of_week
    note
    workout_exercises(where: {is_archived: {_eq: false}}) {
      workout_exercise_id
      exercise {
        name
        note
      }
      set_references(where: {is_archived: {_eq: false}}) {
        set_reference_id
        note
        setDetails: set_details(order_by: {created_at: desc}, limit: 1) {
          set_detail_id
          rep_count
          weight
          weight_text
          weight_adjustment
          rest_time_before
          note
        }
      }
    }
  }
}
```
