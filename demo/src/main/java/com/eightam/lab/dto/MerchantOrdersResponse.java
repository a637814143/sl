package com.eightam.lab.dto;

import java.util.List;

public class MerchantOrdersResponse {

    private String merchantName;
    private long received;
    private long preparing;
    private long ready;
    private long completed;
    private List<MerchantOrderView> orders;

    public MerchantOrdersResponse() {
    }

    public MerchantOrdersResponse(String merchantName,
                                  long received,
                                  long preparing,
                                  long ready,
                                  long completed,
                                  List<MerchantOrderView> orders) {
        this.merchantName = merchantName;
        this.received = received;
        this.preparing = preparing;
        this.ready = ready;
        this.completed = completed;
        this.orders = orders;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public long getReceived() {
        return received;
    }

    public void setReceived(long received) {
        this.received = received;
    }

    public long getPreparing() {
        return preparing;
    }

    public void setPreparing(long preparing) {
        this.preparing = preparing;
    }

    public long getReady() {
        return ready;
    }

    public void setReady(long ready) {
        this.ready = ready;
    }

    public long getCompleted() {
        return completed;
    }

    public void setCompleted(long completed) {
        this.completed = completed;
    }

    public List<MerchantOrderView> getOrders() {
        return orders;
    }

    public void setOrders(List<MerchantOrderView> orders) {
        this.orders = orders;
    }
}
