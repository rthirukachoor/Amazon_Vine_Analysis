CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating CHAR(20),
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);


---total_votes count is equal to or greater than 20
CREATE TABLE vine_tabe_helpful_reviews AS
  SELECT * FROM vine_table WHERE total_votes >= 20;
  
  
--all the rows where the number of helpful_votes divided by total_votes is equal to or greater than 50%.
CREATE TABLE vine_tabe_helpful_reviews_1 AS
  SELECT * FROM vine_tabe_helpful_reviews WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5
  
-- table that retrieves all the rows where a review was written as part of the Vine program (paid), vine == 'Y'
CREATE TABLE vine_tabe_helpful_reviews_vine_pgm AS
  SELECT * FROM vine_tabe_helpful_reviews_1 WHERE vine = 'Y'
  
-- table that retrieves all the rows where a review was written not part of the Vine program (unpaid), vine <> 'Y'
CREATE TABLE vine_tabe_helpful_reviews_non_vine_pgm AS
  SELECT * FROM vine_tabe_helpful_reviews_1 WHERE vine <> 'Y'
  

 SELECT vine, count(*) FROM vine_tabe_helpful_reviews_1 group by vine
  
--- total number of paid reviews
CREATE TABLE vine_tabe_review_count as 
  select count(review_id) as total_number_of_paid_review, '1' as key from vine_tabe_helpful_reviews_vine_pgm 
  
--number of 5-star paid reviews  
CREATE TABLE vine_tabe_review_count_5star as 
select count(review_id) as total_number_of_paid_5star_review, '1' as key from vine_tabe_helpful_reviews_vine_pgm 
where   star_rating = '5'

-- the percentage of 5-star reviews
select total_number_of_paid_5star_review,total_number_of_paid_review, 
ROUND((total_number_of_paid_5star_review) / (total_number_of_paid_review)::numeric,2)*100 as Percentage_5_star_review
from vine_tabe_review_count  inner join vine_tabe_review_count_5star 
on vine_tabe_review_count.key = vine_tabe_review_count_5star.key

--- total number of non-paid reviews
CREATE TABLE vine_tabe_review_count_unpaid as 
  select count(review_id) as total_number_of_non_paid_review, '1' as key from vine_tabe_helpful_reviews_non_vine_pgm 
  

--number of 5-star non-paid reviews  
CREATE TABLE vine_tabe_review_count_5star_unpaid as 
select count(review_id) as total_number_of_non_paid_5star_review, '1' as key from vine_tabe_helpful_reviews_non_vine_pgm 
where   star_rating = '5'

-- the percentage of 5-star reviews for non-paid-reviews
select total_number_of_non_paid_5star_review,total_number_of_non_paid_review, 
ROUND((total_number_of_non_paid_5star_review) / (total_number_of_non_paid_review)::numeric,2)*100 as Percentage_5_star_review
from vine_tabe_review_count_unpaid  inner join vine_tabe_review_count_5star_unpaid 
on vine_tabe_review_count_unpaid.key = vine_tabe_review_count_5star_unpaid.key
  
  
  