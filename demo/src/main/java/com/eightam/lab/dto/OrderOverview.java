package com.eightam.lab.dto;

public class OrderOverview {

    private long received;
    private long preparing;
    private long ready;
    private long completed;
    private String topDrink;

    public OrderOverview() {
    }

    public OrderOverview(long received,
                         long preparing,
                         long ready,
                         long completed,
                         String topDrink) {
        this.received = received;
        this.preparing = preparing;
        this.ready = ready;
        this.completed = completed;
        this.topDrink = topDrink;
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

    public String getTopDrink() {
        return topDrink;
    }

    public void setTopDrink(String topDrink) {
        this.topDrink = topDrink;
    }
}
