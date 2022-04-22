USE publications;

SELECT a.au_id AS AUTHOR_ID , a.au_lname AS LAST_NAME, a.au_fname AS FIRS_NAME, SUM(s.qty) AS TOTAL
FROM authors AS a 
LEFT JOIN titleauthor AS ta ON ta.au_id = a.au_id
LEFT JOIN titles AS t ON ta.title_id = t.title_id
LEFT JOIN sales AS s ON s.title_id = t.title_id
GROUP BY AUTHOR_ID
ORDER BY TOTAL DESC
lIMIT 3;

SELECT * FROM sales;

-- STEP 1 Calculate the royalties of each sales for each author
-- Write a SELECT query to obtain the following output:
-- Title ID
-- Author ID
-- Royalty of each sale for each author
-- The formular is:
-- sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100
-- Note that titles.royalty and titleauthor.royaltyper are divided by 100 respectively because they are percentage numbers instead of floats.
-- In the output of this step, each title may appear more than once for each author. This is because a title can have more than one sales.

SELECT s.title_id, a.au_id AS AUTHOR_ID , t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 AS sales_royalty  
FROM authors AS a 
LEFT JOIN titleauthor AS ta ON ta.au_id = a.au_id
LEFT JOIN titles AS t ON ta.title_id = t.title_id
LEFT JOIN sales AS s ON s.title_id = t.title_id;

-- STEP 2 Aggregate the total royalties for each title for each author
-- Using the output from Step 1, write a query to obtain the following output:
-- Title ID
-- Author ID
-- Aggregated royalties of each title for each author
-- Hint: use the SUM subquery and group by both au_id and title_id
-- In the output of this step, each title should appear only once for each author.
SELECT 
	sumsal.title_id,
    sumsal.AUTHOR_ID , 
	SUM(sumsal.sales_royalty) AS total_profit
FROM (SELECT s.title_id, a.au_id AS AUTHOR_ID , t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 AS sales_royalty  
	FROM authors AS a 
	LEFT JOIN titleauthor AS ta ON ta.au_id = a.au_id
	LEFT JOIN titles AS t ON ta.title_id = t.title_id
	LEFT JOIN sales AS s ON s.title_id = t.title_id) AS sumsal
GROUP BY sumsal.AUTHOR_ID, sumsal.title_id;




-- Step 3: Calculate the total profits of each author
-- Now that each title has exactly one row for each author where the advance and royalties are available, we are ready to obtain the eventual output. Using the output from Step 2, write a query to obtain the following output:
-- Author ID
-- Profits of each author by aggregating the advance and total royalties of each title
-- Sort the output based on a total profits from high to low, and limit the number of rows to 3.

SELECT
	 total_profit_by_author.AUTHOR_ID,
    SUM(total_profit_by_author.total_profit) AS Tot_prof_by_author
FROM
	(SELECT 
	sumsal.title_id,
    sumsal.AUTHOR_ID , 
	SUM(sumsal.sales_royalty) AS total_profit
FROM (SELECT s.title_id, a.au_id AS AUTHOR_ID , t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 AS sales_royalty  
	FROM authors AS a 
	LEFT JOIN titleauthor AS ta ON ta.au_id = a.au_id
	LEFT JOIN titles AS t ON ta.title_id = t.title_id
	LEFT JOIN sales AS s ON s.title_id = t.title_id) AS sumsal
GROUP BY sumsal.AUTHOR_ID, sumsal.title_id
    ) AS total_profit_by_author
GROUP BY  total_profit_by_author.AUTHOR_ID
ORDER BY total_profit DESC
LIMIT 3;

-- Bonus who are this Autors?

SELECT 
	top3_prof.AUTHOR_ID ,
    a.au_fname AS AUTHOR_FIRST_NAME,
    a.au_lname AS AUTHOR_LAST_NAME,
    top3_prof.Tot_prof_by_author
FROM ( SELECT
	 total_profit_by_author.AUTHOR_ID,
    SUM(total_profit_by_author.total_profit) AS Tot_prof_by_author
FROM
	(SELECT 
	sumsal.title_id,
    sumsal.AUTHOR_ID , 
	SUM(sumsal.sales_royalty) AS total_profit
FROM (SELECT s.title_id, a.au_id AS AUTHOR_ID , t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 AS sales_royalty  
	FROM authors AS a 
	LEFT JOIN titleauthor AS ta ON ta.au_id = a.au_id
	LEFT JOIN titles AS t ON ta.title_id = t.title_id
	LEFT JOIN sales AS s ON s.title_id = t.title_id) AS sumsal
GROUP BY sumsal.AUTHOR_ID, sumsal.title_id
    ) AS total_profit_by_author
GROUP BY  total_profit_by_author.AUTHOR_ID
ORDER BY total_profit DESC
LIMIT 3
) AS top3_prof
JOIN authors AS a
ON top3_prof.AUTHOR_ID = a.au_id

