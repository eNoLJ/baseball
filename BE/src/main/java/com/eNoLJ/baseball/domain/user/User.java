package com.eNoLJ.baseball.domain.user;

import com.eNoLJ.baseball.web.dto.EmailDTO;
import com.eNoLJ.baseball.web.dto.TokenDTO;
import com.eNoLJ.baseball.web.dto.UserInfoDTO;
import org.springframework.data.annotation.Id;

public class User {

    @Id
    private Long id;
    private String name;
    private String email;
    private String userId;
    private String token;

    public User() {}

    public User(String name, String email, String userId, String token) {
        this.name = name;
        this.email = email;
        this.userId = userId;
        this.token = token;
    }

    public static User createUser(UserInfoDTO userInfoDTO, EmailDTO emailDTO, TokenDTO tokenDTO) {
        return new User(userInfoDTO.getName(), emailDTO.getEmail(), userInfoDTO.getLogin(), tokenDTO.getAccess_token());
    }

    public void update(UserInfoDTO userInfoDTO, EmailDTO emailDTO, TokenDTO tokenDTO) {
        this.name = userInfoDTO.getName();
        this.email = emailDTO.getEmail();
        this.userId = userInfoDTO.getLogin();
        this.token = tokenDTO.getAccess_token();
    }

    public void removeToken() {
        this.token = null;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getUserId() {
        return userId;
    }

    public String getToken() {
        return token;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", userId='" + userId + '\'' +
                ", token='" + token + '\'' +
                '}';
    }
}
