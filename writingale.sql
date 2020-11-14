-- -------------------------------------------------------------
-- TablePlus 3.10.0(348)
--
-- https://tableplus.com/
--
-- Database: writingale
-- Generation Time: 2020-11-14 22:05:52.3510
-- -------------------------------------------------------------




DROP TABLE IF EXISTS "public"."articles";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS articles_id_seq;

-- Table Definition
CREATE TABLE "public"."articles" (
    "id" int4 NOT NULL DEFAULT nextval('articles_id_seq'::regclass),
    "name" varchar NOT NULL,
    "created_at" timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."sections";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS sections_id_seq;

-- Table Definition
CREATE TABLE "public"."sections" (
    "id" int4 NOT NULL DEFAULT nextval('sections_id_seq'::regclass),
    "article_id" int4,
    "section_id" int4,
    "contents" text,
    "sorting" int4,
    "created_at" timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY ("id")
);

CREATE OR REPLACE FUNCTION public.fix_sorting()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	UPDATE
		sections
	SET
		sorting = sorting + 1
	WHERE ((article_id IS NOT NULL
			AND article_id = NEW.article_id)
		or(section_id IS NOT NULL
			AND section_id = NEW.section_id))
	AND id != NEW.id
	AND sorting >= NEW.sorting;
	RETURN NEW;
END;
$function$;
ALTER TABLE "public"."sections" ADD FOREIGN KEY ("article_id") REFERENCES "public"."articles"("id") ON DELETE CASCADE;
ALTER TABLE "public"."sections" ADD FOREIGN KEY ("section_id") REFERENCES "public"."sections"("id") ON DELETE CASCADE;
