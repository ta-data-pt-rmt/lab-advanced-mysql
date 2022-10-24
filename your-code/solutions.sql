SELECT * FROM authors;
SELECT * FROM discounts;
SELECT * FROM jobs;
SELECT * FROM pub_info;
SELECT * FROM publishers;
SELECT * FROM roysched;
SELECT * FROM sales;
SELECT * FROM stores;
SELECT * FROM titleauthor;
SELECT * FROM titles;

/* CHALLENGE 1 */
/* Step 1: Calculate the royalties of each sales for each author */

DROP TABLE IF EXISTS table1;
CREATE TEMPORARY TABLE table1
SELECT sales.title_id,titleauthor.au_id, titles.advance,
		titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS sales_royalty 
FROM sales
LEFT JOIN titleauthor
ON sales.title_id = titleauthor.title_id
LEFT JOIN titles
ON sales.title_id = titles.title_id;

/* Step 2: Aggregate the total royalties for each title for each author */

DROP TABLE IF EXISTS table2;
CREATE TEMPORARY TABLE table2
SELECT title_id, au_id, advance, SUM(sales_royalty) AS agg_royalty
FROM table1 
GROUP BY au_id, title_id;

/* Step 3: Calculate the total profits of each author */

SELECT au_id, (advance+agg_royalty) as total_profits
FROM table2
GROUP BY au_id
ORDER BY total_profits DESC
LIMIT 3;

/* CHALLENGE 3 */

DROP TABLE IF EXISTS most_profiting_authors;
CREATE TABLE most_profiting_authors
SELECT au_id, (advance+agg_royalty) as total_profits
FROM table2
GROUP BY au_id
ORDER BY total_profits DESC;
