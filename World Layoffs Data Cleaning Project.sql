-- SQL Project - Data Cleaning --
SELECT * 
FROM layoffs;

-- Create work table -- 
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;

-- Searching Duplicates --

WITH duplicate_cte AS
 (
 SELECT *,
ROW_NUMBER () OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging 
 )
 SELECT * 
 from duplicate_CTE
 WHERE 
	row_num > 1;

-- Creating layoffs_staging2 --

CREATE TABLE `layoffs_staging2` (
`company` text,
`location`text,
`industry`text,
`total_laid_off` INT,
`percentage_laid_off` text,
`date` text,
`stage`text,
`country` text,
`funds_raised_millions` int,
row_numlayoffs_staging2 INT
);

Select * 
from layoffs_staging2;

Insert into layoffs_staging2
Select *,
ROW_NUMBER () OVER( 
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

-- deleteing duplicates --
DELETE
FROM layoffs_staging2
WHERE row_num >= 2;

SELECT *
FROM layoffs_staging2
WHERE row_num >= 2;

-- Standardizing data --

SELECT *
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

SELECT distinct industry
FROM layoffs_staging2
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'Bally%';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE company LIKE 'airbnb%';

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY country;

update layoffs_staging2
set country = Trim(trailing '.'from country)
where country Like 'United States%';

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM world_layoffs.layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT count(company)
FROM world_layoffs.layoffs_staging2;


