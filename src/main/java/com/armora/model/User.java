package com.armora.model;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int userId;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String passwordHash;
    private String role;
    private String course;
    private String level;
    private String profilePicture;
    private boolean isApproved;

    // Default constructor
    public User() {}

    // Constructor without ID (for creation)
    public User(String firstName, String lastName, String email, String phone, 
                String passwordHash, String role, String course, String level) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.passwordHash = passwordHash;
        this.role = role;
        this.course = course;
        this.level = level;
        this.isApproved = false; // By default, requires admin approval
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { isApproved = approved; }

    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
}
