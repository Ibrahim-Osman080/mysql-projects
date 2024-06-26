-- EDA (Exploratory Data Analysis)

-- Here we're diving in to explore the data and see what interesting stuff we can find! 
-- We're looking for trends, patterns, or even outliers.

-- Normally, EDA starts with a specific goal in mind. 
-- This time, we're just gonna play around and see what emerges!


Select * 
FROM layoffs_staging2;
 
Select MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;
 
 Select company, SUM(total_laid_off)
 FROM layoffs_staging2
 WHERE percentage_laid_off = 1
 GROUP BY company
 ORDER BY 2 DESC;
 
 Select MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


 Select country, SUM(total_laid_off)
 FROM layoffs_staging2
 WHERE percentage_laid_off = 1
 GROUP BY country
 ORDER BY 2 DESC;
 
 
 Select * 
FROM layoffs_staging2;


 Select YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging2
 WHERE percentage_laid_off = 1
 GROUP BY YEAR(`date`)
 ORDER BY 1 DESC;
 
 
Select stage, SUM(total_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off = 1
GROUP BY stage
ORDER BY 1 DESC;



Select company, SUM(percentage_laid_off)
FROM layoffs_staging2
WHERE percentage_laid_off = 1
GROUP BY company
ORDER BY 2 DESC;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC;


WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

 Select company, SUM(total_laid_off)
 FROM layoffs_staging2
 GROUP BY company
 ORDER BY 2 DESC;
 
  Select company, YEAR(`date`), SUM(total_laid_off)
 FROM layoffs_staging2
  GROUP BY company, YEAR(`date`)
  ORDER BY 3 DESC ;
  
  
  
  
  
WITH Company_Year (company, years, total_laid_off) AS 
(
Select company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
 DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;