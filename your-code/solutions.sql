USE Publications;

-- Challenge 1 - Most Profiting Authors

-- 1. Calculate the royalty of each sale for each author.
CREATE TEMPORARY TABLE Royalties_2 AS
SELECT
    ta.title_id AS 'Title ID',
    ta.au_id AS 'Author ID',
    titles.price * sales.qty * titles.royalty / 100 * ta.royaltyper / 100 AS 'Royalty of each sale for each author'
FROM
    titleauthor ta
JOIN
    titles ON ta.title_id = titles.title_id
JOIN
    sales ON ta.title_id = sales.title_id
ORDER BY
    ta.title_id, ta.au_id;

-- 2. Using the output from Step 1 as a temp table, 
-- aggregate the total royalties for each title for each author.
CREATE TEMPORARY TABLE AggregatedRoyalties_3 AS
SELECT
    `Title ID`,
    `Author ID`,
    SUM(`Royalty of each sale for each author`) AS `Aggregated royalties of each title for each author`
FROM
    Royalties_2
GROUP BY
    `Title ID`, `Author ID`;

-- SHOW TABLES;  see all the tables
-- DESCRIBE Royalties_2; see description of value type in the table
SELECT * FROM Royalties_2;
SELECT * FROM AggregatedRoyalties_3;

-- 3. Calculate the total profits of each author
CREATE TEMPORARY TABLE TotalProfits_2 AS
SELECT
    AR.`Author ID`,
    SUM(AR.`Aggregated royalties of each title for each author`) + MAX(Titles.`Advance`) AS `Profits of each author`
FROM
    AggregatedRoyalties_3 AR
JOIN
    Titles ON AR.`Title ID` = Titles.`title_id`
GROUP BY
    AR.`Author ID`
ORDER BY
    `Profits of each author` DESC
LIMIT 3;

SELECT * FROM TotalProfits_2;

-- Find the author's name behind each author ID

CREATE TEMPORARY TABLE MostProfitingAuthors AS
SELECT
    tp.`Author ID`,
    authors.`au_lname` AS `Last Name`,
    authors.`au_fname` AS `First Name`,
    tp.`Profits of each author`
FROM
    TotalProfits_2 tp
JOIN
    authors ON tp.`Author ID` = authors.`au_id`
ORDER BY
    tp.`Profits of each author` DESC
LIMIT 3;

SELECT * FROM MostProfitingAuthors;

-- Challenge 2 - Alternative Solution
-- Create Derived tables

SELECT
    authors.au_id AS `Author ID`,
    authors.au_lname AS `Last Name`,
    authors.au_fname AS `First Name`,
    SUM(MostProfitingAuthors.`Aggregated royalties of each title for each author`) + MAX(titles.advance) AS `Profits of each author`
FROM (
    -- Subquery for aggregating the total royalties for each title for each author
    SELECT
        TA.title_id AS 'Title ID',
        TA.au_id AS 'Author ID',
        SUM(titles.price * sales.qty * titles.royalty / 100 * TA.royaltyper / 100) AS 'Aggregated royalties of each title for each author',
        titles.advance
    FROM
        titleauthor TA
    JOIN
        titles ON TA.title_id = titles.title_id
    JOIN
        sales ON TA.title_id = sales.title_id
    GROUP BY
        TA.title_id, TA.au_id
) AS MostProfitingAuthors
JOIN titles ON titles.title_id = MostProfitingAuthors.`Title ID`
JOIN authors ON MostProfitingAuthors.`Author ID` = authors.au_id
GROUP BY
    authors.au_id, authors.au_lname, authors.au_fname
ORDER BY
    `Profits of each author` DESC
LIMIT 3;


-- Challenge 3 - Create permanent table to db
-- = Summary table

-- Create a permanent table named most_profiting_authors
CREATE TABLE IF NOT EXISTS most_profiting_authors (
    au_id VARCHAR(15) PRIMARY KEY,
    profits DECIMAL(10, 2),
    au_lname VARCHAR(120),
    au_fname VARCHAR(120)
);

-- Insert data into the permanent table
INSERT INTO most_profiting_authors (au_id, profits, au_lname, au_fname)
SELECT
    authors.au_id AS `Author ID`,
    SUM(MostProfitingAuthors.`Profits of each author`) AS `Profits of each author`,
    authors.au_lname AS `Last Name`,
    authors.au_fname AS `First Name`
FROM (
    -- Subquery for aggregating the total royalties for each title for each author
    SELECT
        TA.au_id,
        SUM(titles.price * sales.qty * titles.royalty / 100 * TA.royaltyper / 100) + MAX(titles.advance) AS 'Profits of each author'
    FROM
        titleauthor TA
    JOIN
        titles ON TA.title_id = titles.title_id
    JOIN
        sales ON TA.title_id = sales.title_id
    GROUP BY
        TA.au_id
) AS MostProfitingAuthors
JOIN authors ON MostProfitingAuthors.au_id = authors.au_id
GROUP BY
    MostProfitingAuthors.au_id
ORDER BY
    `Profits of each author` DESC
LIMIT 3;

