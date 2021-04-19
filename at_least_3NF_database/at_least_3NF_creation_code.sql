
CREATE DATABASE IF NOT EXISTS `vasyl_ivanchyk_project` DEFAULT CHARACTER SET utf8 COLLATE utf8_polish_ci;
USE `vasyl_ivanchyk_project`;



CREATE TABLE IF NOT EXISTS `countries`(
	country_id int auto_increment primary key unique,
    country_name VARCHAR(120),
    country_region VARCHAR(120)
);


CREATE TABLE IF NOT EXISTS `seasons`(
	season_id int auto_increment primary key unique,
    season_date_started DATE,
    season_date_ended DATE,
    if_full ENUM("YES", "NO")
);

CREATE TABLE IF NOT EXISTS `clubs`(
	club_id int auto_increment primary key unique,
    club_name VARCHAR(120),
    city VARCHAR(50),
    number_of_players SMALLINT UNSIGNED,
    year_of_origin YEAR,
    titles_won TINYINT UNSIGNED,
    home_kit_colors VARCHAR(50),
    away_kit_colors VARCHAR(50),
    third_kit_colors VARCHAR(50),
	country_id int,
	FOREIGN KEY (country_id)
    REFERENCES countries(country_id)
);

CREATE TABLE IF NOT EXISTS `team_types`(
	team_type_id int auto_increment primary key unique,
    team_type ENUM("first team", "second team", "U16", "U23")
);

CREATE TABLE IF NOT EXISTS `players`(
	player_id int auto_increment primary key unique,
    player_number SMALLINT UNSIGNED,
    player_name VARCHAR(50),
    player_surname VARCHAR(50),
    player_other_names VARCHAR(265),
    field_position VARCHAR(50),
    goals SMALLINT UNSIGNED,
    assists SMALLINT UNSIGNED,
    clean_sheets SMALLINT UNSIGNED,
    munites_played MEDIUMINT UNSIGNED,
    birth_date DATE,
	country_id int,
	FOREIGN KEY (country_id)
    REFERENCES countries(country_id)
);

CREATE TABLE IF NOT EXISTS `clubs_to_players`(
	id int auto_increment primary key unique,
    club_id int,
    FOREIGN KEY (club_id)
    REFERENCES clubs(club_id),
    team_type_id int,
    FOREIGN KEY (team_type_id)
    REFERENCES team_types(team_type_id),
    player_id int,
    FOREIGN KEY (player_id)
    REFERENCES players(player_id)
);


CREATE TABLE IF NOT EXISTS `stadiums`(
	stadium_id int auto_increment primary key unique,
    stadium_name VARCHAR(265),
    capacity MEDIUMINT UNSIGNED,
    city VARCHAR(50),
    club_id int,
	FOREIGN KEY (club_id)
    REFERENCES clubs(club_id)
);

CREATE TABLE IF NOT EXISTS `backroom_staff`(
	backroom_staff_id int auto_increment primary key unique,
    name VARCHAR(50),
    surname VARCHAR(50),
    birth_date DATE,
    backroom_staff_department_type SET('The Main Coach', 'The Assistant Manager', 'The Goalkeeping Coach', 'Chief Analyst', 'Fitness Coach', 'Conditioning Coach', 'Chef / Nutritionist', 'Physiotherapist', 'Masseur', 'Scout', 'Kit Manager', 'Youth Team Coach'),
    if_head_of_department ENUM("Yes", "No"),
    club_id int,
	FOREIGN KEY (club_id)
    REFERENCES clubs(club_id)
);

