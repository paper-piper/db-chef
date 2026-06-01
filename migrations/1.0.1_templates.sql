-- Chapter seed derived from the schema and hokut template IDs.
-- Contains chapter rows for all chapter tables and template_chapters links
-- where the schema defines a template_chapters table.

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public, users, examinees, dapar, hn, keshev, mivdak, pilots', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET session_replication_role = replica;

-- DAPAR chapters.
INSERT INTO dapar.chapters (chapter_id, name, description, chapter_type, base_time) VALUES
  ('CH1', 'Analytical Thinking', 'Logical patterns and inference', 'CHAK', 600),
  ('CH2', 'Verbal Reasoning', 'Hebrew comprehension and analogies', 'ANAM', 500),
  ('CH3', 'Quantitative', 'Mathematical problem solving', 'ANAZ', 450),
  ('CH4', 'Spatial Reasoning', '3D rotations and visual patterns', 'AGAS', 400),
  ('CH5', 'English Reading', 'English passage comprehension', 'HETZ', 500)
ON CONFLICT (chapter_id) DO NOTHING;

INSERT INTO dapar.adaptive_chapters_metadata (chapter_id, allowed_error, min_questions, max_questions, base_time_per_question) VALUES
  ('CH1', 0.3, 8, 20, 30),
  ('CH2', 0.3, 8, 20, 25),
  ('CH3', 0.3, 8, 20, 35),
  ('CH4', 0.4, 6, 16, 30),
  ('CH5', 0.3, 8, 16, 25)
ON CONFLICT (chapter_id) DO NOTHING;

-- DAPAR templates from hokut.sql plus the pilots shared template.
INSERT INTO dapar.templates (template_id, name, description) VALUES
  (11, 'Template 11', 'Imported from hokut'),
  (12, 'Template 12', 'Imported from hokut'),
  (13, 'Template 13', 'Imported from hokut'),
  (14, 'Template 14', 'Imported from hokut'),
  (15, 'Template 15', 'Imported from hokut'),
  (16, 'Template 16', 'Imported from hokut'),
  (18, 'Template 18', 'Imported from hokut'),
  (19, 'Template 19 (Orthodox)', 'Imported from hokut'),
  (20, 'Standard Pilots', 'Shared template used by pilots'),
  (21, 'Template 21', 'Imported from hokut'),
  (22, 'Template 22', 'Imported from hokut'),
  (23, 'Template 23', 'Imported from hokut'),
  (24, 'Template 24', 'Imported from hokut'),
  (25, 'Template 25', 'Imported from hokut'),
  (26, 'Template 26', 'Imported from hokut'),
  (28, 'Template 28', 'Imported from hokut'),
  (31, 'Template 31', 'Imported from hokut'),
  (41, 'Template 41 (ll_sight)', 'Imported from hokut')
ON CONFLICT (template_id) DO NOTHING;

INSERT INTO dapar.templates_chapters (template_id, chapter_id, chapter_index) VALUES
  (11, 'CH1', 0), (11, 'CH2', 1), (11, 'CH3', 2), (11, 'CH4', 3), (11, 'CH5', 4),
  (12, 'CH1', 0), (12, 'CH2', 1), (12, 'CH3', 2), (12, 'CH4', 3), (12, 'CH5', 4),
  (13, 'CH1', 0), (13, 'CH2', 1), (13, 'CH3', 2), (13, 'CH4', 3), (13, 'CH5', 4),
  (14, 'CH1', 0), (14, 'CH2', 1), (14, 'CH3', 2), (14, 'CH4', 3), (14, 'CH5', 4),
  (15, 'CH1', 0), (15, 'CH2', 1), (15, 'CH3', 2), (15, 'CH4', 3), (15, 'CH5', 4),
  (16, 'CH1', 0), (16, 'CH2', 1), (16, 'CH3', 2), (16, 'CH4', 3), (16, 'CH5', 4),
  (18, 'CH1', 0), (18, 'CH2', 1), (18, 'CH3', 2), (18, 'CH4', 3), (18, 'CH5', 4),
  (19, 'CH1', 0), (19, 'CH2', 1), (19, 'CH3', 2), (19, 'CH4', 3),
  (21, 'CH1', 0), (21, 'CH2', 1), (21, 'CH3', 2), (21, 'CH4', 3), (21, 'CH5', 4),
  (22, 'CH1', 0), (22, 'CH2', 1), (22, 'CH3', 2), (22, 'CH4', 3), (22, 'CH5', 4),
  (23, 'CH1', 0), (23, 'CH2', 1), (23, 'CH3', 2), (23, 'CH4', 3), (23, 'CH5', 4),
  (24, 'CH1', 0), (24, 'CH2', 1), (24, 'CH3', 2), (24, 'CH4', 3), (24, 'CH5', 4),
  (25, 'CH1', 0), (25, 'CH2', 1), (25, 'CH3', 2), (25, 'CH4', 3), (25, 'CH5', 4),
  (26, 'CH1', 0), (26, 'CH2', 1), (26, 'CH3', 2), (26, 'CH4', 3), (26, 'CH5', 4),
  (28, 'CH1', 0), (28, 'CH2', 1), (28, 'CH3', 2), (28, 'CH4', 3), (28, 'CH5', 4),
  (31, 'CH1', 0), (31, 'CH2', 1), (31, 'CH3', 2), (31, 'CH4', 3), (31, 'CH5', 4),
  (41, 'CH1', 0), (41, 'CH2', 1), (41, 'CH3', 2), (41, 'CH4', 3), (41, 'CH5', 4)
