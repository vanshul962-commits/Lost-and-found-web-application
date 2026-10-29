package com.mycompany.milgaya.model;

import java.sql.Timestamp;

public class Claim {
    private int id;
    private int itemId;
    private String itemTitle;
    private String itemType;
    private String itemImageUrl;
    private int claimantId;
    private String claimantName;
    private String claimantEmail;
    private String claimantContact;
    private String claimMessage;
    private String claimProof;
    private String status; // 'PENDING', 'ACCEPTED', 'REJECTED'
    private String ownerReply;
    private Timestamp createdAt;

    public Claim() {
        this.status = "PENDING";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getItemTitle() { return itemTitle; }
    public void setItemTitle(String itemTitle) { this.itemTitle = itemTitle; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public String getItemImageUrl() { return itemImageUrl; }
    public void setItemImageUrl(String itemImageUrl) { this.itemImageUrl = itemImageUrl; }

    public int getClaimantId() { return claimantId; }
    public void setClaimantId(int claimantId) { this.claimantId = claimantId; }

    public String getClaimantName() { return claimantName; }
    public void setClaimantName(String claimantName) { this.claimantName = claimantName; }

    public String getClaimantEmail() { return claimantEmail; }
    public void setClaimantEmail(String claimantEmail) { this.claimantEmail = claimantEmail; }

    public String getClaimantContact() { return claimantContact; }
    public void setClaimantContact(String claimantContact) { this.claimantContact = claimantContact; }

    public String getClaimMessage() { return claimMessage; }
    public void setClaimMessage(String claimMessage) { this.claimMessage = claimMessage; }

    public String getClaimProof() { return claimProof; }
    public void setClaimProof(String claimProof) { this.claimProof = claimProof; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getOwnerReply() { return ownerReply; }
    public void setOwnerReply(String ownerReply) { this.ownerReply = ownerReply; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
