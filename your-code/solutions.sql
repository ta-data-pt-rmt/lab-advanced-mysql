#10/04/22
USE publications;
/*
Challenge 1 - Most Profiting Authors
who are the top 3 most profiting authors?
*/
# This was my solution on previous lab. It´s wrong.
SELECT 
authors.au_id AS "AUTHOR ID", 
authors.au_lname AS "LAST NAME",
authors.au_fname AS "FIRST NAME",
SUM(sales.qty) AS TOTAL
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
#INNER JOIN publishers
#ON titles.pub_id = publishers.pub_id
INNER JOIN sales
ON titles.title_id = sales.title_id
GROUP BY authors.au_id
ORDER BY TOTAL DESC
LIMIT 5 
;

#Step 1: Calculate the royalties of each sales for each author
##############################################################


######test####
SELECT 
authors.au_id, # AS "AUTHOR ID", 
titles.title_id,
authors.au_lname AS "LAST NAME",
authors.au_fname AS "FIRST NAME",
titles.title,
titles.price , sales.qty , titles.royalty , titleauthor.royaltyper,
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty ,
titles.advance
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
#INNER JOIN publishers
#ON titles.pub_id = publishers.pub_id
INNER JOIN sales
ON titles.title_id = sales.title_id
where authors.au_id='213-46-8915';
###### end test ########


CREATE TEMPORARY TABLE royalties_step1 
SELECT 
authors.au_id, # AS "AUTHOR ID", 
authors.au_lname AS "LAST NAME",
authors.au_fname AS "FIRST NAME",
titles.title_id,
titles.title,
titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 as sales_royalty,
titles.advance
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
#INNER JOIN publishers
#ON titles.pub_id = publishers.pub_id
INNER JOIN sales
ON titles.title_id = sales.title_id;

# DROP TEMPORARY TABLE royalties_step1;
#Step 2: Aggregate the total royalties for each title for each author
######################################################################

SELECT 
titles.title_id,
authors.au_id, 
authors.au_lname AS "LAST NAME",
authors.au_fname AS "FIRST NAME",
titles.title,
#r.sales_royalty
SUM(sales_royalty) AS total_royalties,
SUM(titles.advance) AS total_advance
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
INNER JOIN royalties_step1 r
ON r.title_id = titles.title_id
GROUP BY authors.au_id,titles.title_id
;
#Now that each title has exactly one row for each author


#Step 3: Calculate the total profits of each author
##############################################################

#STORE STEP 2 IN A TEMP TABLE
# DROP TEMPORARY TABLE royalties_step2;
CREATE TEMPORARY TABLE royalties_step2
SELECT 
titles.title_id,
authors.au_id, 
authors.au_lname,
authors.au_fname,
titles.title,
#r.sales_royalty
SUM(sales_royalty) AS total_royalties,
SUM(titles.advance) AS total_advance
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN titles
ON titleauthor.title_id = titles.title_id
INNER JOIN royalties_step1 r
ON r.title_id = titles.title_id
GROUP BY authors.au_id,titles.title_id
;
# 3 Most Profiting Authors are:
SELECT 
au_id, 
au_lname AS "LAST NAME",
au_fname AS "FIRST NAME",
SUM(total_royalties) + SUM(total_advance) AS profit
FROM royalties_step2
GROUP BY au_id
ORDER BY PROFIT DESC
LIMIT 3;

/*
Challenge 2 - Alternative Solution
*/

/*

*/

/*

*/