-- Q1: Which 10 industries have the highest emissions per dollar spent?
SELECT naics_title, ef_with_margins
FROM emissions
ORDER BY ef_with_margins DESC
LIMIT 10;

-- Q2: Average emissions factor by sector
SELECT sector_code,
       COUNT(*) AS industries,
       ROUND(AVG(ef_with_margins), 3) AS avg_factor
FROM emissions
GROUP BY sector_code
ORDER BY avg_factor DESC;

-- Q3: Large sectors (10+ industries) that are above the overall average
SELECT sector_code,
       COUNT(*) AS industries,
       ROUND(AVG(ef_with_margins), 3) AS avg_factor
FROM emissions
GROUP BY sector_code
HAVING COUNT(*) >= 10
   AND AVG(ef_with_margins) > (SELECT AVG(ef_with_margins) FROM emissions)
ORDER BY avg_factor DESC;

-- Q4: Industries where margins are the biggest share of the total
SELECT naics_title, margins, ef_with_margins,
       ROUND(margins * 100.0 / ef_with_margins, 1) AS margin_pct
FROM emissions
WHERE ef_with_margins > 0
ORDER BY margin_pct DESC
LIMIT 10;

-- Q5: Industries more than 3x their sector average (CTE + join)
WITH sector_avg AS (
    SELECT sector_code, AVG(ef_with_margins) AS avg_factor
    FROM emissions
    GROUP BY sector_code
)
SELECT e.naics_title, e.sector_code, e.ef_with_margins,
       ROUND(s.avg_factor, 3) AS sector_avg,
       ROUND(e.ef_with_margins / s.avg_factor, 1) AS times_avg
FROM emissions e
JOIN sector_avg s ON e.sector_code = s.sector_code
WHERE e.ef_with_margins > 3 * s.avg_factor
ORDER BY times_avg DESC;

-- Q6: The highest-emitting industry in each sector (window function)
WITH ranked AS (
    SELECT sector_code, naics_title, ef_with_margins,
           ROW_NUMBER() OVER (
               PARTITION BY sector_code
               ORDER BY ef_with_margins DESC, naics_title
           ) AS rnk
    FROM emissions
)
SELECT sector_code, naics_title, ef_with_margins
FROM ranked
WHERE rnk = 1
ORDER BY ef_with_margins DESC;