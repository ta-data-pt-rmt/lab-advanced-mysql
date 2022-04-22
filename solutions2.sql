-- TEMPORARY TABLES 

USE publications;
SELECT * FROM authors;

CREATE TEMPORARY TABLE publications.royalties_sales
SELECT s.title_id, a.au_id AS AUTHOR_ID , t.price * s.qty * t.royalty / 100 * ta.royaltyper / 100 AS sales_royalty  
FROM authors AS a 
LEFT JOIN titleauthor AS ta ON ta.au_id = a.au_id
LEFT JOIN titles AS t ON ta.title_id = t.title_id
LEFT JOIN sales AS s ON s.title_id = t.title_id;

SELECT * FROM publications.royalties_sales;


CREATE TEMPORARY TABLE publications.royalties_by_title_author 
SELECT 
	rs.title_id,
    rs.AUTHOR_ID , 
	SUM(rs.sales_royalty) AS total_profit
FROM royalties_sales AS rs
GROUP BY rs.AUTHOR_ID, rs.title_id;

SELECT * FROM publications.royalties_by_title_author;

-- pendiente

CREATE TEMPORARY TABLE publications.total_profits_author
SELECT 
	pt.AUTHOR_ID,
	SUM(pt.total_profit) AS Tot_prof_by_author
FROM royalties_by_title_author AS pt   
GROUP BY  pt.AUTHOR_ID
ORDER BY total_profit DESC
LIMIT 3; 
 
SELECT * FROM  publications.total_profits_author;

-- PERMANENT TABLE

CREATE TABLE top3_royalities
SELECT * 
FROM royalties_by_title_author ;

CREATE TABLE most_profiting_authors
SELECT * 
FROM royalties_by_title_author ;

SELECT * FROM top3_royalities
LIMIT 3 ;

CREATE TABLE TEST
SELECT *
FROM publications.total_profits_author;

SELECT * FROM TEST;