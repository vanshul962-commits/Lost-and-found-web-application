package com.mycompany.milgaya.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Item {
    private int id;
    private String type; // 'LOST' or 'FOUND'
    private String title;
    private int categoryId;
    private String categoryName;
    private String categoryIcon;
    private String description;
    private String location;
    private String city;
    private Date dateEvent;
    private BigDecimal rewardAmount;
    private String securityQuestion;
    private String imageUrl;
    private String status; // 'OPEN', 'CLAIMED', 'RESOLVED'
    private int userId;
    private String userName;
    private String userEmail;
    private String contactPhone;
    private String contactEmail;
    private boolean contactVisible;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Item() {
        this.rewardAmount = BigDecimal.ZERO;
        this.status = "OPEN";
        this.contactVisible = true;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getCategoryIcon() { return categoryIcon; }
    public void setCategoryIcon(String categoryIcon) { this.categoryIcon = categoryIcon; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public Date getDateEvent() { return dateEvent; }
    public void setDateEvent(Date dateEvent) { this.dateEvent = dateEvent; }

    public BigDecimal getRewardAmount() { return rewardAmount; }
    public void setRewardAmount(BigDecimal rewardAmount) { this.rewardAmount = rewardAmount; }

    public String getSecurityQuestion() { return securityQuestion; }
    public void setSecurityQuestion(String securityQuestion) { this.securityQuestion = securityQuestion; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public boolean isContactVisible() { return contactVisible; }
    public void setContactVisible(boolean contactVisible) { this.contactVisible = contactVisible; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isLost() {
        return "LOST".equalsIgnoreCase(this.type);
    }

    public boolean isFound() {
        return "FOUND".equalsIgnoreCase(this.type);
    }

    public boolean isResolved() {
        return "RESOLVED".equalsIgnoreCase(this.status) || "CLAIMED".equalsIgnoreCase(this.status);
    }
}
