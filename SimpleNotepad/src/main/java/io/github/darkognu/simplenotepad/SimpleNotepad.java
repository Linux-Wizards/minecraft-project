package io.github.darkognu.simplenotepad;

import org.bukkit.configuration.InvalidConfigurationException;
import org.bukkit.configuration.file.FileConfiguration;
import org.bukkit.plugin.java.JavaPlugin;

import java.util.Objects;

public class SimpleNotepad extends JavaPlugin {

    @Override
    public void onEnable() {
        getLogger().info("onEnable is called!");

        // Handling configuration
        try {
            FileConfiguration config = Config.initConfig(this);
        } catch (InvalidConfigurationException e) {
            throw new RuntimeException(e);
        }

        // Register the 'notepad' command
        Objects.requireNonNull(this.getCommand("notepad")).setExecutor(new Notepad());
    }
    @Override
    public void onDisable() {
        getLogger().info("onDisable is called!");
    }

}
