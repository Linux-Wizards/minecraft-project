package io.github.darkognu.simplenotepad;

import org.bukkit.plugin.java.JavaPlugin;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    public static SessionFactory buildFactory(String hibernateConfigPath, String[] classConfigPaths, JavaPlugin plugin) {
        plugin.getLogger().info("Hibernate: Building the Session Factory.");

        try {
            // Configure Hibernate
            Configuration configuration = new Configuration();
            configuration.configure(hibernateConfigPath);

            // Configure all classes
            for (String file : classConfigPaths) {
                configuration.addResource(file);
            }

            // Build the Session Factory
            return configuration.buildSessionFactory();

        } catch (Throwable ex) {
            plugin.getLogger().severe("Hibernate: Failed building the Session Factory.");
            throw new ExceptionInInitializerError(ex);
        }
    }
}
