package com.eightam.lab.dto;

public class MerchantSummary {

    private Long id;
    private String name;
    private String contact;
    private String location;
    private String signatureStory;

    public MerchantSummary() {
    }

    public MerchantSummary(Long id,
                           String name,
                           String contact,
                           String location,
                           String signatureStory) {
        this.id = id;
        this.name = name;
        this.contact = contact;
        this.location = location;
        this.signatureStory = signatureStory;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getSignatureStory() {
        return signatureStory;
    }

    public void setSignatureStory(String signatureStory) {
        this.signatureStory = signatureStory;
    }
}
