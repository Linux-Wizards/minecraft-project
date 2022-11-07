package io.github.darkognu.simplenotepad;

import org.bukkit.Bukkit;
import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.bukkit.plugin.java.JavaPlugin;
import org.checkerframework.checker.nullness.qual.NonNull;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

public class Notepad implements CommandExecutor {
    private final SessionFactory sessionFactory;
    private final JavaPlugin plugin;

    public Notepad(@NonNull SessionFactory sessionFactory, @NonNull JavaPlugin plugin) {
        this.sessionFactory = sessionFactory;
        this.plugin = plugin;
    }

    @Override
    public boolean onCommand(@NonNull CommandSender sender, @NonNull Command command, @NonNull String label, String[] args) {
        // Check if the sender is a player, also - cast the sender to a Player
        if (!(sender instanceof Player player)) {
            sender.sendMessage("Only players can use this command.");
            return true;
        }

        if (args.length == 0) {
            sender.sendMessage("You need to pass an argument to this command.");
            return false;
        } else if (args[0].equals("new")) {
            addNewNote(player, args);
        }

        return true;
    }

    private void addNewNote(@NonNull Player player, String[] args) {
        if (args.length <= 1) {
            player.sendMessage("Your note can't be empty!");
            return;
        }

        // Make a string from the array
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i < args.length; ++i) {
            sb.append(args[i]);
            // Append spaces conditionally
            if (i != args.length - 1) {
                sb.append(' ');
            }
        }

        String message = sb.toString();

        // Create a new note
        Note newNote = new Note(message, player.getUniqueId());

        // Save the note
        saveNote(newNote, player);
    }

    private void saveNote(final Note note, final Player player) {
        Bukkit.getScheduler().runTaskAsynchronously(plugin, () -> {
            // Get a Hibernate session
            Session session = sessionFactory.getCurrentSession();
            // Start a transaction
            session.beginTransaction();
            // Save the note
            session.persist(note);
            // Commit the transaction
            session.getTransaction().commit();
            session.close();
            player.sendMessage("Your message has been saved!");
        });
    }
}
