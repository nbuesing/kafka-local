#!/bin/sh
set -e
gradle assemble > /dev/null

export CP=""
export CP="${CP}:/Users/buesing/workspaces/nbuesing/kafka-local/demo/druid_late/publisher/build/classes/java/main"
export CP="${CP}:/Users/buesing/workspaces/nbuesing/kafka-local/demo/druid_late/publisher/build/resources/main"
export CP="${CP}:/Users/buesing/.m2/repository/ch/qos/logback/logback-classic/1.2.10/logback-classic-1.2.10.jar"
export CP="${CP}:/Users/buesing/.m2/repository/com/beust/jcommander/1.78/jcommander-1.78.jar"
export CP="${CP}:/Users/buesing/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.12.3/jackson-datatype-jsr310-2.12.3.jar"
export CP="${CP}:/Users/buesing/.m2/repository/com/fasterxml/jackson/core/jackson-databind/2.12.3/jackson-databind-2.12.3.jar"
export CP="${CP}:/Users/buesing/.m2/repository/com/fasterxml/jackson/core/jackson-core/2.12.3/jackson-core-2.12.3.jar"
export CP="${CP}:/Users/buesing/.m2/repository/org/apache/commons/commons-lang3/3.12.0/commons-lang3-3.12.0.jar"
export CP="${CP}:/Users/buesing/.gradle/caches/modules-2/files-2.1/org.apache.kafka/kafka-clients/3.1.0/af924560e38c0a6dbf270bc2d361b2dfab0e03ec/kafka-clients-3.1.0.jar"
export CP="${CP}:/Users/buesing/.m2/repository/org/slf4j/slf4j-api/1.7.32/slf4j-api-1.7.32.jar"
export CP="${CP}:/Users/buesing/.m2/repository/ch/qos/logback/logback-core/1.2.10/logback-core-1.2.10.jar"
export CP="${CP}:/Users/buesing/.m2/repository/com/fasterxml/jackson/core/jackson-annotations/2.12.3/jackson-annotations-2.12.3.jar"
export CP="${CP}:/Users/buesing/.m2/repository/com/github/luben/zstd-jni/1.5.0-4/zstd-jni-1.5.0-4.jar"
export CP="${CP}:/Users/buesing/.gradle/caches/modules-2/files-2.1/org.lz4/lz4-java/1.8.0/4b986a99445e49ea5fbf5d149c4b63f6ed6c6780/lz4-java-1.8.0.jar"
export CP="${CP}:/Users/buesing/.m2/repository/org/xerial/snappy/snappy-java/1.1.8.4/snappy-java-1.1.8.4.jar"

java -cp ${CP} dev.buesing.ksd.publisher.Main "$@"
