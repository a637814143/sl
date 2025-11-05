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

    protected Merchant() {
    }

    public Merchant(String name, String contact, String location, String signatureStory) {
        this.name = name;
        this.contact = contact;
        this.location = location;
        this.signatureStory = signatureStory;
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
}
