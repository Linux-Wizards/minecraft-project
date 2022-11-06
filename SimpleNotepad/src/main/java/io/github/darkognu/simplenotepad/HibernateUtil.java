package io.github.darkognu.simplenotepad;

import org.bukkit.plugin.java.JavaPlugin;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.io.File;

public class HibernateUtil {
    public static SessionFactory buildFactory(String hibernateConfigPath, String[] classConfigPaths, JavaPlugin plugin) {
        plugin.getLogger().info("Hibernate: Building the Session Factory.");

        try {
            // Configure Hibernate
            Configuration configuration = new Configuration();
            configuration.configure(new File(hibernateConfigPath));

            // Configure all classes
            for (String path : classConfigPaths) {
                configuration.addFile(new File(path));
            }

            // Build the Session Factory - use JavaPlugin's ClassLoader to find the class
            ClassLoader curClassLoader = Thread.currentThread().getContextClassLoader();
            try {
                Thread.currentThread().setContextClassLoader(plugin.getClass().getClassLoader());
                return configuration.buildSessionFactory();
            } finally {
                Thread.currentThread().setContextClassLoader(curClassLoader);
            }

        } catch (Throwable ex) {
            plugin.getLogger().severe("Hibernate: Failed building the Session Factory.");
            throw new ExceptionInInitializerError(ex);
        }
    }
}
