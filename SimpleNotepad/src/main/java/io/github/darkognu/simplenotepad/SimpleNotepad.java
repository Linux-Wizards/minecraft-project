package io.github.darkognu.simplenotepad;

import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;

public class SimpleNotepad extends JavaPlugin {

    @Override
    public void onEnable() {
        getLogger().info("onEnable is called!");

        // Handling configuration
        FileConfiguration config = initConfig();

        // Register the 'notepad' command
        this.getCommand("notepad").setExecutor(new Notepad());
    }
    @Override
    public void onDisable() {
        getLogger().info("onDisable is called!");
    }

    private FileConfiguration initConfig() {
        FileConfiguration config = this.getConfig();

        // Add all the default configuration variables
        config.addDefault("db_type", "mysql");
        config.addDefault("db_host", "localhost");
        config.addDefault("db_port", 3306);
        config.addDefault("db_name", "minecraft_db");
        config.addDefault("db_user", "minecraft_user");
        config.addDefault("db_password", "your_password");
        config.addDefault("table_name", "simple_notepad");

        return config;
    }

}
