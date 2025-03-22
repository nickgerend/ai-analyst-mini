DROP TABLE IF EXISTS staging_title_basics;
CREATE TABLE staging_title_basics (
    tconst TEXT,
    titleType TEXT,
    primaryTitle TEXT,
    originalTitle TEXT,
    isAdult TEXT,  -- Store as TEXT temporarily
    startYear TEXT,
    endYear TEXT,
    runtimeMinutes TEXT,
    genres TEXT
);

DROP TABLE IF EXISTS staging_title_akas;
CREATE TABLE staging_title_akas (
    titleId TEXT,
    ordering TEXT,
    title TEXT,
    region TEXT,
    language TEXT,
    types TEXT,
    attributes TEXT,
    isOriginalTitle TEXT -- Store as TEXT temporarily
);

DROP TABLE IF EXISTS staging_name_basics;
CREATE TABLE staging_name_basics (
    nconst TEXT,
    primaryName TEXT,
    birthYear TEXT,
    deathYear TEXT,
    primaryProfession TEXT,
    knownForTitles TEXT
);

DROP TABLE IF EXISTS staging_title_principals;
CREATE TABLE staging_title_principals (
    tconst TEXT,
    ordering TEXT,
    nconst TEXT,
    category TEXT,
    job TEXT,
    characters TEXT
);

DROP TABLE IF EXISTS staging_title_episode;
CREATE TABLE staging_title_episode (
    tconst TEXT,
    parentTconst TEXT,
    seasonNumber TEXT,
    episodeNumber TEXT
);

DROP TABLE IF EXISTS staging_title_ratings;
CREATE TABLE staging_title_ratings (
    tconst TEXT,
    averageRating TEXT,
    numVotes TEXT
);

DROP TABLE IF EXISTS staging_title_crew;
CREATE TABLE staging_title_crew (
    tconst TEXT,
    directors TEXT,
    writers TEXT
);
