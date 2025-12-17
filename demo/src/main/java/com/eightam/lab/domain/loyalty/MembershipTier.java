package com.eightam.lab.domain.loyalty;

import java.util.Arrays;

public enum MembershipTier {

    EXPERIENCE("EXPERIENCE", "体验会员", 0),
    PREFERRED("PREFERRED", "优享会员", 500),
    INSPIRE("INSPIRE", "灵感挚友", 1500),
    CURATOR("CURATOR", "主理人好友", 3000);

    private final String code;
    private final String label;
    private final int threshold;

    MembershipTier(String code, String label, int threshold) {
        this.code = code;
        this.label = label;
        this.threshold = threshold;
    }

    public String getCode() {
        return code;
    }

    public String getLabel() {
        return label;
    }

    public int getThreshold() {
        return threshold;
    }

    public static MembershipTier fromCode(String code) {
        if (code == null) {
            return EXPERIENCE;
        }
        return Arrays.stream(values())
                .filter(tier -> tier.code.equalsIgnoreCase(code))
                .findFirst()
                .orElse(EXPERIENCE);
    }

    public static MembershipTier resolveByPoints(int points) {
        MembershipTier candidate = EXPERIENCE;
        for (MembershipTier tier : values()) {
            if (points >= tier.threshold) {
                candidate = tier;
            }
        }
        return candidate;
    }
}
