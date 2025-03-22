-- ~7 minutes
DROP TABLE IF EXISTS title_basics;
CREATE TABLE title_basics AS
SELECT 
    tconst,
    titleType,
    primaryTitle,
    originalTitle,
    CASE WHEN isAdult = '1' THEN TRUE ELSE FALSE END AS isAdult,
    NULLIF(startYear, '')::INT AS startYear,
    NULLIF(endYear, '')::INT AS endYear,
    NULLIF(runtimeMinutes, '')::INT AS runtimeMinutes,
    NULLIF(genres, '') AS genres
FROM staging_title_basics;

DROP TABLE IF EXISTS title_akas;
CREATE TABLE title_akas AS
SELECT 
    titleId,
    ordering::INT AS ordering,
    title,
    region,
    language,
    types,
    attributes,
    CASE WHEN isOriginalTitle = '1' THEN TRUE ELSE FALSE END AS isOriginalTitle
FROM staging_title_akas;

DROP TABLE IF EXISTS name_basics;
CREATE TABLE name_basics AS
SELECT 
    nconst,
    primaryName,
    NULLIF(birthYear, '')::INT AS birthYear,
    NULLIF(deathYear, '')::INT AS deathYear,
    NULLIF(primaryProfession, '') AS primaryProfession,
    NULLIF(knownForTitles, '') AS knownForTitles
FROM staging_name_basics;

DROP TABLE IF EXISTS title_episode;
CREATE TABLE title_episode AS
SELECT 
    tconst,
    parentTconst,
    NULLIF(seasonNumber, '')::INT AS seasonNumber,
    NULLIF(episodeNumber, '')::INT AS episodeNumber
FROM staging_title_episode;

DROP TABLE IF EXISTS title_principals;
CREATE TABLE title_principals AS
SELECT 
    tconst,
    ordering::INT AS ordering,
    nconst,
    category,
    job,
    characters
FROM staging_title_principals;

DROP TABLE IF EXISTS title_ratings;
CREATE TABLE title_ratings AS
SELECT 
    tconst,
    NULLIF(averageRating, '')::FLOAT AS averageRating,
    NULLIF(numVotes, '')::INT AS numVotes
FROM staging_title_ratings;

DROP TABLE IF EXISTS title_crew;
CREATE TABLE title_crew AS
SELECT 
    tconst,
    NULLIF(directors, '') AS directors,
    NULLIF(writers, '') AS writers
FROM staging_title_crew;
