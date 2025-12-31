CREATE PROCEDURE usp_LoadtoProductsClean
AS
BEGIN
  INSERT INTO dbo.products_cleaned
  SELECT
     ISNULL(product, 'N/A'),
	 ISNULL(series, 'N/A'),
	 TRY_CAST(sales_price as INT)
  FROM dbo.products_stg;

  PRINT 'Products data cleaned and transformed successfully!';
END;
