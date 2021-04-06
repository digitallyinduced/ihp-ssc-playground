

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.books DISABLE TRIGGER ALL;

INSERT INTO public.books (id, title, published_at) VALUES ('8a789b78-090d-4f85-bb1b-5c44c9057b4e', 'An Introduction to General Systems Thi  nking', '1975-02-12');
INSERT INTO public.books (id, title, published_at) VALUES ('11e2ba45-305e-47cd-a9ba-89ef780fbcc0', 'The Wealth of Nations', '1776-03-09');
INSERT INTO public.books (id, title, published_at) VALUES ('7ead4595-5f79-4cc6-9f42-de064b097280', 'The Design of Everyday Things', '1988-01-01');


ALTER TABLE public.books ENABLE TRIGGER ALL;


