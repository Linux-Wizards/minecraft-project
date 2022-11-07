package io.github.darkognu.simplenotepad;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import org.bukkit.Bukkit;
import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.bukkit.plugin.java.JavaPlugin;
import org.checkerframework.checker.nullness.qual.NonNull;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import java.util.List;

public class Notepad implements CommandExecutor {
    private final SessionFactory sessionFactory;
    private final JavaPlugin plugin;
    static final int max_results = 30;

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
        } else if (args[0].equals("show")) {
            showNotes(player, args);
        } else if (args[0].equals("delete")) {
            deleteNotes(player, args);
        }

        return true;
    }

    private void addNewNote(@NonNull Player player, String[] args) {
        if (args.length <= 1) {
            player.sendMessage("Your note can't be empty!");
            return;
        }

        // Concatenate the message
        String message = arrayToString(args, 1);

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
            // --- Close the session ---
            session.close();
            // Inform the player that his message has been saved
            player.sendMessage("Your message has been saved!");
        });
    }

    private void showNotes(@NonNull Player player, @NonNull String[] args) {
        // Simply show top 100 latest notes in compact format
        if (args.length <= 1) {
            showNotes(player, false);
        }
    }

    private void showNotes(final Player player, boolean compact) {
        Bukkit.getScheduler().runTaskAsynchronously(plugin, () -> {
            // Get a Hibernate session
            Session session = sessionFactory.getCurrentSession();
            // Start a transaction
            session.beginTransaction();
            // Create a CriteriaBuilder
            CriteriaBuilder cb = session.getCriteriaBuilder();
            // Create a CriteriaQuery
            CriteriaQuery<Note> cq = cb.createQuery(Note.class);
            // Create a Criteria Root
            Root<Note> root = cq.from(Note.class);
            // --- Select appropriate rows ---
            cq.select(root).where(cb.equal(root.get("playerId"), player.getUniqueId()));
            // Create a Query, show max. 30 results
            Query<Note> query = session.createQuery(cq).setMaxResults(max_results);
            // Obtain the results!
            List<Note> notes = query.getResultList();
            // --- Close the session ---
            session.close();
            // Show the notes to the player
            printNotes(player, compact, notes);
        });
    }

    private void printNotes(final Player player, boolean compact, List<Note> notes) {
        if (notes.isEmpty()) {
            player.sendMessage("No notes found!");
        } else {
            player.sendMessage("Your recent notes:");
        }

        for (Note note : notes) {
            String message = note.getMessage();

            if (compact) {
                int endIndex = Math.min(message.length(), 27);
                String suffix = endIndex == 27 ? "..." : "";
                player.sendMessage(note.getDate() + ": " + note.getMessage().substring(0, endIndex) + suffix);
            } else {
                player.sendMessage(note.getDate() + ": " + note.getMessage());
            }
        }

        // If player reached the limit
        if (notes.size() == max_results) {
            player.sendMessage("The results limit (30) has been reached, not all results are shown.");
        }
    }

    private void deleteNotes(@NonNull Player player, @NonNull String[] args) {
        player.sendMessage("Not yet implemented!");
    }

    private static String arrayToString(String[] array, int start) {
        return arrayToString(array, start, array.length - 1);
    }
    private static String arrayToString(String[] array, int start, int end) {
        // Make a string from the array
        StringBuilder sb = new StringBuilder();

        for (int i = start; i <= end; ++i) {
            // Append spaces conditionally
            if (i != start) {
                sb.append(' ');
            }
            // Append the word
            sb.append(array[i]);
        }

        return sb.toString();
    }
}
