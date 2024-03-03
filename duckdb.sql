.mode duckbox
.maxrows 500
SELECT * FROM PARQUET_FILE_METADATA('/home/gmanche/data/testId=*/*.parquet');
SELECT * FROM PARQUET_METADATA('/home/gmanche/data/testId=*/*.parquet');
SELECT * FROM PARQUET_SCHEMA('/home/gmanche/data/testId=*/*.parquet');
SELECT * FROM READ_PARQUET('/home/gmanche/data/testId=*/*.parquet');
