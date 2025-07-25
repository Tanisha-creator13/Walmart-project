# Walmart Sales Data Analysis

## Project Overview

Analyze Walmart sales data with an end-to-end solution using **Python** and **MySQL**. Extract critical business insights through data cleaning, transformation, feature engineering, and advanced SQL queries.

## Pipeline

1. **Set Up Environment**
   - Tools: Python, MySQL, VS Code.
   - Install dependencies:
     ```
     pip install pandas numpy sqlalchemy mysql-connector-python
     ```

2. **Data Acquisition**
   - Download the dataset from Kaggle and place it in the `data/` folder.
   - Dataset link : https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets

3. **Data Preparation**
   - Clean and preprocess data with pandas:
     - Remove duplicates/missing values.
     - Correct data types.
     - Engineer new features (e.g., total sales amount).

4. **Database Load**
   - Use SQLAlchemy to load cleaned data into MySQL.
   - Example:
     ```
     from sqlalchemy import create_engine
     engine = create_engine('mysql+mysqlconnector://username:password@localhost/walmart_db')
     df.to_sql('walmart', con=engine, if_exists='replace', index=False)
     ```

5. **SQL Analysis**
   - Perform advanced SQL queries to answer business questions.
   - **Sample: Revenue by Branch/Year**
     ```
     SELECT branch, SUM(total) AS revenue, YEAR(STR_TO_DATE(date, '%d/%m/%y')) AS year
     FROM walmart
     WHERE YEAR(STR_TO_DATE(date, '%d/%m/%y')) IN (2022, 2023)
     GROUP BY branch, year;
     ```

6. **Documentation and Results**
   - Summary of findings (sales drivers, profit patterns, customer trends).
   - All code and notebooks are included for reproducibility.

## Requirements

- Python 3.8+
- MySQL
- Python packages: `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`
- Kaggle API Key

## Project Structure
|-- data/
|-- sql-queries/
|-- notebooks/
|-- README.md
|-- requirements.txt
|-- main.py

## Tip
- To view and interact with the dashboards, open the .pbix file in Power BI Desktop.