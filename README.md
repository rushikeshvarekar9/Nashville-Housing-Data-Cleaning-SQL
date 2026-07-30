# Nashville-Housing-Data-Cleaning-SQL
SQL data cleaning for Nashville housing dataset.

🏠 Nashville Housing Data Cleaning (SQL Project)
Welcome to my SQL Data Cleaning Project! In this project, I took a raw dataset containing Nashville housing market data and performed end-to-end data cleaning using MySQL Workbench.

As a fresher/aspiring Data Analyst, my goal here was to practice real-world data transformation, handling missing values, removing duplicates, and structuring unorganized data so it is ready for analysis or visualization.

📌 Project Overview & Objectives
Raw data often contains inconsistencies, missing records, bad data types, and duplicate entries. This project focuses on converting messy housing data into a clean, standardized format.

Key tasks completed:

Creating Staging Tables to preserve original raw data safely.

Removing Duplicate Records using CTEs and window functions (ROW_NUMBER()).

Standardizing Date Formats using STR_TO_DATE.

Populating Missing Data using self-joins (COALESCE).

Splitting Delimited Column Values into separate Street, City, and State columns using string functions.

Standardizing Categorical Data (converting 'Y'/'N' to 'Yes'/'No').

Dropping Redundant/Unused Columns after extraction to optimize table structure.

🛠️ Tools & Skills Used
Database Engine: MySQL / MySQL Workbench

SQL Concepts:

CREATE TABLE ... LIKE, INSERT INTO

CTEs (Common Table Expressions) & Window Functions (ROW_NUMBER() OVER(PARTITION BY...))

Data Transformation Functions (STR_TO_DATE, SUBSTRING_INDEX, COALESCE, NULLIF)

Control Flow (CASE WHEN)

Table Alteration (ALTER TABLE, ADD COLUMN, DROP COLUMN)

Table Joins (SELF JOIN)
