-- ~8 minutes 
COPY staging_title_basics FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/title.basics.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
COPY staging_title_akas FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/title.akas.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
COPY staging_name_basics FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/name.basics.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
COPY staging_title_principals FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/title.principals.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
COPY staging_title_episode FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/title.episode.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
COPY staging_title_ratings FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/title.ratings.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
COPY staging_title_crew FROM 'C:/Program Files/PostgreSQL/17/data/imdb_data/title.crew.tsv' WITH DELIMITER E'\t' NULL '\N' CSV HEADER QUOTE E'\b' ESCAPE E'\b';
