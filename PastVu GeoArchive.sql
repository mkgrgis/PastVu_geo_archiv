-- "PastVu"."JSON_API" definition

-- Drop table

-- DROP TABLE "PastVu"."JSON_API";

CREATE TABLE "PastVu"."JSON_API" (
	"Id" int4 NOT NULL,
	"JSON" jsonb NULL,
	void bool NOT NULL
);
CREATE INDEX "JSON_API_Id_IDX" ON "PastVu"."JSON_API" USING btree (jsonb_path_query_array(("JSON" -> 'regions'::text), '$[*]."cid"'::jsonpath));


-- "PastVu".dir definition

-- Drop table

-- DROP TABLE "PastVu".dir;

CREATE TABLE "PastVu".dir (
	dir varchar(4) NOT NULL,
	α float4 NOT NULL,
	CONSTRAINT dir_pk PRIMARY KEY (dir)
);

INSERT INTO "PastVu".dir (dir,α) VALUES
	 ('n',0.0),
	 ('ne',45.0),
	 ('e',90.0),
	 ('se',135.0),
	 ('s',180.0),
	 ('sw',225.0),
	 ('w',270.0),
	 ('nw',315.0);
	 
-- "PastVu"."GeoPhoto" source

CREATE OR REPLACE VIEW "PastVu"."GeoPhoto"
AS SELECT a."Id",
    (a."JSON" ->> 'h'::text)::integer AS h,
    (a."JSON" ->> 'w'::text)::integer AS w,
    (a."JSON" ->> 's'::text)::integer AS s,
    (a."JSON" ->> 'hs'::text)::integer AS hs,
    (a."JSON" ->> 'ws'::text)::integer AS ws,
    (a."JSON" ->> 'cid'::text)::integer AS cid,
    a."JSON" ->> 'dir'::text AS dir,
    d."α",
    a."JSON" ->> 'y'::text AS "Интервал",
    to_date(a."JSON" ->> 'year'::text, 'YYYY'::text) AS "t⇤",
    to_date(a."JSON" ->> 'year2'::text, 'YYYY'::text) AS "t⇥",
    st_setsrid(st_point(((a."JSON" -> 'geo'::text) ->> 1)::double precision, ((a."JSON" -> 'geo'::text) ->> 0)::double precision), 4326) AS "φλ₀",
    a."JSON" ->> 'file'::text AS "imgURL",
    a."JSON" ->> 'mime'::text AS mime,
    (a."JSON" ->> 'size'::text)::integer AS imgbyte,
    (a."JSON" ->> 'type'::text)::integer AS type,
    a."JSON" ->> 'title'::text AS title,
    a."JSON" ->> 'source'::text AS source,
    to_timestamp(a."JSON" ->> 'adate'::text, 'YYYY-MM-DDTHH:MI:SSZ'::text) AS adate,
    to_timestamp(a."JSON" ->> 'cdate'::text, 'YYYY-MM-DDTHH:MI:SSZ'::text) AS cdate,
    to_timestamp(a."JSON" ->> 'ldate'::text, 'YYYY-MM-DDTHH:MI:SSZ'::text) AS ldate,
    to_timestamp(a."JSON" ->> 'stdate'::text, 'YYYY-MM-DDTHH:MI:SSZ'::text) AS stdate,
    to_timestamp(a."JSON" ->> 'ucdate'::text, 'YYYY-MM-DDTHH:MI:SSZ'::text) AS ucdate,
    (a."JSON" ->> 'ccount'::text)::integer AS ccount,
    (a."JSON" ->> 'vdcount'::text)::integer AS vdcount,
    (a."JSON" ->> 'vwcount'::text)::integer AS vwcount,
    a."JSON" ->> 'watersignText'::text AS "watersignText",
    a."JSON" -> 'user'::text AS "user",
    a."JSON" -> 'frags'::text AS frag
   FROM "PastVu"."JSON_API" a
     LEFT JOIN "PastVu".dir d ON (a."JSON" ->> 'dir'::text) = d.dir::text
  WHERE NOT a.void;
