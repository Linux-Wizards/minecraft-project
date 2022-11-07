package io.github.darkognu.simplenotepad;

import com.google.common.base.Charsets;
import com.google.common.collect.ImmutableMap;
import com.google.common.io.CharStreams;
import com.hubspot.jinjava.Jinjava;
import org.bukkit.configuration.InvalidConfigurationException;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Objects;

public class Config {
    public static void initConfig(JavaPlugin plugin) throws InvalidConfigurationException, IOException {
        // Save the default config - if it doesn't exist
        plugin.saveDefaultConfig();
        // For convenience - store a reference to the config in a variable
        FileConfiguration config = plugin.getConfig();

        // Validate the configuration file
        if (!validateConfig(config)) {
            throw new InvalidConfigurationException("Unsupported database type: " + config.getString("db_type") + " is not supported.");
        }

        // Add all the default configuration variables
        config.addDefault("db_type", "mysql");
        config.addDefault("db_host", "localhost");
        config.addDefault("db_port", 3306);
        config.addDefault("db_name", "minecraft_db");
        config.addDefault("db_ssl", false);
        config.addDefault("db_user", "minecraft_user");
        config.addDefault("db_password", "your_password");
        config.addDefault("table_name", "simple_notepad");
        config.addDefault("db_connections", 10);
        config.addDefault("regenerate_hibernate_config", true);

        // Load all the default values (if they aren't provided in config.yml)
        config.options().copyDefaults(true);

        // Make sure that missing default values get saved
        plugin.saveConfig();

        // Save Hibernate configuration files
        saveHibernateConfig(config, plugin);
    }

    private static boolean validateConfig(FileConfiguration config) {
        // We only support MySQL
        return Objects.equals(config.getString("db_type"), "mysql");
    }

    private static void saveHibernateConfig(FileConfiguration config, JavaPlugin plugin) throws IOException {
        // Create our template engine
        Jinjava jinja;

        // Jinjava has a bug where it can't find a class - workaround below
        ClassLoader curClassLoader = Thread.currentThread().getContextClassLoader();
        try {
            Thread.currentThread().setContextClassLoader(plugin.getClass().getClassLoader());
            jinja = new Jinjava();
        } finally {
            Thread.currentThread().setContextClassLoader(curClassLoader);
        }

        String hibernateTemplate = CharStreams.toString(new InputStreamReader(Objects.requireNonNull(plugin.getResource("hibernate.cfg.xml")), Charsets.UTF_8));
        String noteTemplate = CharStreams.toString(new InputStreamReader(Objects.requireNonNull(plugin.getResource("note.hbm.xml")), Charsets.UTF_8));

        Map<String, Object> hibernateContext = ImmutableMap.of(
                "driver", getDriver(config),
                "connection_string", getConnectionString(config, jinja),
                "db_user", Objects.requireNonNull(config.getString("db_user")),
                "db_password", Objects.requireNonNull(config.getString("db_password")),
                "db_connections", Objects.requireNonNull(config.getString("db_connections")),
                "sql_dialect", getSqlDialect(config)
        );

        Map<String, Object> noteContext = ImmutableMap.of("table_name", Objects.requireNonNull(config.getString("table_name")));

        String renderedHibernate = jinja.render(hibernateTemplate, hibernateContext);
        String renderedNote = jinja.render(noteTemplate, noteContext);

        // Create a directory for Hibernate files
        File hibernateDir = new File(plugin.getDataFolder() + "/hibernate");

        if (!hibernateDir.exists()) {
            //noinspection ResultOfMethodCallIgnored
            hibernateDir.mkdirs();
        }

        // Write the files...
        Path hibernateFile = Paths.get(hibernateDir + "/hibernate.cfg.xml");
        Path noteFile = Paths.get(hibernateDir + "/note.hbm.xml");

        // But also check whether they should be regenerated!
        boolean shouldRegenerate = config.getBoolean("regenerate_hibernate_config");

        if (!hibernateFile.toFile().exists() || shouldRegenerate)
        {
            Files.writeString(hibernateFile, renderedHibernate, Charsets.UTF_8);
        }

        if (!noteFile.toFile().exists() || shouldRegenerate)
        {
            Files.writeString(noteFile, renderedNote, Charsets.UTF_8);
        }
    }

    private static String getDriver(FileConfiguration config) {
        if (Objects.equals(config.getString("db_type"), "mysql")) {
            return "com.mysql.cj.jdbc.Driver";
        }

        // DB Type should already be validated
        return "";
    }

    private static String getConnectionString(FileConfiguration config, Jinjava jinja) {
        if (Objects.equals(config.getString("db_type"), "mysql")) {
            // Ampersand - &amp;
            String template = "jdbc:mysql://{{ db_host }}:{{ db_port }}/{{ db_name }}?useSSL={{ db_ssl }}";

            Map<String, Object> context = ImmutableMap.of(
                    "db_host", Objects.requireNonNull(config.getString("db_host")),
                    "db_port", Objects.requireNonNull(config.getString("db_port")),
                    "db_name", Objects.requireNonNull(config.getString("db_name")),
                    "db_ssl", Objects.requireNonNull(config.getString("db_ssl"))
            );

            return jinja.render(template, context);
        }

        // DB Type should already be validated
        return "";
    }

    private static String getSqlDialect(FileConfiguration config) {
        if (Objects.equals(config.getString("db_type"), "mysql")) {
            return "org.hibernate.dialect.MySQLDialect";
        }

        // DB Type should already be validated
        return "";
    }
}
