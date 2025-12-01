package com.eightam.lab.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;

public class ProfileUpdateRequest {

    @NotBlank(message = "昵称不能为空")
    @Size(max = 128, message = "昵称需在128个字符以内")
    private String displayName;

    @Size(max = 64, message = "姓氏需在64个字符以内")
    private String familyName;

    @Size(max = 64, message = "名字需在64个字符以内")
    private String givenName;

    @Size(max = 32, message = "性别描述需在32个字符以内")
    private String gender;

    @Size(max = 32, message = "手机号需在32个字符以内")
    private String phone;

    private LocalDate birthday;

    @Size(max = 255, message = "头像链接过长")
    private String avatar;

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getFamilyName() {
        return familyName;
    }

    public void setFamilyName(String familyName) {
        this.familyName = familyName;
    }

    public String getGivenName() {
        return givenName;
    }

    public void setGivenName(String givenName) {
        this.givenName = givenName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDate getBirthday() {
        return birthday;
    }

    public void setBirthday(LocalDate birthday) {
        this.birthday = birthday;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
}
