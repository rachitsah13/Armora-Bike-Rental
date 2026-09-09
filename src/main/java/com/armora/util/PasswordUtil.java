package com.armora.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    /**
     * Hashes a password using SHA-256. 
     * In a production environment, use BCrypt or Argon2 (requires external libraries).
     * Since this is a core Java implementation without external libraries guaranteed, we use SHA-256.
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            
            // Convert byte array into signum representation
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error initializing password hashing algorithm", e);
        }
    }

    /**
     * Verifies a plain text password against a hashed password.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        String newHash = hashPassword(plainPassword);
        return newHash.equals(hashedPassword);
    }
}
