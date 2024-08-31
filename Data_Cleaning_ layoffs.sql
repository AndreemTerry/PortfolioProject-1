-- DATA CLEANING -- 
-- world layoffs --

SELECT * 
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank values
-- 4. Remove Unnecessary Columns or Rows



-- 1. Remove Duplicates

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

WITH duplicate_cte AS
(
SELECT * 
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, `date`, 
stage, country, funds_raised_ millions) AS row_num
FROM layoffs_staging;
)
SELECT * 
FROM duplicate_cte
WHERE row_num >1;

-- Checking if I find duplicates with one company
SELECT * 
FROM layoffs_staging
WHERE company = 'Ada';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num >1;

SELECT * 
FROM layoffs_staging2;

-- 2. Standardize the Data
-- updating errors in countires

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States';

SELECT DISTINCT country
FROM layoffs_staging2;

-- changing date data from text type to date type as well as format

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y')

-- searching for nulls. (none found)
SElect `date`, country
from layoffs_staging2
where `date` is null;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Null Values or Blank values

SELECT * 
from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT DISTINCT industry 
from layoffs_staging2
WHERE industry IS NULL 
OR industry = ' ';

-- checking to fill in blanks from other company names.(where possible)
SELECT * 
from layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = ' ')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = ' ';


-- 4. Remove Unnecessary Columns where data is not significant


 SELECT * 
from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;


 SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


-- COMPLETE. 
