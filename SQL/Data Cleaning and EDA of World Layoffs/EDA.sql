-- Exploratory Data Analysis
SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Top 3 company with most laid offs
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;


-- Top 3 industry with most laid offs
SELECT *
FROM layoffs_staging2;

WITH Industry_Year AS (
  SELECT 
    industry, 
    YEAR(date) AS years, 
    SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  WHERE total_laid_off IS NOT NULL 
    AND date IS NOT NULL
    GROUP BY industry, YEAR(date)
), Ranked_Industry AS (
  SELECT 
    industry, 
    years, 
    total_laid_off, 
    DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS rank_per_year
  FROM Industry_Year
)
SELECT * 
FROM Ranked_Industry
WHERE rank_per_year <= 3 
ORDER BY years ASC;











