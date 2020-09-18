INSERT INTO `fivetran-dts-demo.sql_server_dbo._customer_history`
  SELECT *
  FROM `fivetran-dts-demo.sql_server_dbo.customers`
  WHERE NOT EXISTS (
    SELECT * 
    FROM `fivetran-dts-demo.sql_server_dbo._customer_history`
    WHERE `fivetran-dts-demo.sql_server_dbo._customer_history`.customer_id = `fivetran-dts-demo.sql_server_dbo.customers`.customer_id)