package com.eightam.lab.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "alipay")
public class AlipayProperties {

    /**
     * 支付宝应用 APP ID（沙箱或生产环境）
     */
    private String appId;

    /**
     * 应用 RSA2 私钥
     */
    private String privateKey;

    /**
     * 支付宝公钥
     */
    private String publicKey;

    /**
     * 网关地址，沙箱默认 https://openapi.alipaydev.com/gateway.do
     */
    private String gateway = "https://openapi.alipaydev.com/gateway.do";

    /**
     * 支付宝回调通知地址（公网可访问）
     */
    private String notifyUrl;

    /**
     * 支付完成后的同步跳转地址
     */
    private String returnUrl;

    /**
     * 默认 RSA2
     */
    private String signType = "RSA2";

    /**
     * 是否由服务器拉取支付宝页面 HTML 并返回给客户端，避免前端直连
     */
    private boolean fetchPage = false;

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getPrivateKey() {
        return privateKey;
    }

    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getGateway() {
        return gateway;
    }

    public void setGateway(String gateway) {
        this.gateway = gateway;
    }

    public String getNotifyUrl() {
        return notifyUrl;
    }

    public void setNotifyUrl(String notifyUrl) {
        this.notifyUrl = notifyUrl;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public String getSignType() {
        return signType;
    }

    public void setSignType(String signType) {
        this.signType = signType;
    }

    public boolean isFetchPage() {
        return fetchPage;
    }

    public void setFetchPage(boolean fetchPage) {
        this.fetchPage = fetchPage;
    }
}
