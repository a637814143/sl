package com.eightam.lab.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import java.time.LocalDateTime;

@Entity
@Table(name = "merchant_requests")
public class MerchantRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "merchant_name", nullable = false, length = 128)
    private String merchantName;

    @Column(name = "applicant_name", nullable = false, length = 64)
    private String applicantName;

    @Column(name = "contact_phone", length = 32)
    private String contactPhone;

    @Column(length = 255)
    private String location;

    @Column(length = 512)
    private String note;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private MerchantRequestStatus status = MerchantRequestStatus.PENDING;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "processed_at")
    private LocalDateTime processedAt;

    protected MerchantRequest() {
    }

    public MerchantRequest(String merchantName, String applicantName,
                           String contactPhone, String location, String note) {
        this.merchantName = merchantName;
        this.applicantName = applicantName;
        this.contactPhone = contactPhone;
        this.location = location;
        this.note = note;
    }

    @PrePersist
    public void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public Long getId() {
        return id;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public String getApplicantName() {
        return applicantName;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public String getLocation() {
        return location;
    }

    public String getNote() {
        return note;
    }

    public MerchantRequestStatus getStatus() {
        return status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void markApproved() {
        this.status = MerchantRequestStatus.APPROVED;
        this.processedAt = LocalDateTime.now();
    }

    public void markRejected() {
        this.status = MerchantRequestStatus.REJECTED;
        this.processedAt = LocalDateTime.now();
    }

    public boolean isTerminal() {
        return status == MerchantRequestStatus.APPROVED || status == MerchantRequestStatus.REJECTED;
    }
}
