package com.campus.secondhand.common;

/** MyBatis writes the database-generated key into this per-insert object. */
public final class GeneratedId {
    private String id;
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
}
