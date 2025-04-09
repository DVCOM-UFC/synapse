CREATE TABLE self_redactions (
    event_id text NOT NULL,
    user_id text NOT NULL,
    redacts text NOT NULL,
    have_censored boolean DEFAULT false NOT NULL,
    received_ts bigint
);