
* see `INSTALL.md` for setting up 

# Compare Effectiveness of Datasources

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