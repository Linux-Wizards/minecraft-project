package io.github.darkognu.simplenotepad;

import org.bukkit.configuration.InvalidConfigurationException;
import org.bukkit.plugin.java.JavaPlugin;
import org.hibernate.SessionFactory;

import java.io.IOException;
import java.util.Objects;


public class SimpleNotepad extends JavaPlugin {
    private SessionFactory sessionFactory;

    @Override
    public void onEnable() {
        // Handling configuration
        try {
            this.getLogger().info("Reading the plugins's configuration...");
            Config.initConfig(this);
        } catch (InvalidConfigurationException | IOException e) {
            this.getLogger().severe("Reading plugin's configuration failed!");
            throw new RuntimeException(e);
        }

        // Create a SessionFactory
        String hibernateConfig = this.getDataFolder() + "/hibernate/hibernate.cfg.xml";
        String noteConfig = this.getDataFolder() + "/hibernate/note.hbm.xml";
        sessionFactory = HibernateUtil.buildFactory(hibernateConfig, new String[]{noteConfig}, this);

        // Register the 'notepad' command
        Objects.requireNonNull(this.getCommand("notepad")).setExecutor(new Notepad(sessionFactory, this));
    }

    @Override
    public void onDisable() {
        // Close the session factory
        if (sessionFactory != null) {
            sessionFactory.close();
        }
    }

}
