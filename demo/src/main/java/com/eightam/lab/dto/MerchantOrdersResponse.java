package com.eightam.lab.dto;

import java.util.List;

public record MerchantOrdersResponse(
        String merchantName,
        long received,
        long preparing,
        long ready,
        long completed,
        List<MerchantOrderView> orders
) {
}
