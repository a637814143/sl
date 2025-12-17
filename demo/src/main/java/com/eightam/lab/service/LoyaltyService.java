package com.eightam.lab.service;

import com.eightam.lab.domain.loyalty.MembershipTier;
import com.eightam.lab.repository.LabUserRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class LoyaltyService {

    private final LabUserRepository labUserRepository;

    public LoyaltyService(LabUserRepository labUserRepository) {
        this.labUserRepository = labUserRepository;
    }

    @Transactional
    public void recordEarnedPoints(Long userId, int earnedPoints) {
        if (userId == null || earnedPoints <= 0) {
            return;
        }
        labUserRepository.findById(userId).ifPresent(user -> {
            int current = Math.max(0, user.getPoints());
            int updated = current + earnedPoints;
            user.setPoints(updated);
            MembershipTier tier = MembershipTier.resolveByPoints(updated);
            if (!tier.getCode().equalsIgnoreCase(user.getMembershipLevel())) {
                user.setMembershipLevel(tier.getCode());
            }
        });
    }
}
