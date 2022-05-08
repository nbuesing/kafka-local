package dev.buesing.ksd.publisher;

import com.beust.jcommander.JCommander;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {

    private static final Logger log = LoggerFactory.getLogger(Producer.class);

    final static Thread.UncaughtExceptionHandler exceptionHandler = (t, e) -> log.error("Uncaught exception in thread '" + t.getName() + "': " + e.getMessage());

    public static void main(String[] args) {

        final Options options = new Options();
        final JCommander jCommander = JCommander.newBuilder()
                .addObject(options)
                .build();
        jCommander.parse(args);

        if (options.isHelp()) {
            jCommander.usage();
            return;
        }

        final ExecutorService executor = Executors.newSingleThreadExecutor(r -> {
            final Thread t = Executors.defaultThreadFactory().newThread(r);
            t.setDaemon(true);
            t.setUncaughtExceptionHandler(exceptionHandler);
            return t;
        });

        Future<?> future = executor.submit(() -> {
            new Producer(options).start();
        });

        try {
            future.get();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

