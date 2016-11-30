SELECT DB_NAME(db_id()) as dbname,MAX(modify_date) as Modified
FROM sys.all_objects
