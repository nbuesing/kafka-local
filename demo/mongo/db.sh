#!/bin/sh

DIR=$(dirname $0)
cd $DIR

cp -r data/* ../../mysql/data

cat > ../../mysql/data/load.sql <<EOF
LOAD DATA LOCAL INFILE '/data/stores.csv' INTO TABLE stores FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/data/users.csv' INTO TABLE users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE '/data/orders.csv' INTO TABLE orders FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;
EOF
docker exec -it mysql sh -c "cat /data/load.sql | mysql --user=user --password=userpw MAIN"