ON CONFLICT DO NOTHING;

-- HN chapters.
INSERT INTO hn.chapters (chapter_id, name, description, base_time) VALUES
  ('HN01', 'Olim Intro', 'Introductory passage for olim', 400),
  ('HN02', 'Olim Reading', 'Reading comprehension for olim', 500),
  ('HN03', 'Yelidim Reading', 'Reading comprehension for yelidim', 500),
  ('HN04', 'Yelidim Advanced', 'Advanced comprehension', 450)
ON CONFLICT (chapter_id) DO NOTHING;

INSERT INTO hn.templates (template_id, name, description) VALUES
  (71, 'HN Template 71', 'Imported from hokut'),
  (72, 'HN Template 72', 'Imported from hokut'),
  (75, 'HN Template 75', 'Imported from hokut'),
  (77, 'HN Template 77', 'Imported from hokut'),
  (79, 'HN Template 79', 'Imported from hokut'),
  (81, 'HN Template 81', 'Imported from hokut'),
  (83, 'HN Template 83', 'Imported from hokut'),
  (85, 'HN Template 85', 'Imported from hokut')
ON CONFLICT (template_id) DO NOTHING;

INSERT INTO hn.templates_chapters (template_id, chapter_id, chapter_index) VALUES
  (71, 'HN01', 0), (71, 'HN02', 1),
  (72, 'HN03', 0), (72, 'HN04', 1),
  (75, 'HN01', 0), (75, 'HN02', 1),
  (77, 'HN01', 0), (77, 'HN02', 1),
  (79, 'HN01', 0), (79, 'HN02', 1),
  (81, 'HN01', 0), (81, 'HN02', 1),
  (83, 'HN01', 0), (83, 'HN02', 1),
  (85, 'HN01', 0), (85, 'HN02', 1)
ON CONFLICT DO NOTHING;

-- Mivdak chapters.
INSERT INTO mivdak.chapters (chapter_id, name, description, base_time) VALUES
  ('MV01', 'Mivdak A', 'Standard mivdak chapter A', 300),
  ('MV02', 'Mivdak B', 'Standard mivdak chapter B', 300),
  ('MV03', 'Mivdak Math', 'Math-focused mivdak', 400)
ON CONFLICT (chapter_id) DO NOTHING;

-- Pilots chapters and links.
INSERT INTO pilots.chapters (chapter_id, name, description, max_time, pilot_type) VALUES
  ('PL01', 'New Questions Test', 'Pilot of new question content', 400, 'NEW_QUESTIONS'),
  ('PL02', 'New Parameters Test', 'Pilot of new scoring params', 400, 'NEW_PARAMETERS'),
  ('PL03', 'Spatial Pilot', 'Spatial reasoning pilot', 400, 'NEW_QUESTIONS')
ON CONFLICT (chapter_id) DO NOTHING;

INSERT INTO pilots.templates_chapters (template_id, chapter_id, chapter_index) VALUES
  (20, 'PL01', 0),
  (20, 'PL02', 1),
  (20, 'PL03', 2)
ON CONFLICT DO NOTHING;

SET session_replication_role = origin;

SELECT 'seed applied' AS info;
