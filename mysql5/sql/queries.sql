SELECT SUM(LO_EXTENDEDPRICE*LO_DISCOUNT) AS REVENUE
FROM SSB.LINEORDER, SSB.DWDATE
WHERE LO_ORDERDATE = D_DATEKEY
  AND D_YEARMONTHNUM = 199401
  AND LO_DISCOUNT BETWEEN 4 AND 6
  AND LO_QUANTITY BETWEEN 26 AND 35;

SELECT SUM(LO_EXTENDEDPRICE*LO_DISCOUNT) AS REVENUE
FROM SSB.LINEORDER, SSB.DWDATE
WHERE LO_ORDERDATE = D_DATEKEY
  AND D_YEAR = 1993
  AND LO_DISCOUNT BETWEEN 1 AND 3
  AND LO_QUANTITY < 25;

SELECT SUM(LO_EXTENDEDPRICE*LO_DISCOUNT) AS REVENUE
FROM SSB.LINEORDER, SSB.DWDATE
WHERE LO_ORDERDATE = D_DATEKEY
  AND D_YEARMONTHNUM = 199401
  AND LO_DISCOUNT BETWEEN 4 AND 6
  AND LO_QUANTITY BETWEEN 26 AND 35;

SELECT SUM(LO_EXTENDEDPRICE*LO_DISCOUNT) AS REVENUE
FROM SSB.LINEORDER, SSB.DWDATE
WHERE LO_ORDERDATE = D_DATEKEY
  AND D_WEEKNUMINYEAR = 6
  AND D_YEAR = 1994
  AND LO_DISCOUNT BETWEEN 5 AND 7
  AND LO_QUANTITY BETWEEN 26 AND 35;

SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND1
FROM SSB.LINEORDER, SSB.DWDATE, SSB.PART, SSB.SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
  AND LO_PARTKEY = P_PARTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND P_CATEGORY = 'MFGR#12'
  AND S_REGION = 'AMERICA'
GROUP BY D_YEAR, P_BRAND1
ORDER BY D_YEAR, P_BRAND1;

SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND1
FROM SSB.LINEORDER, SSB.DWDATE, SSB.PART, SSB.SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
  AND LO_PARTKEY = P_PARTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND P_BRAND1 BETWEEN 'MFGR#2221' AND 'MFGR#2228'
  AND S_REGION = 'ASIA'
GROUP BY D_YEAR, P_BRAND1
ORDER BY D_YEAR, P_BRAND1;

SELECT SUM(LO_REVENUE), D_YEAR, P_BRAND1
FROM SSB.LINEORDER, SSB.DWDATE, SSB.PART, SSB.SUPPLIER
WHERE LO_ORDERDATE = D_DATEKEY
  AND LO_PARTKEY = P_PARTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND P_BRAND1 = 'MFGR#2221'
  AND S_REGION = 'EUROPE'
GROUP BY D_YEAR, P_BRAND1
ORDER BY D_YEAR, P_BRAND1;

SELECT C_NATION, S_NATION, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM SSB.CUSTOMER, SSB.LINEORDER, SSB.SUPPLIER, SSB.DWDATE
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND C_REGION = 'ASIA' AND S_REGION = 'ASIA'
  AND D_YEAR >= 1992 AND D_YEAR <= 1997
GROUP BY C_NATION, S_NATION, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;

SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM SSB.CUSTOMER, SSB.LINEORDER, SSB.SUPPLIER, SSB.DWDATE
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND C_NATION = 'UNITED STATES'
  AND S_NATION = 'UNITED STATES'
  AND D_YEAR >= 1992 AND D_YEAR <= 1997
GROUP BY C_CITY, S_CITY, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;

SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM SSB.CUSTOMER, SSB.LINEORDER, SSB.SUPPLIER, SSB.DWDATE
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND (C_CITY='UNITED KI1' OR C_CITY='UNITED KI5')
  AND (S_CITY='UNITED KI1' OR S_CITY='UNITED KI5')
  AND D_YEAR >= 1992 AND D_YEAR <= 1997
GROUP BY C_CITY, S_CITY, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;

SELECT C_CITY, S_CITY, D_YEAR, SUM(LO_REVENUE) AS REVENUE
FROM SSB.CUSTOMER, SSB.LINEORDER, SSB.SUPPLIER, SSB.DWDATE
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND (C_CITY='UNITED KI1' OR C_CITY='UNITED KI5')
  AND (S_CITY='UNITED KI1' OR S_CITY='UNITED KI5')
  AND D_YEARMONTH = 'DEC1997'
GROUP BY C_CITY, S_CITY, D_YEAR
ORDER BY D_YEAR ASC, REVENUE DESC;

SELECT D_YEAR, C_NATION, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
FROM SSB.DWDATE, SSB.CUSTOMER, SSB.SUPPLIER, SSB.PART, SSB.LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_PARTKEY = P_PARTKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND C_REGION = 'AMERICA'
  AND S_REGION = 'AMERICA'
  AND (P_MFGR = 'MFGR#1' OR P_MFGR = 'MFGR#2')
GROUP BY D_YEAR, C_NATION
ORDER BY D_YEAR, C_NATION;

SELECT D_YEAR, S_NATION, P_CATEGORY, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
FROM SSB.DWDATE, SSB.CUSTOMER, SSB.SUPPLIER, SSB.PART, SSB.LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_PARTKEY = P_PARTKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND C_REGION = 'AMERICA'
  AND S_REGION = 'AMERICA'
  AND (D_YEAR = 1997 OR D_YEAR = 1998)
  AND (P_MFGR = 'MFGR#1'
    OR P_MFGR = 'MFGR#2')
GROUP BY D_YEAR, S_NATION, P_CATEGORY ORDER BY D_YEAR, S_NATION, P_CATEGORY;

SELECT D_YEAR, S_CITY, P_BRAND1, SUM(LO_REVENUE - LO_SUPPLYCOST) AS PROFIT
FROM SSB.DWDATE, SSB.CUSTOMER, SSB.SUPPLIER, SSB.PART, SSB.LINEORDER
WHERE LO_CUSTKEY = C_CUSTKEY
  AND LO_SUPPKEY = S_SUPPKEY
  AND LO_PARTKEY = P_PARTKEY
  AND LO_ORDERDATE = D_DATEKEY
  AND C_REGION = 'AMERICA'
  AND S_NATION = 'UNITED STATES'
  AND (D_YEAR = 1997 OR D_YEAR = 1998)
  AND P_CATEGORY = 'MFGR#14'
GROUP BY D_YEAR, S_CITY, P_BRAND1 ORDER BY D_YEAR, S_CITY, P_BRAND1;