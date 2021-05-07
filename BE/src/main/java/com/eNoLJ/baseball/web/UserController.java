package com.eNoLJ.baseball.web;

import com.eNoLJ.baseball.service.UserService;
import com.eNoLJ.baseball.web.dto.UserResponseDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

@RestController
public class UserController {

    public final UserService userService;
    private final Logger logger = LoggerFactory.getLogger(UserController.class);

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/login")
    public UserResponseDTO login(@RequestParam String code) {
        logger.info("로그인 요청");
        return userService.login(code);
    }

    @GetMapping("/logout")
    public void logout(@RequestHeader String token) {
        logger.info("로그아웃 요청");
        userService.logout(token);
    }
}
