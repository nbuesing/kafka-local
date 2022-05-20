package dev.buesing.ksd.publisher;

import dev.buesing.ksd.domain.PurchaseOrder;
import dev.buesing.ksd.serde.JsonSerializer;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAmount;
import java.time.temporal.TemporalUnit;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.kafka.clients.CommonClientConfigs;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class Producer {

    private static final Logger log = LoggerFactory.getLogger(Producer.class);

    private static final Random RANDOM = new Random();

    private static final String ORDER_PREFIX = RandomStringUtils.randomAlphabetic(2).toUpperCase(Locale.ROOT);

    private final Options options;

    public Producer(final Options options) {
        this.options = options;
    }


    private String getRandomUser() {
        return Integer.toString(RANDOM.nextInt(1000));
    }

    private String getRandomStore() {
        return Integer.toString(RANDOM.nextInt(100));
    }

    private String getRandomSku(int index) {
        return StringUtils.leftPad(Integer.toString(RANDOM.nextInt(1000)), 10, '0');
    }

    private int getRandomItemCount() {

        if (options.getLineItemCount().indexOf('-') < 0) {
            return Integer.parseInt(options.getLineItemCount());
        } else {
            String[] split = options.getLineItemCount().split("-");
            int min = Integer.parseInt(split[0]);
            int max = Integer.parseInt(split[1]);
            return RANDOM.nextInt(max + 1 - min) + min;
        }
    }

    private int getRandomQuantity() {
        return RANDOM.nextInt(options.getMaxQuantity()) + 1;
    }

    private static int counter = 0;

    private static String orderNumber() {
        return ORDER_PREFIX + "-" + (counter++);
    }

    private boolean running = true;

    private PurchaseOrder createPurchaseOrder() {
        PurchaseOrder purchaseOrder = new PurchaseOrder();

        System.out.println(options.getTimestamp());

        if (options.getTimestamp() != null) {
            purchaseOrder.setTimestamp(options.getTimestamp().toInstant(ZoneOffset.UTC));
            running = false;
        } else if (options.getMinTimestamp() != null && options.getMaxTimestamp() != null) {
            Instant random = between(options.getMinTimestamp().toInstant(ZoneOffset.UTC), options.getMaxTimestamp().toInstant(ZoneOffset.UTC));
            purchaseOrder.setTimestamp(random);
        } else {
            purchaseOrder.setTimestamp(Instant.now().minus(options.getTimestampAdjustment().toMillis(), ChronoUnit.MILLIS));
        }
        purchaseOrder.setOrderId(orderNumber());
        purchaseOrder.setUserId(getRandomUser());
        purchaseOrder.setStoreId(getRandomStore());
        purchaseOrder.setItems(IntStream.range(0, getRandomItemCount())
                .boxed()
                .map(i -> {
                    final PurchaseOrder.LineItem item = new PurchaseOrder.LineItem();
                    item.setSku(getRandomSku(i));
                    item.setQuantity(getRandomQuantity());
                    return item;
                })
                .collect(Collectors.toList())
        );

        return purchaseOrder;
    }

    public void start() {

        try (KafkaProducer<String, Object> kafkaProducer = new KafkaProducer<>(properties(options))) {

            while (running) {

                PurchaseOrder purchaseOrder = createPurchaseOrder();

                log.info("Sending key={}, value={}", purchaseOrder.getOrderId(), purchaseOrder);
                kafkaProducer.send(new ProducerRecord<>(options.getTopic(), null, purchaseOrder.getOrderId(), purchaseOrder), (metadata, exception) -> {
                    if (exception != null) {
                        log.error("error producing to kafka", exception);
                    } else {
                        log.debug("topic={}, partition={}, offset={}", metadata.topic(), metadata.partition(), metadata.offset());
                    }
                });

                purchaseOrder.asSkus().forEach(sku -> {
                    log.info("Sending Sku key={}, value={}", sku.getSku(), sku);
                    kafkaProducer.send(new ProducerRecord<>(options.getSkuTopic(), null, sku.getSku(), sku), (metadata, exception) -> {
                        if (exception != null) {
                            log.error("error producing to kafka", exception);
                        } else {
                            log.debug("topic={}, partition={}, offset={}", metadata.topic(), metadata.partition(), metadata.offset());
                        }
                    });

                });


                pause(options.getPause());
            }
        }
    }

    public void stop() {
        running = false;
    }

    private Map<String, Object> properties(final Options options) {
        return Map.ofEntries(
                Map.entry(CommonClientConfigs.BOOTSTRAP_SERVERS_CONFIG, options.getBootstrapServers()),
                Map.entry(CommonClientConfigs.SECURITY_PROTOCOL_CONFIG, "PLAINTEXT"),
                Map.entry(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName()),
                Map.entry(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, JsonSerializer.class.getName()),
                Map.entry(ProducerConfig.ACKS_CONFIG, "all"),
                Map.entry(ProducerConfig.LINGER_MS_CONFIG, 50L)
        );
    }

    private static void pause(final long duration) {
        try {
            Thread.sleep(duration);
        } catch (InterruptedException e) {
            //ignore
        }
    }

    private static Instant between(final Instant startInclusive, final Instant endExclusive) {
        return Instant.ofEpochSecond(ThreadLocalRandom.current().nextLong(startInclusive.getEpochSecond(), endExclusive.getEpochSecond()));
    }
}
