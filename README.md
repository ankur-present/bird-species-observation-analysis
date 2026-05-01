#  Bird Species Observation Analysis

![Python](https://img.shields.io/badge/Python-3.x-blue)
![MySQL](https://img.shields.io/badge/MySQL-Database-orange)
![PowerBI](https://img.shields.io/badge/PowerBI-Dashboard-yellow)
![Status](https://img.shields.io/badge/Status-Completed-green)

## Project Overview
Analysis of bird species distribution and diversity across two distinct ecosystems — **forests** and **grasslands** — using real observational data from 11 national parks and historical sites in the United States.

The project covers the full data analytics pipeline: data loading → cleaning → EDA → SQL → Power BI dashboard.

---

## Business Use Cases
- **Wildlife Conservation** — Identify at-risk species and critical habitats
- **Eco-Tourism** — Pinpoint bird-rich areas for bird-watching tourism
- **Land Management** — Optimize habitat restoration strategies
- **Policy Support** — Data-driven insights for environmental agencies
- **Biodiversity Monitoring** — Track ecosystem health through avian populations

---

##  Dataset
- **Source:** Bird Monitoring Observational Data
- **Files:** `Bird_Monitoring_Data_FOREST.XLSX` + `Bird_Monitoring_Data_GRASSLAND.XLSX`
- **Sheets:** 11 per file (ANTI, CATO, CHOH, GWMP, HAFE, MANA, MONO, NACE, PRWI, ROCR, WOTR)
- **Final cleaned dataset:** 15,370 rows × 33 columns
- **Key columns:** Species name, Date, Habitat, Temperature, Humidity, ID Method, Conservation Status

---

## 🛠️ Tools & Technologies
| Tool | Purpose |
|---|---|
| Python (Pandas, Matplotlib, Seaborn) | Data loading, cleaning, EDA, visualization |
| MySQL | Data storage and analytical queries |
| Power BI | Interactive 3-page dashboard |
| Jupyter Lab | Development environment |

---

##  Project Workflow


### 1. Data Loading
- Used `pd.ExcelFile` to load all 11 sheets from both files in a single loop
- Added `Habitat` column (Forest/Grassland) to distinguish ecosystems
- Merged into one master DataFrame: `birds_df` (17,077 rows)

### 2. Data Cleaning
- Removed 1,705 duplicate rows
- Dropped 3 near-empty columns (>50% missing): `Sub_Unit_Code`, `TaxonCode`, `Previously_Obs`
- Filled categorical nulls with `"Unknown"` for `Sex`, `Distance`, `Site_Name`
- Fixed data types: `Year`, `Visit`, `Initial_Three_Min_Cnt` → numeric
- Extracted `Month`, `Month_Name`, `Season` from `Date` column
- Standardized text with `.str.title()` to prevent groupby mismatches
- **Final shape: 15,370 rows × 33 columns | Zero null values**

### 3. Exploratory Data Analysis (8 Sections)
- Species Diversity
- Temporal Analysis
- Environmental Conditions
- Behavior & Identification
- Conservation Status
- Spatial / Admin Unit Analysis
- Observer Trends
- Activity Heatmap

### 4. SQL Analysis
- Pushed cleaned data to MySQL (`birds_project` database)
- Wrote 46 analytical queries across 8 sections

### 5. Power BI Dashboard (3 Pages)
- **Page 1:** Executive Summary — KPIs, habitat split, top species, admin unit breakdown
- **Page 2:** Species & Conservation — habitat overlap, watchlist species, stewardship flags
- **Page 3:** Temporal & Environmental — monthly trends, heatmap, weather analysis

---

## 📊 Key Findings

| Finding | Insight |
|---|---|
| 127 unique species observed | High biodiversity across both habitats |
| Forest (108) vs Grassland (107) species | Nearly identical species richness |
| 88 species shared across habitats | 69% overlap between ecosystems |
| Northern Cardinal | Most observed species (1,125 observations) |
| June = peak month | 6,209 observations — peak breeding season |
| Singing = 63% of ID methods | Birds heard more than seen |
| Grassland warmer (23.27°C vs 21.87°C) | Environmental difference confirmed |
| Wood Thrush = most at-risk observed | Top PIF Watchlist species |
| ANTI admin unit = highest activity | Prime eco-tourism candidate |

---

##  Conservation Insights
- **378 observations** involved PIF Watchlist species (at-risk)
- **4,000+ observations** involved Regional Stewardship priority species
- Top at-risk species: Wood Thrush, Worm-Eating Warbler, Prairie Warbler
- Several species appear on BOTH watchlist AND stewardship priority list

---

##  EDA Visualizations
| Plot | Description |
|---|---|
| `eda_01_species_diversity.png` | Top 10 species + habitat overlap pie |
| `eda_02_temporal.png` | Observations by year, month, season |
| `eda_03_environment.png` | Temperature boxplot, sky conditions, disturbance |
| `eda_04_behavior.png` | ID method, sex ratio, flyover, distance |
| `eda_05_conservation.png` | Watchlist species, conservation flags |
| `eda_06_spatial.png` | Observations and species by admin unit |
| `eda_07_observers.png` | Top observers by count and diversity |
| `eda_08_heatmap.png` | Admin unit × month activity heatmap |

---

## 📁 Repository Structure
