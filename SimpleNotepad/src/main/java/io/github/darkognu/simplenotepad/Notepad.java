package io.github.darkognu.simplenotepad;

import org.bukkit.command.Command;
import org.bukkit.command.CommandExecutor;
import org.bukkit.command.CommandSender;
import org.bukkit.entity.Player;
import org.checkerframework.checker.nullness.qual.NonNull;
import org.hibernate.SessionFactory;

public class Notepad implements CommandExecutor {
    private final SessionFactory sessionFactory;

    public Notepad(@NonNull SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Override
    public boolean onCommand(@NonNull CommandSender sender, @NonNull Command command, @NonNull String label, String[] args) {
        if (!(sender instanceof Player)) {
            sender.sendMessage("Only players can use this command.");
            return true;
        }

        // Cast the sender to a Player
        Player player = (Player) sender;

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
    }
}
