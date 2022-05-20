package dev.buesing.ksd.publisher;

import com.beust.jcommander.Parameter;
import dev.buesing.ksd.parse.DateTimeConverter;
import dev.buesing.ksd.parse.DurationConverter;
import java.sql.Timestamp;
import java.time.*;

@SuppressWarnings({"FieldMayBeFinal"})
public class Options {

    @Parameter(names = "--help", help = true, hidden = true)
    private boolean help;

    @Parameter(names = {"-b", "--bootstrap-servers"}, description = "cluster bootstrap servers")
    private String bootstrapServers = "localhost:19092,localhost:29092,localhost:39092";

    @Parameter(names = {"--line-items"}, description = "use x-y for a range, single value for absolute")
    private String lineItemCount = "1-5";

    @Parameter(names = {"--pause"}, description = "")
    private Long pause = 1000L;

    @Parameter(names = {"--timestampAdjustment"}, description = "", converter = DurationConverter.class)
    private Duration timestampAdjustment = Duration.ZERO;

    @Parameter(names = {"--timestamp"}, description = "", converter = DateTimeConverter.class)
    private LocalDateTime timestamp;

    @Parameter(names = {"--min-timestamp"}, description = "", converter = DateTimeConverter.class)
    private LocalDateTime minTimestamp;

    @Parameter(names = {"--max-timestamp"}, description = "", converter = DateTimeConverter.class)
    private LocalDateTime maxTimestamp;

    @Parameter(names = {"--maxQuantity"}, description = "")
    private Integer maxQuantity = 10;

    @Parameter(names = {"--topic"}, description = "")
    private String topic = "orders";

    @Parameter(names = {"--sku-topic"}, description = "")
    private String skuTopic = "skus";

    public String getTopic() {
        return topic;
    }

    public String getSkuTopic() {
        return skuTopic;
    }

    public boolean isHelp() {
        return help;
    }

    public String getBootstrapServers() {
        return bootstrapServers;
    }

    public String getLineItemCount() {
        return lineItemCount;
    }

    public Long getPause() {
        return pause;
    }

    public Integer getMaxQuantity() {
        return maxQuantity;
    }

    public Duration getTimestampAdjustment() {
        return timestampAdjustment;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public LocalDateTime getMinTimestamp() {
        return minTimestamp;
    }

    public LocalDateTime getMaxTimestamp() {
        return maxTimestamp;
    }
}
