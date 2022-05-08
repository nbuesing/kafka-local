package dev.buesing.ksd.parse;

import com.beust.jcommander.IStringConverter;
import com.beust.jcommander.ParameterException;
import java.time.Duration;
import java.time.format.DateTimeParseException;

public class DurationConverter implements IStringConverter<Duration> {

    @Override
    public Duration convert(String value) {
        try {
            return Duration.parse(value);
        } catch (DateTimeParseException e) {
            throw new ParameterException("Invalid duration");
        }
    }
}