package io.github.darkognu.simplenotepad;

import com.google.common.base.Charsets;
import com.google.common.io.CharStreams;
import org.bukkit.configuration.InvalidConfigurationException;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;

import java.io.IOException;
import java.io.InputStreamReader;

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
        if (!config.getString("db_type").equals("mysql")) {
            return false;
        }

        return true;
    }

    private static void saveHibernateConfig(FileConfiguration config, JavaPlugin plugin) throws IOException {
        // Jinjava jinja = new Jinjava();

        String hibernateTemplate = CharStreams.toString(new InputStreamReader(plugin.getResource("hibernate.cfg.xml"), Charsets.UTF_8));
        plugin.getLogger().info(hibernateTemplate);
    }
}
