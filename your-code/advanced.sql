USE lab_mysql_select;

SELECT * from roysched;

/*Challenge 1*/
/*DROP TEMPORARY TABLE royalties*/
CREATE TEMPORARY TABLE royalties AS
SELECT  taut.au_id, sal.title_id, tit.price*sal.qty*(tit.royalty/100)*(taut.royaltyper/100) AS Sales_Royalty 
FROM sales AS sal
INNER JOIN titleauthor AS taut
ON sal.title_id = taut.title_id
INNER JOIN titles as tit
ON sal.title_id = tit.title_id
ORDER BY sales_royalty DESC;

/*Challenge 2*/

select * from royalties;

CREATE TEMPORARY TABLE AGG_ROYALTY AS
SELECT au_id, title_id, SUM(Sales_Royalty) AS Aggregated_Royalty
FROM royalties 
GROUP BY au_id, title_id
ORDER BY Aggregated_Royalty DESC;

select * from titles;

/*Challenge 3*/

SELECT au_id as "Author ID", (tit.advance+Aggregated_Royalty) as Total_Profit_per_author
FROM AGG_ROYALTY
INNER JOIN titles as tit
GROUP BY au_id
ORDER BY Total_Profit_per_author DESC
LIMIT 3;