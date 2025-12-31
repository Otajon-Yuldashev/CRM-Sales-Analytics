CREATE PROCEDURE usp_LoadtoSalesPipelineCleaned
AS
BEGIN
  INSERT INTO dbo.sales_pipeline_cleaned
  SELECT
     ISNULL(opportunity_id, 'N/A'),
	 ISNULL(sales_agent, 'N/A'),
     ISNULL(product, 'N/A'),
     ISNULL(account, 'N/A'),
     ISNULL(deal_stage, 'N/A'),
	 TRY_CAST(engage_date as DATE),
	 TRY_CAST(close_date as DATE),
	 TRY_CAST(close_value as INT)
  FROM dbo.sales_pipeline_stg;

  PRINT 'Sales Pipeline data cleaned and transformed successfully!';

END;


