package io.github.darkognu.simplenotepad;

import com.google.common.base.Charsets;
import com.google.common.io.CharStreams;
import com.hubspot.jinjava.Jinjava;
import org.bukkit.configuration.InvalidConfigurationException;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Objects;

public class Config {
    public static FileConfiguration initConfig(JavaPlugin plugin) throws InvalidConfigurationException, IOException {
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

        // Load all the default values (if they aren't provided in config.yml)
        config.options().copyDefaults(true);

        // Make sure that missing default values get saved
        plugin.saveConfig();

        // Save Hibernate configuration files
        saveHibernateConfig(config, plugin);

        // Return a reference to config
        return config;
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
    }
}
