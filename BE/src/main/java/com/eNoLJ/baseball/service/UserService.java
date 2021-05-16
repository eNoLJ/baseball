package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.authorization.GitHubOAuth;
import com.eNoLJ.baseball.authorization.OAuth;
import com.eNoLJ.baseball.domain.user.User;
import com.eNoLJ.baseball.domain.user.UserRepository;
import com.eNoLJ.baseball.exception.EntityNotFoundException;
import com.eNoLJ.baseball.exception.ErrorMessage;
import com.eNoLJ.baseball.exception.TokenException;
import com.eNoLJ.baseball.web.dto.EmailDTO;
import com.eNoLJ.baseball.web.dto.TokenDTO;
import com.eNoLJ.baseball.web.dto.UserInfoDTO;
import com.eNoLJ.baseball.web.dto.UserResponseDTO;
import com.eNoLJ.baseball.web.utils.JwtUtil;
import org.springframework.stereotype.Service;

import static com.eNoLJ.baseball.domain.user.User.createUser;
import static com.eNoLJ.baseball.web.dto.UserResponseDTO.createUserResponseDTO;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final OAuth gitHubOAuth;

    public UserService(UserRepository userRepository, GitHubOAuth gitHubOAuth) {
        this.userRepository = userRepository;
        this.gitHubOAuth = gitHubOAuth;
    }

    public UserResponseDTO login(String code) {
        TokenDTO tokenDTO = tokenRequestApi(code);
        UserInfoDTO userInfoDTO = userInfoRequestApi(tokenDTO.getAccess_token());
        EmailDTO emailDTO = emailRequestApi(tokenDTO.getAccess_token());
        if (verifyUser(userInfoDTO.getLogin())) {
            User user = findByUserId(userInfoDTO.getLogin());
            user.update(userInfoDTO, emailDTO, tokenDTO);
            return createUserResponseDTO(userRepository.save(user), JwtUtil.createToken(user.getUserId()));
        }
        User user = createUser(userInfoDTO, emailDTO, tokenDTO);
        return createUserResponseDTO(userRepository.save(user), JwtUtil.createToken(user.getUserId()));
    }

    public void logout(String authorization) {
        String userId = JwtUtil.getUserIdFromToken(getTokenFromAuthorization(authorization));
        User user = findByUserId(userId);
        user.removeToken();
        userRepository.save(user);
    }

    private String getTokenFromAuthorization(String authorization) {
        String[] authArray = authorization.split(" ");
        if (authArray.length < 2 || !authArray[0].equals("Beare")) {
            throw new TokenException(ErrorMessage.INVALID_TOKEN);
        }
        return authArray[1];
    }

    private TokenDTO tokenRequestApi(String code) {
        return gitHubOAuth.getTokenAPI(code);
    }

    private UserInfoDTO userInfoRequestApi(String token) {
        return gitHubOAuth.getUserInfoAPI(token);
    }

    private EmailDTO emailRequestApi(String token) {
       return gitHubOAuth.getEmailAPI(token);
    }

    private boolean verifyUser(String userId) {
        return userRepository.findByUserId(userId).isPresent();
    }

    private User findByUserId(String userId) {
        return userRepository.findByUserId(userId).orElseThrow(EntityNotFoundException::new);
    }
}
