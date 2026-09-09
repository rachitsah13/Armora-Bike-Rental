package com.armora.model;

import java.sql.Date;

public class Issue {
    private int issueId;
    private int userId;
    private int bikeId;
    private String userName;
    private String bikeTitle;
    private String bikeGenre;
    private Date issueDate;
    private Date dueDate;
    private Date returnDate;
    private String status;

    public int getIssueId() { return issueId; }
    public void setIssueId(int issueId) { this.issueId = issueId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBikeId() { return bikeId; }
    public void setBikeId(int bikeId) { this.bikeId = bikeId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getBikeTitle() { return bikeTitle; }
    public void setBikeTitle(String bikeTitle) { this.bikeTitle = bikeTitle; }

    public String getBikeGenre() { return bikeGenre; }
    public void setBikeGenre(String bikeGenre) { this.bikeGenre = bikeGenre; }

    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
