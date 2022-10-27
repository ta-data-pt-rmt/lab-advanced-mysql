
USE `publications`;


/* ############################################
   ##  Challenge 1 - Most profiting authors  ##
   ############################################ */

/* Step 1: Calculate the royalty/sale for each author */

CREATE TEMPORARY TABLE sales_royalties
SELECT titleauthor.title_id AS `Title ID`, au_id AS `Author ID`, price * qty * royalty/100 * royaltyper/100 AS `Royalties per Sale`
FROM titleauthor
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN sales ON titleauthor.title_id = sales.title_id;

SELECT * FROM sales_royalties;

/* Step 2: Aggregate the total royalty/title for each author */

CREATE TEMPORARY TABLE titles_royalties
SELECT `Title ID`, `Author ID`, SUM(`Royalties per Sale`) AS `Royalties per Title`
FROM sales_royalties
GROUP BY `Title ID`, `Author ID`;

SELECT * FROM titles_royalties;

/* Step 3: Calculate the total profits of each author */

SELECT `Author ID`, SUM(`Royalties per Title`) + SUM(advance) AS `Total Profits`
FROM titles_royalties
JOIN titles ON `Title ID` = title_id
GROUP BY `Author ID`
ORDER BY `Total Profits` DESC
LIMIT 3;


/* ##########################################
   ##  Challenge 2 - Alternative solution  ##
   ########################################## */

/* Step 3: Calculate the total profits of each author */

SELECT `Author ID`, SUM(`Royalties per Title`) + SUM(advance) AS `Total Profits`
FROM

   /* Step 2: Aggregate the total royalty/title for each author */

   (SELECT `Title ID`, `Author ID`, SUM(`Royalties per Sale`) AS `Royalties per Title`
   FROM

      /* Step 1: Calculate the royalty/sale for each author */

      (SELECT titleauthor.title_id AS `Title ID`, au_id AS `Author ID`, price * qty * royalty/100 * royaltyper/100 AS `Royalties per Sale`
      FROM titleauthor
      JOIN titles ON titleauthor.title_id = titles.title_id
      JOIN sales ON titleauthor.title_id = sales.title_id) sales_royalties

   GROUP BY `Title ID`, `Author ID`) titles_royalties

JOIN titles ON `Title ID` = title_id
GROUP BY `Author ID`
ORDER BY `Total Profits` DESC
LIMIT 3;


/* #####################################
   ##  Challenge 3 - Permanent table  ##
   ##################################### */

DROP TABLE IF EXISTS most_profiting_authors;

CREATE TABLE most_profiting_authors
(SELECT `Author ID`, SUM(`Royalties per Title`) + SUM(advance) AS `Total Profits`
FROM titles_royalties
JOIN titles ON `Title ID` = title_id
GROUP BY `Author ID`
ORDER BY `Total Profits` DESC);

SELECT * FROM most_profiting_authors;
