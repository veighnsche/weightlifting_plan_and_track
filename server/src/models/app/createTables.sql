create table public.wpt_workouts
(
    workout_id  uuid    default uuid_generate_v4() not null
        constraint "PK_3beb3ecc72b6c94869ef3ac0122"
            primary key,
    user_uid    varchar                            not null,
    name        varchar                            not null,
    day_of_week integer,
    note        varchar,
    is_archived boolean default false              not null
);

alter table public.wpt_workouts
    owner to hasura_user;

create table public.wpt_exercises
(
    exercise_id uuid    default uuid_generate_v4() not null
        constraint "PK_be1e54d1c2d007ef7e17e52803a"
            primary key,
    user_uid    varchar                            not null,
    name        varchar                            not null,
    note        varchar,
    is_archived boolean default false              not null
);

alter table public.wpt_exercises
    owner to hasura_user;

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
    note                varchar,
    is_archived         boolean default false              not null
);

alter table public.wpt_workout_exercises
    owner to hasura_user;

create table public.wpt_set_references
(
    set_reference_id    uuid    default uuid_generate_v4() not null
        constraint "PK_8e18870ef4d67f9672b1ece4098"
            primary key,
    workout_exercise_id uuid                               not null
        constraint "FK_6e8fb7ea3ba6e500706211a558e"
            references public.wpt_workout_exercises,
    order_number        integer                            not null,
    note                varchar,
    is_archived         boolean default false              not null
);

alter table public.wpt_set_references
    owner to hasura_user;

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
    note              varchar,
    is_archived       boolean   default false              not null
);

alter table public.wpt_set_details
    owner to hasura_user;

create table public.wpt_completed_workouts
(
    completed_workout_id uuid      default uuid_generate_v4() not null
        constraint "PK_ab1c2cb29a19dec7055bf093129"
            primary key,
    workout_id           uuid                                 not null
        constraint "FK_80301395e81e5b6d6a63f4113d5"
            references public.wpt_workouts,
    started_at           timestamp default now()              not null,
    completed_at         timestamp default now()              not null,
    note                 varchar,
    is_active            boolean                              not null,
    is_archived          boolean   default false              not null,
    user_uid             varchar                              not null
);

alter table public.wpt_completed_workouts
    owner to hasura_user;

create table public.wpt_completed_sets
(
    completed_set_id     uuid      default uuid_generate_v4() not null
        constraint "PK_148b5f49cf45c0095693d28e6a2"
            primary key,
    completed_workout_id uuid
        constraint "FK_d54b7853583bb985e63a7fc111e"
            references public.wpt_completed_workouts,
    set_detail_id        uuid
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

alter table public.wpt_completed_sets
    owner to hasura_user;