CREATE TABLE IF NOT EXISTS `tournaments`(
	tournament_id int auto_increment primary key unique,
    tournament_name VARCHAR(265),
    tournament_type VARCHAR(50),
    tournament_award_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS `tournament_stages`(
	tournament_stage_id int auto_increment primary key unique,
    tournament_stage_name VARCHAR(265),
    tournament_stage_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS `tournament_stage_tours`(
	tournament_stage_tour_id int auto_increment primary key unique,
    tournament_stage_tour_name VARCHAR(50),
    tournament_stage_tour_type VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS `games`(
	game_id int auto_increment primary key unique,
    game_date DATE,
    home_team_score TINYINT UNSIGNED,
    away_team_score TINYINT UNSIGNED,
    yellow_cards_shown TINYINT UNSIGNED,
    red_cards_shown TINYINT UNSIGNED,
    home_team_id int,
    CONSTRAINT FK_home_team_id
    FOREIGN KEY (home_team_id)
    REFERENCES clubs(club_id),
    away_team_id int,
    CONSTRAINT FK_away_team_id
    FOREIGN KEY (away_team_id)
    REFERENCES clubs(club_id),
    tournament_stage_tour_id int,
    FOREIGN KEY (tournament_stage_tour_id)
    REFERENCES tournament_stage_tours(tournament_stage_tour_id)
);



CREATE TABLE IF NOT EXISTS `games_to_stadiums`(
	id int auto_increment primary key unique,
    game_id int,
	FOREIGN KEY (game_id)
    REFERENCES games(game_id),
	stadium_id int,
	FOREIGN KEY (stadium_id)
    REFERENCES stadiums(stadium_id)
);




CREATE TABLE IF NOT EXISTS `seasons_to_tournaments_to_games`(
	id int auto_increment primary key unique,
    season_id int,
    FOREIGN KEY (season_id)
    REFERENCES seasons(season_id),
    tournament_id int,
    FOREIGN KEY (tournament_id)
    REFERENCES tournaments(tournament_id),
    stage_id int,
    FOREIGN KEY (stage_id)
    REFERENCES tournament_stages(tournament_stage_id),
    tour_id int,
    FOREIGN KEY (tour_id)
    REFERENCES tournament_stage_tours(tournament_stage_tour_id),
    game_id int,
    FOREIGN KEY (game_id)
    REFERENCES games(game_id)
);

CREATE TABLE IF NOT EXISTS `league_table`(
	league_table_id int auto_increment primary key unique,
    season_id int,
    FOREIGN KEY (season_id)
    REFERENCES seasons(season_id),
    tournament_id int,
    FOREIGN KEY (tournament_id)
    REFERENCES tournaments(tournament_id)
);

CREATE TABLE IF NOT EXISTS `positions`(
	position_id int auto_increment primary key unique
);

CREATE TABLE IF NOT EXISTS `league_tables_with_teams`(
    league_table_id int,
    FOREIGN KEY (league_table_id)
    REFERENCES league_table(league_table_id),
    position_id int,
    FOREIGN KEY (position_id)
    REFERENCES positions(position_id),
    club_id int,
	FOREIGN KEY (club_id)
    REFERENCES clubs(club_id),
    games_played TINYINT UNSIGNED,
    win_games TINYINT UNSIGNED,
    draw_games TINYINT UNSIGNED,
    loss_games TINYINT UNSIGNED,
    goal_difference TINYINT UNSIGNED,
    goals_against TINYINT UNSIGNED,
    goals_for TINYINT UNSIGNED,
    points TINYINT UNSIGNED
);

CREATE TABLE IF NOT EXISTS `player_goal_stats`(
	position_id int,
	FOREIGN KEY (position_id)
    REFERENCES positions(position_id),
    season_id int,
    FOREIGN KEY (season_id)
    REFERENCES seasons(season_id),
    tournament_id int,
    FOREIGN KEY (tournament_id)
    REFERENCES tournaments(tournament_id),
    player_id int,
    FOREIGN KEY (player_id)
    REFERENCES players(player_id),
    number_of_goals SMALLINT UNSIGNED
);

CREATE TABLE IF NOT EXISTS `sponsors`(
	sponsor_id int auto_increment primary key unique,
    sponsor_name VARCHAR(265),
    clubs_sponsor_industry VARCHAR(265)
);

CREATE TABLE IF NOT EXISTS `sponsors_to_tournaments`(
	sponsor_to_tournament_id int auto_increment primary key unique,
    sponsor_id int,
	FOREIGN KEY (sponsor_id)
    REFERENCES sponsors(sponsor_id),
	tournament_id int,
	FOREIGN KEY (tournament_id)
    REFERENCES tournaments(tournament_id),
    sum_sponsored_last_season_EUR BIGINT UNSIGNED,
    sum_sponsored_for_all_time_EUR BIGINT UNSIGNED
);

CREATE TABLE IF NOT EXISTS `sponsors_to_clubs`(
	sponsor_to_tournament_id int auto_increment primary key unique,
    sponsor_id int,
	FOREIGN KEY (sponsor_id)
    REFERENCES sponsors(sponsor_id),
	club_id int,
	FOREIGN KEY (club_id)
    REFERENCES clubs(club_id),
    sum_sponsored_last_season_EUR BIGINT UNSIGNED,
    sum_sponsored_for_all_time_EUR BIGINT UNSIGNED
);