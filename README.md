# CRM-Sales-Analytics 📊

An end-to-end data engineering pipeline on Microsoft Azure processing B2B CRM sales data across 4 source datasets. Raw CSVs are ingested into Blob Storage, staged and cleaned in Azure SQL Server via stored procedures, orchestrated with Azure Data Factory, and visualised in a Power BI dashboard — built as a data engineering portfolio project.

---

## Architecture Overview

```
Raw CSV Files (4 datasets)
→ Azure Blob Storage (raw layer)
→ Azure Data Factory (pipeline orchestration + triggers)
→ Azure SQL Server — Staging Tables (accounts_stg, products_stg, sales_pipeline_stg, sales_teams_stg, data_dictionary_stg)
→ Azure SQL Server — Stored Procedures (type casting, null handling, cleaning)
→ Azure SQL Server — Cleaned Tables (accounts_cleaned, products_cleaned, sales_pipeline_cleaned)
→ Power BI Dashboard (revenue, win rate, agent performance, sector breakdown)
```

Medallion architecture concepts applied:
- **Bronze** — raw CSVs landed in Blob Storage as-is
- **Silver** — staging tables in Azure SQL (all VARCHAR, no transformations yet)
- **Gold** — cleaned tables with proper types, null handling, and constraints via stored procedures

---

## Tech Stack

| Layer | Technology |
|---|---|
| Cloud Platform | Microsoft Azure |
| Data Storage | Azure Blob Storage |
| Pipeline Orchestration | Azure Data Factory |
| Database | Azure SQL Server |
| Query & Transformation | T-SQL (SSMS) |
| Monitoring & Alerts | Azure Data Factory Monitor + Email Notifications |
| Visualisation | Power BI |

---

## Dataset Overview

Four source CSV files processed by the pipeline:

| Dataset | Key Fields |
|---|---|
| `accounts` | account, sector, year_established, revenue, employees, office_location, subsidiary_of |
| `products` | product, series, sales_price |
| `sales_pipeline` | opportunity_id, sales_agent, product, account, deal_stage, engage_date, close_date, close_value |
| `sales_teams` | sales_agent, manager, regional_office |
| `data_dictionary` | TableName, Field, Description |

**Sales pipeline deal stages:** Prospecting → Engaging → Won / Lost

---

## Repository Structure

```
CRM-Sales-Analytics/
├── sql/
│   ├── staging_tables.sql          # Bronze → Silver: raw staging table definitions
│   ├── data_cleaned.sql            # Silver → Gold: cleaned table definitions
│   └── stored_procedures/
│       ├── usp_LoadtoAccountsClean.sql        # Cleans accounts staging data
│       ├── usp_LoadtoProductsClean.sql        # Cleans products staging data
│       └── usp_LoadtoSalesPipelineCleaned.sql # Cleans sales pipeline staging data
├── dashboard/
│   └── CRM_Sales_Report.png        # Power BI dashboard screenshot
└── README.md
```

---

## Azure Infrastructure

**Services used:** Azure Blob Storage · Azure SQL Server · Azure Data Factory · Power BI

**Blob Storage**  
Raw CSVs uploaded to a Blob Storage container as the landing (Bronze) layer before ADF picks them up.

**Azure SQL Server**  
Two layers of tables:
- Staging tables — all fields as `VARCHAR(100)`, no transformation, exact mirror of source
- Cleaned tables — proper types (`INT`, `DECIMAL`, `DATE`), primary keys, null handling

**Azure Data Factory**  
Pipelines configured to copy data from Blob Storage into staging tables, trigger stored procedures for cleaning, and monitor pipeline runs with email alerts on failure.

---

## SQL Transformation Logic

### Staging → Cleaned (Stored Procedures)

Three stored procedures handle the Silver → Gold transformation:

**`usp_LoadtoAccountsClean`**  
Inserts from `accounts_stg` into `accounts_cleaned` — casts `year_established` to `INT`, `revenue` to `DECIMAL(15,2)`, `employees` to `INT`, fills nulls with `'N/A'`.

**`usp_LoadtoProductsClean`**  
Inserts from `products_stg` into `products_cleaned` — casts `sales_price` to `INT`, fills nulls with `'N/A'`.

**`usp_LoadtoSalesPipelineCleaned`**  
Inserts from `sales_pipeline_stg` into `sales_pipeline_cleaned` — casts `engage_date` and `close_date` to `DATE`, `close_value` to `INT`, fills nulls with `'N/A'`. `opportunity_id` is the PRIMARY KEY.

All casts use `TRY_CAST` to prevent pipeline failures on malformed data.

**Execution order:**
```sql
EXEC usp_LoadtoAcountsClean;
EXEC usp_LoadtoProductsClean;
EXEC usp_LoadtoSalesPipelineCleaned;
```

---

## Power BI Dashboard

![CRM Sales Report](dashboard/CRM_Sales_Report.png)

**Key metrics:**
- Total close value count: **6,711K**
- Close value by won deals: **4,238K**
- Win rate: **63%**

**Visuals included:**
- Revenue by account (top: Kan-code 12K, Hottechi 8K, Konex 8K)
- Close value trend by month (March–December)
- Close value by agent and deal stage (Won vs Lost)
- Opportunity count by product (GTX Basic, MG Special, GTXPro, MG Advanced, GTX Plus Basic, GTX Plus Pro, GTK 500)
- Revenue by office (global map)
- Revenue by sector (software 25.9%, technology 23.24%, retail 22.88%, medical 14.2%, telecommunications 13.77%)

---

## Data Dictionary

| Table | Field | Description |
|---|---|---|
| accounts | account | Company name |
| accounts | sector | Industry |
| accounts | year_established | Year established |
| accounts | revenue | Annual revenue (millions USD) |
| accounts | employees | Number of employees |
| accounts | office_location | Headquarters |
| accounts | subsidiary_of | Parent company |
| products | product | Product name |
| products | series | Product series |
| products | sales_price | Suggested retail price |
| sales_teams | sales_agent | Sales agent |
| sales_teams | manager | Respective sales manager |
| sales_teams | regional_office | Regional office |
| sales_pipeline | opportunity_id | Unique identifier |
| sales_pipeline | sales_agent | Sales agent |
| sales_pipeline | product | Product name |
| sales_pipeline | account | Company name |
| sales_pipeline | deal_stage | Pipeline stage (Prospecting → Engaging → Won / Lost) |
| sales_pipeline | engage_date | Date the Engaging stage was initiated |
| sales_pipeline | close_date | Date the deal was Won or Lost |
| sales_pipeline | close_value | Revenue from the deal |

---

## Local Development

Requires access to an Azure SQL Server instance and Azure Blob Storage container.

1. Upload source CSVs to your Blob Storage container
2. Run `staging_tables.sql` to create the staging layer
3. Run `data_cleaned.sql` to create the cleaned layer
4. Configure ADF pipelines to copy from Blob → staging tables
5. Execute stored procedures to populate cleaned tables:

```sql
EXEC usp_LoadtoAcountsClean;
EXEC usp_LoadtoProductsClean;
EXEC usp_LoadtoSalesPipelineCleaned;
```

6. Connect Power BI to Azure SQL Server and load cleaned tables for dashboarding
