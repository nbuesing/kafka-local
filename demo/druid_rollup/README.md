
* see `INSTALL.md` for setting up 

MacBook Pro (16-inch, 2019)
8-Core Intel Core i9
64GB Memory


# Compare Effectiveness of Datasources

##

Use `./druid_compare.sh` to load the datasets into Druid. 

Running Druid on a single machine running Docker does have resource limitations, the number of concurrent tasks could be an issue. 
Considering loading them one at a time; if you only have 32GB of memory or your processor is less than 8 cores.


## To see the rollup effectivensss for yourself, you can run this single query after the data has been populated.
```
SELECT 'orders'                           "Datasource",
       SUM("COUNT")                       "Logical Count",
       COUNT("COUNT")                     "Physical Count",
       SUM("COUNT")/(COUNT("COUNT")*1.0)  "Rollup Factor"
  FROM orders
 GROUP BY 1

UNION ALL

SELECT 'orders_user_reward'               "Datasource",
       SUM("COUNT")                       "Logical Count",
       COUNT("COUNT")                     "Physical Count",
       SUM("COUNT")/(COUNT("COUNT")*1.0)  "Rollup Factor"
  FROM orders_user_reward
 GROUP BY 1

UNION ALL

SELECT 'orders_store_zipcode'             "Datasource",
       SUM("COUNT")                       "Logical Count",
       COUNT("COUNT")                     "Physical Count",
       SUM("COUNT")/(COUNT("COUNT")*1.0)  "Rollup Factor"
  FROM orders_store_zipcode
 GROUP BY 1

UNION ALL

SELECT 'orders_user_reward_store_zipcode' "Datasource",
       SUM("COUNT")                       "Logical Count",
       COUNT("COUNT")                     "Physical Count",
       SUM("COUNT")/(COUNT("COUNT")*1.0)  "Rollup Factor"
  FROM orders_user_reward_store_zipcode
 GROUP BY 1
```

# 


```

SELECT __time, 
       USER_REWARD, 
       "COUNT" 
  FROM datasource
 WHERE __time >= CURRENT_TIMESTAMP - INTERVAL '3' MINUTE
   AND __time < CURRENT_TIMESTAMP - INTERVAL '2' MINUTE
   AND USER_REWARD = 'DIAMOND'

```






         select 'orders_sketch_none' "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 7) "Rollup Factor",
               count(distinct CODE) "UNIQUE CODES"
           from orders_sketch_none
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2
         union all
         select 'orders_sketch_theta_16'   "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
               APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
           from orders_sketch_theta_16
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2
         union all
         select 'orders_sketch_theta_32'   "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
               APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
           from orders_sketch_theta_32
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2
         union all
         select 'orders_sketch_theta_16384'   "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
               APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
           from orders_sketch_theta_16384
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2
         union all
         select 'orders_sketch_hll_4_4'   "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
               APPROX_COUNT_DISTINCT_DS_HLL(UNIQUE_CODES) UNIQUE_CODES
           from orders_sketch_hll_4_4
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2
         union all
         select 'orders_sketch_hll_4_12'   "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
               APPROX_COUNT_DISTINCT_DS_HLL(UNIQUE_CODES) UNIQUE_CODES
           from orders_sketch_hll_4_12
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2
         union all
         select 'orders_sketch_hll_8_12'   "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               SUM("COUNT") "COUNT",
               ROUND(SUM("COUNT")/(COUNT("COUNT")*1.0), 2) "Rollup Factor",
               APPROX_COUNT_DISTINCT_DS_HLL(UNIQUE_CODES) UNIQUE_CODES
           from orders_sketch_hll_8_12
         where __time >= TIMESTAMP '2021-12-19 18:00:00'
           and __time < TIMESTAMP '2021-12-19 19:00:00'
         group by 1,2







        select min(__time), max(__time) from orders_sketch_theta_32

        `where  __time < TIME_FLOOR(CURRENT_TIMESTAMP, 'PT1H') - INTERVAL '2' HOUR


         UNION ALL
         select 'orders_sketch_theta_32' "Datasource",
               TIME_FLOOR(__time, 'PT1H'),
               --__time,
               SUM("COUNT") "COUNT",
               APPROX_COUNT_DISTINCT_DS_THETA(UNIQUE_CODES) UNIQUE_CODES
         from orders_sketch_theta_32
         where  __time < TIME_FLOOR(CURRENT_TIMESTAMP, 'PT1H') - INTERVAL '1' HOUR
         group by 1,2


        where TIME_FLOOR(__time, 'PT1H') = TIMESTAMP '2021-12-12 16:00:00'

         < CURRENT_TIMESTAMP - INTERVAL '1' MINUTE


         SELECT 'orders' 			 "Datasource",
               SUM("COUNT") 			 "Logical Count",
               COUNT("COUNT") 			 "Physical Count",
               SUM("COUNT")/(COUNT("COUNT")*1.0) "Rollup Factor"
           FROM orders_user_reward
           GROUP BY 1
         UNION ALL
         SELECT 'orders_user_reward_topic_key_order_id' 			 "Datasource",
               SUM("COUNT") 			 "Logical Count",
               COUNT("COUNT") 			 "Physical Count",
               SUM("COUNT")/(COUNT("COUNT")*1.0) "Rollup Factor"
           FROM orders_user_reward_topic_key_order_id
           GROUP BY 1


         select __time, USER_REWARD, "COUNT"
           from orders_user_reward_topic_key_order_id
         where __time >= CURRENT_TIMESTAMP - INTERVAL '6' MINUTE
           and __time < CURRENT_TIMESTAMP - INTERVAL '5' MINUTE
           and USER_REWARD = 'DIAMOND'


         SELECT
           "COUNT",
           "QUANTITY",
         --  sum("COUNT") "COUNT",
         --  sum(QUANTITY) "QUANTITY",
           STORE_ZIPCODE,
           USER_REWARD,
           __time
         FROM orders --_user_reward_store_zipcode
         WHERE __time >= CURRENT_TIMESTAMP - INTERVAL '2' MINUTE and __time < CURRENT_TIMESTAMP - INTERVAL '1' MINUTE
         --group by 3,4,5
         --order by 5 desc, 4, 3




         select __time, USER_REWARD from orders_user_reward
         WHERE __time = TIMESTAMP '2021-12-18 17:12:00' and USER_REWARD = 'DIAMOND'


         select __time, USER_REWARD from orders_user_reward_topic_key_order_id
         WHERE __time = TIMESTAMP '2021-12-18 17:12:00' and USER_REWARD = 'DIAMOND'
