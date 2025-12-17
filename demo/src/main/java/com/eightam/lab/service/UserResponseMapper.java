package com.eightam.lab.service;

import com.eightam.lab.domain.loyalty.MembershipTier;
import com.eightam.lab.dto.UserResponse;
import com.eightam.lab.entity.LabUser;
import com.eightam.lab.entity.Merchant;
import org.springframework.stereotype.Component;

@Component
public class UserResponseMapper {

    public UserResponse from(LabUser user) {
        Merchant merchant = user.getManagedMerchant();
        MembershipTier tier = user.getMembershipTier();
        return new UserResponse(
                user.getId(),
                user.getUsername(),
                user.getDisplayName(),
                user.getFamilyName(),
                user.getGivenName(),
                user.getGender(),
                user.getPhone(),
                user.getBirthday() != null ? user.getBirthday().toString() : null,
                user.getRole().name(),
                user.getAvatar(),
                merchant != null ? merchant.getId() : null,
                merchant != null ? merchant.getName() : null,
                user.getPoints(),
                tier.getCode(),
                tier.getLabel()
        );
    }
}
