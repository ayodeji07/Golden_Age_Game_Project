/*
Top selling video games Project

Created Database named ' golden_age'

Created a Schema named 'golden_game'

Created two tables 'game_sales' and 'reviews'

Imported two CSV files named 'game_sales' and 'game_reviews' into 'game_sales' and 'reviews' tables respectively.

*/

-- Created game_sales Table
create table golden_game.game_sales
(
  game VARCHAR(100) PRIMARY KEY,
  platform VARCHAR(64),
  publisher VARCHAR(64),
  developer VARCHAR(64),
  games_sold NUMERIC(5, 2),
  year INT
);

-- Created reviews table
CREATE TABLE golden_game.reviews
(
    game VARCHAR(100) PRIMARY KEY,
    critic_score NUMERIC(4, 2),   
    user_score NUMERIC(4, 2)
);


-- Selected all rows from game_sales table
SELECT * FROM golden_game.game_sales;


-- Selected all rows from reviews table
SELECT * FROM golden_game.reviews;


-- Selected all information for the top ten best-selling games
-- Ordered the results from best-selling game down to tenth best-selling
SELECT *
FROM golden_game.game_sales
ORDER BY games_sold DESC
LIMIT 10;


-- Joined games_sales and reviews
-- Selected a count of the number of games where both critic_score and user_score are null
SELECT COUNT(g.game)
FROM golden_game.game_sales AS g
LEFT JOIN golden_game.reviews AS r
ON g.game=r.game
WHERE critic_score IS NULL AND user_score IS NULL;


-- Selected release year and average critic score for each year, rounded and aliased
-- Joined the game_sales and reviews tables
-- Grouped by release year
-- Ordered the data from highest to lowest avg_critic_score and limit to 10 results

SELECT g.year, ROUND(AVG(r.critic_score), 2) AS avg_critic_score
FROM golden_game.game_sales AS g
LEFT JOIN golden_game.reviews AS r
ON g.game=r.game
GROUP BY g.year
ORDER BY avg_critic_score DESC
LIMIT 10;


-- Updated quuery from previous to add a count of games released in each year called num_games
-- Returned years that have more than four reviewed games

SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM golden_game.game_sales g
INNER JOIN golden_game.reviews r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;


-- Created 'top_critics' and 'top_critics_over_four_years' from last two previous results.
CREATE TABLE golden_game.top_critics (
    year INT PRIMARY KEY,
    avg_critic_score NUMERIC(4, 2)  
);

CREATE TABLE golden_game.top_critics_over_four_years (
    year INT PRIMARY KEY,
    num_games INT,
    avg_critic_score NUMERIC(4, 2)  
);


-- Selected the year and avg_critic_score for those years that dropped off the list of critic favorites 
-- Ordered the results from highest to lowest avg_critic_score

SELECT year, avg_critic_score
FROM golden_game.top_critics
EXCEPT
SELECT year, avg_critic_score
FROM golden_game.top_critics_over_four_years
ORDER BY avg_critic_score DESC;


-- Selected year, an average of user_score, and a count of games released in a given year, aliased and rounded
-- Included only years with more than four reviewed games; group data by year
-- Ordered data by avg_user_score, and limit to ten results

SELECT g.year,
    COUNT(g.game) AS num_games,
    ROUND(AVG(r.user_score), 2) AS avg_user_score
FROM golden_game.game_sales AS g
INNER JOIN golden_game.reviews AS r
ON g.game=r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10;


-- Created 'top_user_over_four_years' from the result of the previous task

CREATE TABLE golden_game.top_user_over_four_games (
    year INT PRIMARY KEY,
    num_games INT,
    avg_user_score NUMERIC(4, 2)  
);


-- Selected the year results that appear on both tables
SELECT year
FROM golden_game.top_critics_over_four_years
INTERSECT
SELECT year
FROM golden_game.top_user_over_four_games;


-- Selected year and sum of games_sold, aliased as total_games_sold; order results by total_games_sold descending
-- Filtered game_sales based on whether each year is in the list returned in the previous task

SELECT year, SUM(games_sold) AS total_games_sold
FROM golden_game.game_sales
WHERE year IN (
    SELECT year
    FROM golden_game.top_critics_over_four_years
    INTERSECT
    SELECT year
    FROM golden_game.top_user_over_four_games
)
GROUP BY year
ORDER BY total_games_sold DESC;