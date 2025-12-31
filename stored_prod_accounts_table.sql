CREATE PROCEDURE usp_LoadtoAcountsClean
AS
BEGIN
   INSERT INTO dbo.accounts_cleaned
   SELECT
      ISNULL(account, 'N/A'),
	  ISNULL(sector, 'N/A'),
	  TRY_CAST(year_established as INT),
	  TRY_CAST(revenue AS DECIMAL(15,2)),
      TRY_CAST(employees AS INT),
	  ISNULL(office_location, 'N/A'),
      ISNULL(subsidiary_of, 'N/A')
   FROM dbo.accounts_stg;

   PRINT 'Accounts data cleaned and transformed successfully!';
END;
      