#!/bin/sh

cd $(dirname $0)/tmp

#
# Build latest OpenSky From GitHub
#

if [ ! -d kafka-connect-opensky ]; then

  git clone https://github.com/nbuesing/kafka-connect-opensky.git

fi

(cd kafka-connect-opensky; git pull; ./gradlew --no-daemon build --warning-mode all)

(cd ../../../connect/jars; tar xfv ../../demo/opensky/tmp/kafka-connect-opensky/build/distributions/kafka-connect-opensky.tar)

#
# create the secrets file for opensky.properties
#

if [ ! -f ../../../connect/secrets/opensky.properties ]; then

cat <<EOF > ../../../connect/secrets/opensky.properties
USERNAME=
PASSWORD=
EOF

fi

#
# Ksql User Defined Functions - Geo
#

if [ ! -d ksqldb-udf-geospatial ]; then
  git clone https://github.com/nbuesing/ksqldb-udf-geospatial.git
fi

(cd ksqldb-udf-geospatial; git pull; ./gradlew --no-daemon build --warning-mode all)

cp ./ksqldb-udf-geospatial/build/libs/ksqldb-udf-geospatial-1.0.0-all.jar ../../../ksqldb/ext
