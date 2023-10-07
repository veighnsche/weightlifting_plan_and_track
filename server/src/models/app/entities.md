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
- `completed_workout_id`: _uuid_ **(Foreign Key, Optional)** Connects to a `completed_workout_id` from `wpt_completed_workouts`
- `set_detail_id`: _uuid_ **(Foreign Key, Optional)** Connects to a `set_detail_id` from `wpt_set_details`
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
    wpt_workout_exercises(limit: 3, order_by: {order_number: asc}) {
      wpt_exercise {
        name
      }
    }
    wpt_workout_exercises_aggregate {
      aggregate {
        totalExercises: count
      }
    }
    totalSetsAggragate: wpt_workout_exercises {
      wpt_set_references_aggregate {
        aggregate {
          totalSets: count
        }
      }
    }
  }
}
```

### Actual Result

```json
{
  "data": {
    "wpt_workouts": [
      {
        "workout_id": "c14bf452-e606-4e99-a83c-590d3536c54b",
        "name": "Chest",
        "day_of_week": 6,
        "note": "Chest workout",
        "wpt_workout_exercises": [
          {
            "wpt_exercise": {
              "name": "Bench Press"
            }
          },
          {
            "wpt_exercise": {
              "name": "Inclined Dumbbell Bench Press"
            }
          },
          {
            "wpt_exercise": {
              "name": "Lateral Pull-down"
            }
          }
        ],
        "wpt_workout_exercises_aggregate": {
          "aggregate": {
            "totalExercises": 7
          }
        },
        "totalSetsAggragate": [
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 5
              }
            }
          },
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 5
              }
            }
          },
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 3
              }
            }
          },
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 3
              }
            }
          },
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 3
              }
            }
          },
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 3
              }
            }
          },
          {
            "wpt_set_references_aggregate": {
              "aggregate": {
                "totalSets": 3
              }
            }
          }
        ]
      }
    ]
  }
}
```

### Desired Result

```json
{
  "workouts": [
    {
      "workout_id": "c14bf452-e606-4e99-a83c-590d3536c54b",
      "name": "Chest",
      "day_of_week": 6,
      "note": "Chest workout",
      "exercises": ["Bench Press", "Inclined Dumbbell Bench Press", "Lateral Pull-down"],
      "totalExercises": 7,
      "totalSets": 25
    }
  ]
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
  - Number of average reps
  - The highest weight used for the exercise
- Completed workout list
  - Date of completion
  - Note (if applicable)
  - Number of sets
  - Total time taken

### Query

```graphql
subscription GetWorkoutDetails($workoutId: uuid!) {
  wpt_workouts_by_pk(workout_id: $workoutId) {
    workout_id
    name
    day_of_week
    note
    wpt_workout_exercises(order_by: {order_number: asc}) {
      wpt_exercise {
        exercise_id
        name
        note
      }
      wpt_set_references(order_by: {order_number: asc}) {
        order_number
        note
        wpt_set_details(order_by: {created_at: desc}, limit: 1) {
          rep_count
          weight
          weight_text
          weight_adjustment
          rest_time_before
          note
        }
      }
    }
    wpt_completed_workouts(order_by: {started_at: desc}) {
      completed_workout_id
      started_at
      note
      is_active
      wpt_completed_sets_aggregate {
        aggregate {
          completedRepsAmount: count
        }
      }
    }
  }
}
```

### Actual Results -- OUTDATED

```json
{
  "data": {
    "wpt_workouts_by_pk": {
      "workout_id": "5feade00-aed1-42d8-b9a2-1f6cb203a5e5",
      "name": "Chest",
      "day_of_week": 6,
      "note": "Chest workout",
      "wpt_workout_exercises": [
        {
          "wpt_exercise": {
            "exercise_id": "8969ea59-f68b-49d7-b786-588c80e1bf1e",
            "name": "Bench Press",
            "note": "Compound movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 5,
                  "weightPerSet": 40
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 5,
                  "weightPerSet": 50
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 5,
                  "weightPerSet": 60
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 5,
                  "weightPerSet": 60
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 5,
                  "weightPerSet": 60
                }
              ]
            }
          ]
        },
        {
          "wpt_exercise": {
            "exercise_id": "8ebf15ab-aef9-43a7-9b7b-ee9ff546dbf8",
            "name": "Inclined Dumbbell Bench Press",
            "note": "Compound movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 12
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 16
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 20
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 20
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 20
                }
              ]
            }
          ]
        },
        {
          "wpt_exercise": {
            "exercise_id": "6137a519-ca0a-4a9d-a315-08eac11ac6e9",
            "name": "Lateral Pull-down",
            "note": "Compound movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 8,
                  "weightPerSet": 45
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 8,
                  "weightPerSet": 45
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 8,
                  "weightPerSet": 45
                }
              ]
            }
          ]
        },
        {
          "wpt_exercise": {
            "exercise_id": "d3ee34f9-c1f0-4546-bf79-fac3aec98b18",
            "name": "Dumbbell Arm Curl",
            "note": "Isolation movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 15,
                  "weightPerSet": 10
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 15,
                  "weightPerSet": 10
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 15,
                  "weightPerSet": 10
                }
              ]
            }
          ]
        },
        {
          "wpt_exercise": {
            "exercise_id": "600cff06-739f-488c-ada4-6e4ecc1c89f2",
            "name": "Triceps Cable Extension",
            "note": "Isolation movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 21
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 21
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 21
                }
              ]
            }
          ]
        },
        {
          "wpt_exercise": {
            "exercise_id": "d6328888-78d2-4b4d-a404-b2de93affa78",
            "name": "Face Pulls",
            "note": "Isolation movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 21
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 21
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 21
                }
              ]
            }
          ]
        },
        {
          "wpt_exercise": {
            "exercise_id": "656cfa1a-0462-43c8-b2e3-a90517080152",
            "name": "Dumbbell Side Raises",
            "note": "Isolation movement"
          },
          "wpt_set_references": [
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 7
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 7
                }
              ]
            },
            {
              "wpt_set_details": [
                {
                  "repsPerSet": 12,
                  "weightPerSet": 7
                }
              ]
            }
          ]
        }
      ],
      "wpt_completed_workouts": [
        {
          "completed_workout_id": "4df00521-c6cd-404b-9939-62d3600d55e4",
          "started_at": "2023-10-04T22:08:51.508",
          "note": null,
          "is_active": false,
          "wpt_completed_sets_aggregate": {
            "aggregate": {
              "completedRepsAmount": 25
            }
          }
        },
        {
          "completed_workout_id": "351a149d-8230-4eca-9d05-faa06ebafbb3",
          "started_at": "2023-09-27T22:08:51.508",
          "note": null,
          "is_active": false,
          "wpt_completed_sets_aggregate": {
            "aggregate": {
              "completedRepsAmount": 25
            }
          }
        }
      ]
    }
  }
}
```

### Desired Result -- OUTDATED
```json
{
  "workout": {
    "workout_id": "5feade00-aed1-42d8-b9a2-1f6cb203a5e5",
    "name": "Chest",
    "day_of_week": 6,
    "note": "Chest workout",
    "exercises": [
      {
        "exercise_id": "8969ea59-f68b-49d7-b786-588c80e1bf1e",
        "name": "Bench Press",
        "note": "Compound movement",
        "sets_count": 5,
        "averageReps": 5,
        "highestWeight": 60
      },
      {
        "exercise_id": "8ebf15ab-aef9-43a7-9b7b-ee9ff546dbf8",
        "name": "Inclined Dumbbell Bench Press",
        "note": "Compound movement",
        "sets_count": 5,
        "averageReps": 12,
        "highestWeight": 20
      },
      {
        "exercise_id": "6137a519-ca0a-4a9d-a315-08eac11ac6e9",
        "name": "Lateral Pull-down",
        "note": "Compound movement",
        "sets_count": 3,
        "averageReps": 8,
        "highestWeight": 45
      },
      {
        "exercise_id": "d3ee34f9-c1f0-4546-bf79-fac3aec98b18",
        "name": "Dumbbell Arm Curl",
        "note": "Isolation movement",
        "sets_count": 3,
        "averageReps": 15,
        "highestWeight": 10
      },
      {
        "exercise_id": "600cff06-739f-488c-ada4-6e4ecc1c89f2",
        "name": "Triceps Cable Extension",
        "note": "Isolation movement",
        "sets_count": 3,
        "averageReps": 12,
        "highestWeight": 21
      },
      {
        "exercise_id": "d6328888-78d2-4b4d-a404-b2de93affa78",
        "name": "Face Pulls",
        "note": "Isolation movement",
        "sets_count": 3,
        "averageReps": 12,
        "highestWeight": 21
      },
      {
        "exercise_id": "656cfa1a-0462-43c8-b2e3-a90517080152",
        "name": "Dumbbell Side Raises",
        "note": "Isolation movement",
        "sets_count": 3,
        "averageReps": 12,
        "highestWeight": 7
      }
    ],
    "completed_workouts": [
      {
        "completed_workout_id": "4df00521-c6cd-404b-9939-62d3600d55e4",
        "started_at": "2023-10-04T22:08:51.508",
        "note": null,
        "is_active": false,
        "completedRepsAmount": 25
      },
      {
        "completed_workout_id": "351a149d-8230-4eca-9d05-faa06ebafbb3",
        "started_at": "2023-09-27T22:08:51.508",
        "note": null,
        "is_active": false,
        "completedRepsAmount": 25
      }
    ]
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
- The personal record for the exercise

### Query

```graphql
subscription GetExercises {
  wpt_exercises(order_by: {wpt_workout_exercises_aggregate: {avg: {order_number: asc}}}) {
    exercise_id
    name
    note
    wpt_completed_sets_aggregate {
      aggregate {
        max {
          personalRecord: weight
        }
      }
    }
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
  }
}
```

### Actual Result

```json
{
  "data": {
    "wpt_exercises": [
      {
        "exercise_id": "996b11f0-a1a4-4366-a2ca-63be871ff0d8",
        "name": "Bench Press",
        "note": "Compound movement",
        "wpt_completed_sets_aggregate": {
          "aggregate": {
            "max": {
              "personalRecord": 100
            }
          }
        },
        "workouts": [
          {
            "wpt_workout": {
              "name": "Chest",
              "day_of_week": 6
            },
            "wpt_set_references": [
              {
                "wpt_set_details": [
                  {
                    "workingWeight": 60
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### Desired Result

```json
{
  "exercises": [
    {
      "exercise_id": "996b11f0-a1a4-4366-a2ca-63be871ff0d8",
      "name": "Bench Press",
      "note": "Compound movement",
      "personalRecord": 100,
      "workouts": [
        {
          "name": "Chest",
          "day_of_week": 6,
          "workingWeight": 60
        }
      ]
    }
  ]
}
```

## 2.1. Exercise details Screen

### Overview

Details of a specific exercise.
The exercise details screen is divided into 3 sections:

- Exercise details
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
subscription GetExerciseDetails($exerciseId: uuid!) {
  wpt_exercises_by_pk(exercise_id: $exerciseId) {
    name
    note
    wpt_workout_exercises {
      note
      wpt_workout {
        name
        note
        day_of_week
        workout_id
      }
    }
    wpt_completed_sets(order_by: {completed_at: desc}) {
      completed_at
      rep_count
      weight
      weight_text
      weight_adjustment
      rest_time_before
      note
      wpt_set_detail {
        rep_count
        note
        weight
        weight_adjustment
        weight_text
        rest_time_before
        wpt_set_reference {
          note
        }
      }
      wpt_completed_workout {
        completed_workout_id
        started_at
        wpt_workout {
          name
        }
      }
    }
  }
}

```

### Actual Results

```json
{
  "data": {
    "wpt_exercises_by_pk": {
      "name": "Dumbbell Arm Curl",
      "note": "Isolation movement",
      "wpt_workout_exercises": [
        {
          "note": null,
          "wpt_workout": {
            "name": "Chest",
            "note": "Chest workout",
            "day_of_week": 6,
            "workout_id": "5feade00-aed1-42d8-b9a2-1f6cb203a5e5"
          }
        },
        {
          "note": null,
          "wpt_workout": {
            "name": "Shoulders",
            "note": "Shoulders workout",
            "day_of_week": 2,
            "workout_id": "b44e0445-d9f5-467a-91dd-bfbe572eb815"
          }
        }
      ],
      "wpt_completed_sets": [
        {
          "completed_at": "2023-10-04T22:08:51.513",
          "rep_count": 15,
          "weight": 9,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 9,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "4df00521-c6cd-404b-9939-62d3600d55e4",
            "started_at": "2023-10-04T22:08:51.508",
            "wpt_workout": {
              "name": "Chest"
            }
          }
        },
        {
          "completed_at": "2023-10-04T22:08:51.513",
          "rep_count": 15,
          "weight": 11,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 11,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "2a573dbb-4df6-43ce-af31-824cd1838607",
            "started_at": "2023-10-04T22:08:51.508",
            "wpt_workout": {
              "name": "Shoulders"
            }
          }
        },
        {
          "completed_at": "2023-10-04T22:08:51.513",
          "rep_count": 15,
          "weight": 9,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 9,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "4df00521-c6cd-404b-9939-62d3600d55e4",
            "started_at": "2023-10-04T22:08:51.508",
            "wpt_workout": {
              "name": "Chest"
            }
          }
        },
        {
          "completed_at": "2023-10-04T22:08:51.513",
          "rep_count": 15,
          "weight": 11,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 11,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "2a573dbb-4df6-43ce-af31-824cd1838607",
            "started_at": "2023-10-04T22:08:51.508",
            "wpt_workout": {
              "name": "Shoulders"
            }
          }
        },
        {
          "completed_at": "2023-10-04T22:08:51.513",
          "rep_count": 15,
          "weight": 9,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 9,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "4df00521-c6cd-404b-9939-62d3600d55e4",
            "started_at": "2023-10-04T22:08:51.508",
            "wpt_workout": {
              "name": "Chest"
            }
          }
        },
        {
          "completed_at": "2023-10-04T22:08:51.513",
          "rep_count": 15,
          "weight": 11,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 11,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "2a573dbb-4df6-43ce-af31-824cd1838607",
            "started_at": "2023-10-04T22:08:51.508",
            "wpt_workout": {
              "name": "Shoulders"
            }
          }
        },
        {
          "completed_at": "2023-09-27T22:08:51.513",
          "rep_count": 15,
          "weight": 10,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 10,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "f788d85c-8878-4c93-8d74-73d121b03167",
            "started_at": "2023-09-27T22:08:51.508",
            "wpt_workout": {
              "name": "Shoulders"
            }
          }
        },
        {
          "completed_at": "2023-09-27T22:08:51.513",
          "rep_count": 15,
          "weight": 8,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 8,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "351a149d-8230-4eca-9d05-faa06ebafbb3",
            "started_at": "2023-09-27T22:08:51.508",
            "wpt_workout": {
              "name": "Chest"
            }
          }
        },
        {
          "completed_at": "2023-09-27T22:08:51.513",
          "rep_count": 15,
          "weight": 8,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 8,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "351a149d-8230-4eca-9d05-faa06ebafbb3",
            "started_at": "2023-09-27T22:08:51.508",
            "wpt_workout": {
              "name": "Chest"
            }
          }
        },
        {
          "completed_at": "2023-09-27T22:08:51.513",
          "rep_count": 15,
          "weight": 8,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 8,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "351a149d-8230-4eca-9d05-faa06ebafbb3",
            "started_at": "2023-09-27T22:08:51.508",
            "wpt_workout": {
              "name": "Chest"
            }
          }
        },
        {
          "completed_at": "2023-09-27T22:08:51.513",
          "rep_count": 15,
          "weight": 10,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 10,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "f788d85c-8878-4c93-8d74-73d121b03167",
            "started_at": "2023-09-27T22:08:51.508",
            "wpt_workout": {
              "name": "Shoulders"
            }
          }
        },
        {
          "completed_at": "2023-09-27T22:08:51.513",
          "rep_count": 15,
          "weight": 10,
          "weight_text": null,
          "weight_adjustment": null,
          "rest_time_before": 120,
          "note": null,
          "wpt_set_detail": {
            "rep_count": 15,
            "note": null,
            "weight": 10,
            "weight_adjustment": null,
            "weight_text": null,
            "rest_time_before": 120,
            "wpt_set_reference": {
              "note": null
            }
          },
          "wpt_completed_workout": {
            "completed_workout_id": "f788d85c-8878-4c93-8d74-73d121b03167",
            "started_at": "2023-09-27T22:08:51.508",
            "wpt_workout": {
              "name": "Shoulders"
            }
          }
        }
      ]
    }
  }
}
```

### Desired Results

```json
{
  "exercise": {
    "name": "Dumbbell Arm Curl",
    "note": "Isolation movement",
    "workouts": [
      {
        "workout_id": "5feade00-aed1-42d8-b9a2-1f6cb203a5e5",
        "name": "Chest",
        "note": "Chest workout",
        "day_of_week": 6
      },
      {
        "workout_id": "b44e0445-d9f5-467a-91dd-bfbe572eb815",
        "name": "Shoulders",
        "note": "Shoulders workout",
        "day_of_week": 2
      }
    ]
  },
  "completed_workouts": [
    {
      "completed_workout_id": "4df00521-c6cd-404b-9939-62d3600d55e4",
      "started_at": "2023-10-04T22:08:51.508",
      "note": null,
      "is_active": false,
      "completed_sets": 3,
      "max_reps": 15,
      "min_weight": 9,
      "max_weight": 11,
      "avg_rest_time_before": 120,
      "completed_reps_amount": 45,
      "total_volume": 405
    },
    {
      "completed_workout_id": "2a573dbb-4df6-43ce-af31-824cd1838607",
      "started_at": "2023-10-04T22:08:51.508",
      "note": null,
      "is_active": false,
      "completed_sets": 3,
      "max_reps": 15,
      "min_weight": 11,
      "max_weight": 11,
      "avg_rest_time_before": 120,
      "completed_reps_amount": 45,
      "total_volume": 495
    },
    {
      "completed_workout_id": "f788d85c-8878-4c93-8d74-73d121b03167",
      "started_at": "2023-09-27T22:08:51.508",
      "note": null,
      "is_active": false,
      "completed_sets": 3,
      "max_reps": 15,
      "min_weight": 8,
      "max_weight": 10,
      "avg_rest_time_before": 120,
      "completed_reps_amount": 45,
      "total_volume": 405
    },
    {
      "completed_workout_id": "351a149d-8230-4eca-9d05-faa06ebafbb3",
      "started_at": "2023-09-27T22:08:51.508",
      "note": null,
      "is_active": false,
      "completed_sets": 3,
      "max_reps": 15,
      "min_weight": 8,
      "max_weight": 10,
      "avg_rest_time_before": 120,
      "completed_reps_amount": 45,
      "total_volume": 405
    }
  ]
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
