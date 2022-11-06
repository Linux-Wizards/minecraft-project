package io.github.darkognu.simplenotepad;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
    // Our SessionFactory
    private static SessionFactory sessionFactory;

    /*private static SessionFactory buildFactory() {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

        } catch (Throwable ex) {
            System.err.println("Initial SessionFactory creation failed.\n" + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getFactory() {
        if (sessionFactory == null) {
            sessionFactory = buildFactory();
        }

        return sessionFactory;
    }

    public static void shutdown() {
        // Close caches and connection pools
        getFactory().close();
    }*/
}
