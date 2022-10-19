USE publications;

/* Challenge 1 - Most Profiting Authors */

SELECT paut.au_id AS 'Author ID', SUM(paut.tot_royalties) AS Profits
  FROM (
	SELECT roy.title_id, roy.au_id, SUM(roy.sales_royalty) AS tot_royalties
	  FROM (
		SELECT tit.title_id , taut.au_id, 
			   (IFNULL(tit.price,0)*IFNULL(sal.qty,0)*(IFNULL(tit.royalty,0)/100)*(IFNULL(taut.royaltyper,0)/100)) AS sales_royalty
		  FROM titles AS tit
		INNER JOIN sales AS sal ON tit.title_id = sal.title_id
		INNER JOIN titleauthor AS taut ON tit.title_id = taut.title_id) AS roy
	GROUP BY roy.title_id, roy.au_id) AS paut
 GROUP BY paut.au_id
 ORDER BY SUM(paut.tot_royalties) DESC
 LIMIT 3;
 
/* Challenge 2 - Alternative Solution */

CREATE TEMPORARY TABLE sales_royalties (
	SELECT tit.title_id , taut.au_id, 
		   (IFNULL(tit.price,0)*IFNULL(sal.qty,0)*(IFNULL(tit.royalty,0)/100)*(IFNULL(taut.royaltyper,0)/100)) AS sales_royalty
	  FROM titles AS tit
	INNER JOIN sales AS sal ON tit.title_id = sal.title_id
	INNER JOIN titleauthor AS taut ON tit.title_id = taut.title_id);
    
CREATE TEMPORARY TABLE total_royalties (
SELECT roy.title_id, roy.au_id, SUM(roy.sales_royalty) AS tot_royalties
  FROM sales_royalties AS roy	
GROUP BY roy.title_id, roy.au_id);

SELECT au_id AS 'Author ID', SUM(tot_royalties) AS Profits
  FROM tot_royalties
 GROUP BY au_id
 ORDER BY SUM(tot_royalties) DESC
 LIMIT 3;
 
 /* Challenge 3  */
 
 CREATE TABLE publications.most_profitting_autors
 SELECT paut.au_id, SUM(paut.tot_royalties) AS Profits
  FROM (
	SELECT roy.title_id, roy.au_id, SUM(roy.sales_royalty) AS tot_royalties
	  FROM (
		SELECT tit.title_id , taut.au_id, 
			   (IFNULL(tit.price,0)*IFNULL(sal.qty,0)*(IFNULL(tit.royalty,0)/100)*(IFNULL(taut.royaltyper,0)/100)) AS sales_royalty
		  FROM titles AS tit
		INNER JOIN sales AS sal ON tit.title_id = sal.title_id
		INNER JOIN titleauthor AS taut ON tit.title_id = taut.title_id) AS roy
	GROUP BY roy.title_id, roy.au_id) AS paut
 GROUP BY paut.au_id
 ORDER BY SUM(paut.tot_royalties) DESC
 LIMIT 3;
 
SELECT * 
  FROM publications.most_profitting_autors;
