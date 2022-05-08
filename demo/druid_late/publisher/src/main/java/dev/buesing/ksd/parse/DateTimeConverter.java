package dev.buesing.ksd.parse;

import com.beust.jcommander.ParameterException;
import com.beust.jcommander.converters.BaseConverter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class DateTimeConverter extends BaseConverter<LocalDateTime> {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public DateTimeConverter(String optionName) {
        super(optionName);
    }

    public LocalDateTime convert(String value) {
        try {
            return LocalDateTime.parse(value, FORMATTER);
        } catch (DateTimeParseException e) {
            throw new ParameterException(this.getErrorString(value, String.format("an ISO-8601 formatted date (yyyy-MM-dd HH:mm:ss)")));
        }
    }
}