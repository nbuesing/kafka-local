package dev.buesing.ksd.serde;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import java.io.IOException;
import java.util.Map;
import java.util.TimeZone;
import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.Deserializer;

public class JsonDeserializer<T> implements Deserializer<T> {

    private static final ObjectMapper OBJECT_MAPPER =
            new ObjectMapper()
                    .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
                    .setTimeZone(TimeZone.getDefault())
                    .configure(DeserializationFeature.READ_DATE_TIMESTAMPS_AS_NANOSECONDS, false)
                    .registerModule(new JavaTimeModule());

    @SuppressWarnings("unused")
    public JsonDeserializer() {
    }

    @Override
    public void configure(Map<String, ?> props, boolean isKey) {
    }

    @Override
    public T deserialize(String topic, byte[] bytes) {
        if (bytes == null)
            return null;

        try {
            JsonNode node = OBJECT_MAPPER.readTree(bytes);

            if (node.get("$type") == null || !node.get("$type").isTextual()) {
                throw new SerializationException("missing '$type' field.");
            }

            return read(node.get("$type").asText(), node);
        } catch (final IOException e) {
            throw new SerializationException(e);
        }
    }

    @SuppressWarnings("unchecked")
    private T read(final String className, JsonNode jsonNode) {
        try {
            return  (T) OBJECT_MAPPER.convertValue(jsonNode, Class.forName(className));
        } catch (final ClassNotFoundException e) {
            throw new SerializationException(e);
        }
    }

    @Override
    public void close() {
    }
}