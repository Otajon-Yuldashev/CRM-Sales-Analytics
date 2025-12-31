
CREATE TABLE accounts_stg (
    [account] VARCHAR(100),
    [sector] VARCHAR(100),
    [year_established] VARCHAR(100),
    [revenue] VARCHAR(100),
    [employees] VARCHAR(100),
    [office_location] VARCHAR(100),
    [subsidiary_of] VARCHAR(100)
);

CREATE TABLE data_dictionary_stg (
    [TableName] VARCHAR(100),
    [Field] VARCHAR(100),
    [Description] VARCHAR(500)
);

-- 3. products_stg
CREATE TABLE products_stg (
    [product] VARCHAR(100),
    [series] VARCHAR(100),
    [sales_price] VARCHAR(100)
);

CREATE TABLE sales_pipeline_stg (
    [opportunity_id] VARCHAR(100),
    [sales_agent] VARCHAR(100),
    [product] VARCHAR(100),
    [account] VARCHAR(100),
    [deal_stage] VARCHAR(100),
    [engage_date] VARCHAR(100),
    [close_date] VARCHAR(100),
    [close_value] VARCHAR(100)
);

CREATE TABLE sales_teams_stg (
    [sales_agent] VARCHAR(100),
    [manager] VARCHAR(100),
    [regional_office] VARCHAR(100)
);