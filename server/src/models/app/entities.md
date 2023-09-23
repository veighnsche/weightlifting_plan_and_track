## 1. WorkoutEntity

### Overview
- Table Name: `wpt-workouts`
- Represents a specific workout created by a user.

### Fields

- `workoutId` (Primary Key): The unique ID of the workout.
- `userUid`: The unique identifier for the user who created the workout.
- `name`: The name of the workout.
- `dayOfWeek`: (Optional) Day of the week when the workout is scheduled. Starts from 0 for Monday up to 6 for Sunday.
- `note`: (Optional) Any additional notes or information about the workout.
- `exercises`: Many-to-many relation with `ExerciseEntity`. The exercises that are part of this workout.

## 2. ExerciseEntity

### Overview
- Table Name: `wpt-exercises`
- Represents individual exercises.

### Fields

- `exerciseId` (Primary Key): The unique ID of the exercise.
- `userUid`: The unique identifier for the user who created the exercise.
- `name`: The name of the exercise.
- `note`: (Optional) Any additional notes or information about the exercise.
- `workouts`: Many-to-many relation with `WorkoutEntity`. Workouts that this exercise is part of.
- `sets`: One-to-many relation with `SetEntity`. The sets that are associated with this exercise.
- `completedSets`: One-to-many relation with `CompletedSetEntity`. The completed sets related to this exercise.

## 3. SetEntity

### Overview
- Table Name: `wpt-sets`
- Represents the individual sets of exercises, including order, rep count, and weight details.

### Fields

- `setId` (Primary Key): The unique ID of the set.
- `exerciseId`: The ID of the exercise this set belongs to.
- `orderNumber`: (Optional) Specifies the order of the set within a workout.
- `repCount`: The number of repetitions for this set.
- `weight`: (Optional) Weight used for this set (in kg).
- `weightText`: (Optional) Type of weight used (e.g., "bodyweight", "barbell").
- `weightAdjustment`: (Optional) JSON object. Indicates weight adjustments after certain reps.
- `note`: (Optional) Any additional notes or information about the set.
- `exercise`: Many-to-one relation with `ExerciseEntity`. The exercise this set is associated with.

## 4. CompletedSetEntity

### Overview
- Table Name: `wpt-completed_sets`
- Represents the sets that a user has completed.

### Fields

- `completedSetId` (Primary Key): The unique ID of the completed set.
- `completedAt`: Timestamp when the set was completed.
- `exerciseId`: The ID of the related exercise.
- `repCount`: The number of repetitions done for this completed set.
- `weight`: (Optional) Weight used for this completed set (in kg).
- `weightText`: (Optional) Type of weight used (e.g., "bodyweight", "barbell").
- `weightAdjustment`: (Optional) JSON object. Indicates weight adjustments after certain reps.
- `note`: (Optional) Any additional notes or information about the completed set.
- `exercise`: Many-to-one relation with `ExerciseEntity`. The exercise related to this completed set.
