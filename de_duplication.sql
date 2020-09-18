create or replace table transforms.enrichment_accounts_deduped as
with accounts_with_duplicates as (
  select
    *,
    /*
    same salesforce account id (enrich_account_c) is linked to multiple records 
    create a ranking methodology of which records should be kept
    */
    row_number() over (partition by id order by created_date desc) as duplicate_rank
  from salesforce.account
  where not is_deleted
)
select
  *
from accounts_with_duplicates
where duplicate_rank = 1 
  or active_c is null