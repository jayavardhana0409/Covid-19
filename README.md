# COVID-19 Data Analysis Queries

This repository contains SQL queries for analyzing COVID-19 data using two tables: `CovidDeaths` and `CovidVaccinations`. The queries cover a range of tasks, including counting rows, calculating percentages, and creating views.

## Queries

### 1. Count the number of rows

- Query 1: Count the number of rows in the CovidDeaths table
- Query 2: Count the number of rows in the CovidVaccinations table

### 2. Retrieve and filter data

- Query 3: Retrieve specific columns from CovidDeaths where continent is not null, ordered by location and date
- Query 6: Calculate percentage of population infected in each country for a specific location and date

### 3. Calculate percentages

- Query 4: Calculate death percentage in each country based on total deaths and total cases
- Query 5: Calculate infection rate in each country based on new cases and total cases
- Query 9: Calculate the overall death percentage worldwide
- Query 10: Calculate death percentage globally for each date

### 4. Vaccination Analysis

- Query 11: Calculate the percentage of people vaccinated in each country
- Query 14: Create a view to calculate the percentage of people vaccinated in each country

### 5. Views and Temporary Tables

- Query 15: Create a view to calculate rolling people vaccinated in each country
- Query 16: Calculate the percentage of people vaccinated using a temporary table
- Query 17: Create a view to calculate the percentage of people vaccinated using a view

### 6. Data Display

- Query 12: Display top 1000 rows from CovidVaccinations
- Query 13: Display top 1000 rows from CovidDeaths

## Views and Temporary Tables

- View: `percentage_people_vaccinated`
  - Calculates the percentage of people vaccinated in each country
- View: `RollingPeopleVaccinated`
  - Calculates rolling people vaccinated in each country


