-- -- Run on the warehouse ONCE
-- /* Create [aggregate table], [cursor], [buffer] */
-- create or replace table orders_aggregated (date1 date, value1 int)
--     cluster by (date1)
-- ;
-- create or replace table cursor as
--     select null as value
-- ;
begin;

set cursor = (100);

set buffer = -30;

set current_date = current_date();

/* [INCREMENTAL] - remove records in buffer period */
delete from salesforce.order
    where IFF($cursor is null, true, date1 >= dateadd(day, $buffer, $cursor))
;

/* [INCREMENTAL] - insert incremental aggregate */
insert into salesforce.order
    select 
        to_date(date1), 
        sum(value1)
    from salesforce.order
    where IFF($cursor is null, true, date1 >= dateadd(day, $buffer, $cursor))
    group by 1
;

/* [INCREMENTAL] - set cursor */
create or replace table cursor as 
    select $current_date as value
;

/* END TRANSACTION*/
commit;