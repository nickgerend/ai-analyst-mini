CREATE TABLE name_basics (
  nconst TEXT PRIMARY KEY, -- Unique identifier for the name/person
  primaryname TEXT, -- Name by which the person is most often credited
  birthyear INTEGER, -- Birth year integer
  deathyear INTEGER, -- Death year integer
  primaryprofession TEXT, -- Top-3 professions of the person (comma separated for 2 or more)
  knownfortitles TEXT -- Titles the person is known for (comma separated for 2 or more)
);

CREATE TABLE title_akas (
  titleid TEXT, -- Alphanumeric unique identifier of the title (tconst)
  ordering INTEGER, -- Unique ordering for each titleid
  title TEXT, -- Localized title
  region TEXT, -- Region for this version of the title
  language TEXT, -- Language of the title
  types TEXT, -- Enumerated set of attributes for this alternative title (comma separated for 2 or more)
  attributes TEXT, -- Additional descriptive terms for this title (comma separated for 2 or more)
  isoriginaltitle BOOLEAN, -- 0: not original title; 1: original title
  PRIMARY KEY (titleid, ordering)
);

CREATE TABLE title_basics (
  tconst TEXT PRIMARY KEY, -- Alphanumeric unique identifier of the title
  titletype TEXT, -- Type/format of the title (e.g. movie, short, tvseries, tvepisode, video, etc.)
  primarytitle TEXT, -- Popular title used in promotional materials
  originaltitle TEXT, -- Original title in the original language
  isadult BOOLEAN, -- 0: non-adult title; 1: adult title
  startyear INTEGER, -- Release year integer of the title
  endyear INTEGER, -- End year integer for TV series; NULL for non-TV series
  runtimeminutes INTEGER, -- Primary runtime in minutes
  genres TEXT -- Genre(s) associated with the title (comma separated for 2 or more)
);

CREATE TABLE title_crew (
  tconst TEXT PRIMARY KEY, -- Alphanumeric unique identifier of the title
  directors TEXT, -- Director(s) of the title (comma separated for 2 or more)
  writers TEXT -- Writer(s) of the title (comma separated for 2 or more)
);

CREATE TABLE title_episode (
  tconst TEXT PRIMARY KEY, -- Alphanumeric identifier of the episode
  parenttconst TEXT, -- Identifier of the parent TV series
  seasonnumber INTEGER, -- Season number the episode belongs to
  episodenumber INTEGER -- Episode number within the TV series
);

CREATE TABLE title_principals (
  tconst TEXT, -- Alphanumeric unique identifier of the title
  ordering INTEGER, -- Unique ordering for each title entry
  nconst TEXT, -- Alphanumeric unique identifier of the name/person
  category TEXT, -- Category of the person's job
  job TEXT, -- Specific job title; NULL if not applicable
  characters TEXT, -- Character name played; NULL if not applicable
  PRIMARY KEY (tconst, ordering)
);

CREATE TABLE title_ratings (
  tconst TEXT PRIMARY KEY, -- Alphanumeric unique identifier of the title
  averagerating DOUBLE PRECISION, -- Weighted average of user ratings
  numvotes INTEGER -- Number of votes the title has received
);

-- Join Relationships:
-- title_akas.titleid can be joined with title_basics.tconst
-- title_crew.tconst can be joined with title_basics.tconst
-- title_episode.tconst can be joined with title_basics.tconst
-- title_episode.parenttconst can be joined with title_basics.tconst (as the parent TV series)
-- title_principals.tconst can be joined with title_basics.tconst
-- title_principals.nconst can be joined with name_basics.nconst
-- title_ratings.tconst can be joined with title_basics.tconst