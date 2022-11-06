package io.github.darkognu.simplenotepad;

import org.bukkit.configuration.InvalidConfigurationException;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;

public class Config {
    public static FileConfiguration initConfig(JavaPlugin plugin) throws InvalidConfigurationException {
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

        // Load all the default values (if they aren't provided in config.yml)
        config.options().copyDefaults(true);

        // Make sure that missing default values get saved
        plugin.saveConfig();

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
}
