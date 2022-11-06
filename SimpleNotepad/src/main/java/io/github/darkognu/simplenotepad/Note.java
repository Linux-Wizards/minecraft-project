package io.github.darkognu.simplenotepad;

import java.util.UUID;

public class Note {
    private Long id;
    private String title;
    private String message;
    private UUID playerId;

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getMessage() {
        return message;
    }

    public UUID getPlayerId() {
        return playerId;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setPlayerId(UUID playerId) {
        this.playerId = playerId;
    }
}
