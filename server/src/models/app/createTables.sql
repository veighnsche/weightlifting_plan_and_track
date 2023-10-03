-- WorkoutEntity
CREATE TABLE wpt_workouts
(
    workout_id  UUID PRIMARY KEY,
    user_uid    TEXT    NOT NULL,
    name        TEXT    NOT NULL,
    day_of_week INTEGER,
    note        TEXT,
    is_archived BOOLEAN NOT NULL DEFAULT FALSE
);

-- ExerciseEntity
CREATE TABLE wpt_exercises
(
    exercise_id UUID PRIMARY KEY,
    user_uid    TEXT    NOT NULL,
    name        TEXT    NOT NULL,
    note        TEXT,
    is_archived BOOLEAN NOT NULL DEFAULT FALSE
);

-- WorkoutExerciseEntity
CREATE TABLE wpt_workout_exercises
(
    workout_exercise_id UUID PRIMARY KEY,
    workout_id          UUID    NOT NULL,
    exercise_id         UUID    NOT NULL,
    order_number        INTEGER,
    note                TEXT,
    is_archived         BOOLEAN NOT NULL DEFAULT FALSE
);

-- SetReferenceEntity
CREATE TABLE wpt_set_references
(
    set_reference_id    UUID PRIMARY KEY,
    workout_exercise_id UUID    NOT NULL,
    order_number        INTEGER NOT NULL,
    note                TEXT,
    is_archived         BOOLEAN NOT NULL DEFAULT FALSE
);

-- SetDetailEntity
CREATE TABLE wpt_set_details
(
    set_detail_id     UUID PRIMARY KEY,
    set_reference_id  UUID      NOT NULL,
    created_at        TIMESTAMP NOT NULL,
    rep_count         INTEGER,
    weight            DOUBLE PRECISION,
    weight_text       TEXT,
    weight_adjustment JSONB,
    rest_time_before  INTEGER,
    note              TEXT,
    is_archived       BOOLEAN   NOT NULL DEFAULT FALSE
);

-- CompletedWorkoutEntity
CREATE TABLE wpt_completed_workouts
(
    completed_workout_id UUID PRIMARY KEY,
    workout_id           UUID      NOT NULL,
    user_uid             TEXT      NOT NULL,
    started_at           TIMESTAMP NOT NULL,
    completed_at         TIMESTAMP,
    note                 TEXT,
    is_active            BOOLEAN   NOT NULL,
    is_archived          BOOLEAN   NOT NULL DEFAULT FALSE
);

-- CompletedSetEntity
CREATE TABLE wpt_completed_sets
(
    completed_set_id     UUID PRIMARY KEY,
    completed_workout_id UUID      NOT NULL,
    set_detail_id        UUID      NOT NULL,
    completed_at         TIMESTAMP NOT NULL,
    rep_count            INTEGER,
    weight               DOUBLE PRECISION,
    weight_text          TEXT,
    weight_adjustment    JSONB,
    rest_time_before     INTEGER,
    note                 TEXT,
    is_active            BOOLEAN   NOT NULL,
    is_archived          BOOLEAN   NOT NULL DEFAULT FALSE
);

-- Add Foreign Key Constraints
ALTER TABLE wpt_workout_exercises
    ADD CONSTRAINT fk_workout
        FOREIGN KEY (workout_id) REFERENCES wpt_workouts (workout_id);

ALTER TABLE wpt_workout_exercises
    ADD CONSTRAINT fk_exercise
        FOREIGN KEY (exercise_id) REFERENCES wpt_exercises (exercise_id);

ALTER TABLE wpt_set_references
    ADD CONSTRAINT fk_workout_exercise
        FOREIGN KEY (workout_exercise_id) REFERENCES wpt_workout_exercises (workout_exercise_id);

ALTER TABLE wpt_set_details
    ADD CONSTRAINT fk_set_reference
        FOREIGN KEY (set_reference_id) REFERENCES wpt_set_references (set_reference_id);

ALTER TABLE wpt_completed_workouts
    ADD CONSTRAINT fk_workout_completed
        FOREIGN KEY (workout_id) REFERENCES wpt_workouts (workout_id);

ALTER TABLE wpt_completed_sets
    ADD CONSTRAINT fk_completed_workout
        FOREIGN KEY (completed_workout_id) REFERENCES wpt_completed_workouts (completed_workout_id);

ALTER TABLE wpt_completed_sets
    ADD CONSTRAINT fk_set_detail
        FOREIGN KEY (set_detail_id) REFERENCES wpt_set_details (set_detail_id);
