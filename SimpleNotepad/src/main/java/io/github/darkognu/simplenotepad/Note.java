package io.github.darkognu.simplenotepad;

import java.util.Date;
import java.util.UUID;


public class Note {
    private Long id;
    private String message;
    private UUID playerId;
    private Date date;

    public Note(Long id, String message, UUID playerId, Date date) {
        this.id = id;
        this.message = message;
        this.playerId = playerId;
        this.date = date;
    }

    //
    // Hibernate fails without these getters and setters
    //
    @SuppressWarnings("unused")
    public Long getId() {
        return id;
    }
    @SuppressWarnings("unused")
    public String getMessage() {
        return message;
    }
    @SuppressWarnings("unused")
    public UUID getPlayerId() {
        return playerId;
    }
    @SuppressWarnings("unused")
    public Date getDate() {
        return date;
    }
    @SuppressWarnings("unused")
    public void setId(Long id) {
        this.id = id;
    }
    @SuppressWarnings("unused")
    public void setMessage(String message) {
        this.message = message;
    }
    @SuppressWarnings("unused")
    public void setPlayerId(UUID playerId) {
        this.playerId = playerId;
    }
    @SuppressWarnings("unused")
    public void setDate(Date date) {
        this.date = date;
    }
}
