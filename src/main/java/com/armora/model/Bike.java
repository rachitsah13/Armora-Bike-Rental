package com.armora.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Bike {
    private int bikeId;
    private String title;
    private String isbnNumber;
    private String genre;
    private String author;
    private String status;
    private BigDecimal pricePerHour;
    private String imageUrl;
    private Timestamp createdAt;

    // Constructors
    public Bike() {}

    public Bike(int bikeId, String title, String isbnNumber, String genre, String author, String status, BigDecimal pricePerHour) {
        this.bikeId = bikeId;
        this.title = title;
        this.isbnNumber = isbnNumber;
        this.genre = genre;
        this.author = author;
        this.status = status;
        this.pricePerHour = pricePerHour;
    }

    // Getters and Setters
    public int getBikeId() { return bikeId; }
    public void setBikeId(int bikeId) { this.bikeId = bikeId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getIsbnNumber() { return isbnNumber; }
    public void setIsbnNumber(String isbnNumber) { this.isbnNumber = isbnNumber; }

    public String getGenre() { return genre; }
    public void setGenre(String genre) { this.genre = genre; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getPricePerHour() { return pricePerHour; }
    public void setPricePerHour(BigDecimal pricePerHour) { this.pricePerHour = pricePerHour; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
