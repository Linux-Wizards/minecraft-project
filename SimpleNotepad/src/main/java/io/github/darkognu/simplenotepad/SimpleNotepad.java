package io.github.darkognu.simplenotepad;

import org.bukkit.plugin.java.JavaPlugin;

public class SimpleNotepad extends JavaPlugin {

    @Override
    public void onEnable() {
        getLogger().info("onEnable is called!");

        // Register the 'notepad' command
        this.getCommand("notepad").setExecutor(new Notepad());
    }
    @Override
    public void onDisable() {
        getLogger().info("onDisable is called!");
    }

}
