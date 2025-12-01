package com.eightam.lab.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "merchants")
public class Merchant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String contact;

    private String location;

    @Column(name = "signature_story", length = 512)
    private String signatureStory;

    private Double latitude;

    private Double longitude;

    protected Merchant() {
    }

    public Merchant(String name, String contact, String location, String signatureStory) {
        this(name, contact, location, signatureStory, null, null);
    }

    public Merchant(String name, String contact, String location, String signatureStory,
                    Double latitude, Double longitude) {
        this.name = name;
        this.contact = contact;
        this.location = location;
        this.signatureStory = signatureStory;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getContact() {
        return contact;
    }

    public String getLocation() {
        return location;
    }

    public String getSignatureStory() {
        return signatureStory;
    }

    public Double getLatitude() {
        return latitude;
    }

    public Double getLongitude() {
        return longitude;
    }
}
