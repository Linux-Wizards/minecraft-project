package io.github.darkognu.simplenotepad;

import java.util.UUID;

public class Note {
    private final String message;
    private final UUID playerId;

    public Note(String message, UUID playerId) {
        this.message = message;
        this.playerId = playerId;
    }
}
