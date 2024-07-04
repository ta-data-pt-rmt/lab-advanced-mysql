USE publications;

/* 
Challenge 1 - Who Have Published What At Where?

In this challenge you will write a MySQL `SELECT` query that joins
various tables to figure out what titles each author has published at which publishers.
Your output should have at least the following columns:

* `AUTHOR ID` - the ID of the author
* `LAST NAME` - author last name
* `FIRST NAME` - author first name
* `TITLE` - name of the published title
* `PUBLISHER` - name of the publisher where the title was published

If your query is correct, the total rows in your output should be the same
as the total number of records in Table `titleauthor`.
*/

CREATE VIEW authors_titles_view AS
SELECT new_table.AUTHOR_ID, new_table.LAST_NAME, new_table.FIRST_NAME, titles.title AS TITLES, publishers.pub_name AS PUBLISHER
FROM 
(SELECT authors.au_id AS AUTHOR_ID, authors.au_lname AS LAST_NAME, authors.au_fname AS FIRST_NAME, titleauthor.title_id
FROM authors
INNER JOIN titleauthor
ON authors.au_id = titleauthor.au_id) AS new_table
INNER JOIN titles
ON new_table.title_id = titles.title_id
INNER JOIN publishers
ON titles.pub_id = publishers.pub_id;

/*
Challenge 2 - Who Have Published How Many At Where?

Elevating from your solution in Challenge 1, query how many titles each author has published at each publisher.
To check if your output is correct, sum up the `TITLE COUNT` column.
The sum number should be the same as the total number of records in Table `titleauthor`.
*/

SELECT AUTHOR_ID, LAST_NAME, FIRST_NAME, PUBLISHER, IFNULL(COUNT(TITLES), 0) AS TOTAL
FROM authors_titles_view
GROUP BY AUTHOR_ID, PUBLISHER
ORDER BY AUTHOR_ID, PUBLISHER;

/*
Challenge 3 - Best Selling Authors

Who are the top 3 authors who have sold the highest number of titles? Write a query to find out.
Requirements:
* Your output should have the following columns:
	* `AUTHOR ID` - the ID of the author
	* `LAST NAME` - author last name
	* `FIRST NAME` - author first name
	* `TOTAL` - total number of titles sold from this author
* Your output should be ordered based on `TOTAL` from high to low.
* Only output the top 3 best selling authors.
*/

SELECT AUTHOR_ID, LAST_NAME, FIRST_NAME, COUNT(TITLE_ID) AS TOTAL
FROM authors_titles_view
GROUP BY AUTHOR_ID, LAST_NAME, FIRST_NAME
ORDER BY TOTAL DESC
LIMIT 3;

/*
Challenge 4 - Best Selling Authors Ranking

Now modify your solution in Challenge 3 so that the output will
display all 23 authors instead of the top 3.
Note that the authors who have sold 0 titles should also appear in your output
(ideally display `0` instead of `NULL` as the `TOTAL`).
Also order your results based on `TOTAL` from high to low.
*/

SELECT 
    AUTHOR_ID, 
    LAST_NAME, 
    FIRST_NAME, 
    IFNULL(COUNT(TITLE_ID), 0) AS TOTAL
FROM 
    authors
LEFT JOIN 
    authors_titles_view ON authors.AUTHOR_ID = authors_titles_view.AUTHOR_ID
GROUP BY 
    authors.AUTHOR_ID, 
    authors.LAST_NAME, 
    authors.FIRST_NAME
ORDER BY 
    TOTAL DESC;
