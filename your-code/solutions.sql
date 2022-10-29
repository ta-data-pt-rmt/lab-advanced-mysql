USE lab_mysql_select;

SELECT * 
from authors;

/*Challenge 1 - Who Have Published What At Where?*/

SELECT aut.au_id, au_lname, au_fname, tit.title, pub.pub_name
FROM authors AS aut
INNER JOIN titleauthor AS taut ON aut.au_id = taut.au_id
INNER JOIN titles AS tit ON taut.title_id = tit.title_id
INNER JOIN publishers AS pub ON tit.pub_id = pub.pub_id
order by aut.au_id;

/* Challenge 2 - Who Have Published How Many At Where? */

SELECT aut.au_id, au_lname, au_fname,  pub.pub_name, COUNT(tit.title_id) AS "Total Published"
FROM authors AS aut
INNER JOIN titleauthor AS taut ON aut.au_id = taut.au_id
INNER JOIN titles AS tit ON taut.title_id = tit.title_id
INNER JOIN publishers AS pub ON tit.pub_id = pub.pub_id
GROUP BY aut.au_id, au_lname, au_fname, pub.pub_name
ORDER BY aut.au_id DESC, pub.pub_name;

/*Challenge 3 - Best Selling Authors */

SELECT * 
From SALES;

SELECT aut.au_id, au_lname, au_fname, SUM(sal.qty) AS "TOTAL"
FROM authors AS aut
INNER JOIN titleauthor AS taut ON aut.au_id = taut.au_id
INNER JOIN titles AS tit ON taut.title_id = tit.title_id
INNER JOIN sales AS sal ON tit.title_id = sal.title_id
GROUP BY aut.au_id, au_lname, au_fname
ORDER BY SUM(sal.qty) DESC
LIMIT 3;

/*Challenge 4 - Best Selling Authors Ranking*/

SELECT aut.au_id, au_lname, au_fname, IFNULL(SUM(sal.qty),0) AS "TOTAL SALES"
FROM authors AS aut
INNER JOIN titleauthor AS taut ON aut.au_id = taut.au_id
INNER JOIN titles AS tit ON taut.title_id = tit.title_id
INNER JOIN sales AS sal ON tit.title_id = sal.title_id
GROUP BY aut.au_id, au_lname, au_fname
ORDER BY SUM(sal.qty) DESC;