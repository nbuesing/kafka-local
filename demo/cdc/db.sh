#!/bin/bash

cd $(dirname $0)

cat > ../../mysql/data/orders.sql <<EOF
drop table if exists \`orders\`;

create table \`orders\` (
    \`order_id\` varchar(256) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    \`address_city\` text NULL,
    \`address_state\` text NULL,
    \`address_zipcode\` integer NULL,

    primary key (\`order_id\`)
);

drop table if exists \`BACKUP\`.\`orders\`;

create table \`BACKUP\`.\`orders\` (
    \`order_id\` varchar(256) NOT NULL,
    \`store_id\` varchar(10) NOT NULL,
    \`user_id\` varchar(10) NOT NULL,
    \`quantity\` integer NULL,
    \`address_city\` text NULL,
    \`address_state\` text NULL,
    \`address_zipcode\` integer NULL,

    primary key (\`order_id\`)
);


EOF
docker exec -it mysql sh -c "cat /data/orders.sql | mysql --user=user --password=userpw MAIN"
