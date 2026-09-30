# Industry Emissions Analysis with SQL

I used SQL (SQLite, run from Python) to explore which US industries produce the most greenhouse gas emissions per dollar spent.

## Dataset
Supply Chain GHG Emission Factors (NAICS, kg CO2e per 2022 USD), 1,016 industries.
Source: [paste the link where you downloaded it]

## Question
Which industries and sectors have the highest emissions per dollar, and where do trade and transport margins matter most?

## Key findings
- Cement manufacturing is the highest emitter at 3.92 kg CO2e per dollar, about 7.4x the average for its sector.
- Agriculture (sector 11) has the highest sector average at 0.73, driven by cattle industries at 2.89.
- Among sectors with 10 or more industries, six are above the overall average: agriculture, pipeline transportation, chemicals and minerals manufacturing, mining, food manufacturing, and waste services.
- In low-emission industries like software publishing, margins make up over 50% of the total factor.

## A query I'm proud of
Finds the highest-emitting industry in each sector using a window function:

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
    WHERE rnk = 1;

## Limitations
- The data is a single snapshot with no dates, so there are no trends over time.
- Related industries share identical values, so ties are common.
- Sector codes use the first two NAICS digits, which splits manufacturing across codes 31, 32 and 33.

## How to run
1. `pip3 install pandas`
2. `python3 load_data.py`
3. `python3 run_queries.py`