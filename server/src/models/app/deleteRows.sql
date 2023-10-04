-- Begin a transaction
BEGIN;

-- Start with the deepest dependencies and move upwards
DELETE FROM public.wpt_completed_sets;

DELETE FROM public.wpt_completed_workouts;

DELETE FROM public.wpt_set_details;

DELETE FROM public.wpt_set_references;

DELETE FROM public.wpt_workout_exercises;

DELETE FROM public.wpt_exercises;

DELETE FROM public.wpt_workouts;

-- Commit the transaction
COMMIT;
