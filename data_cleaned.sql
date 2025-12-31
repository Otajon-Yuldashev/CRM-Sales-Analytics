CREATE TABLE accounts_cleaned (
       [account] VARCHAR(100)
      ,[sector] VARCHAR(100)
      ,[year_established] INT
      ,[revenue] DECIMAL(15,2)
      ,[employees] INT
      ,[office_location] VARCHAR(100)
      ,[subsidiary_of] VARCHAR(100)
)

CREATE TABLE products_cleaned (
       [product] VARCHAR(50)
      ,[series] VARCHAR(50)
      ,[sales_price] INT
)

CREATE TABLE sales_pipeline_cleaned (
       [opportunity_id] VARCHAR(50) PRIMARY KEY
      ,[sales_agent] VARCHAR(100)
      ,[product] VARCHAR(100)
      ,[account] VARCHAR(100)
      ,[deal_stage] VARCHAR(50)
      ,[engage_date] DATE
      ,[close_date] DATE
      ,[close_value] INT
)