package com.eNoLJ.baseball.authorization;

import com.eNoLJ.baseball.web.dto.EmailDTO;
import com.eNoLJ.baseball.web.dto.TokenDTO;
import com.eNoLJ.baseball.web.dto.UserInfoDTO;

public interface OAuth {

    TokenDTO getTokenAPI(String code);

    UserInfoDTO getUserInfoAPI(String token);

    EmailDTO getEmailAPI(String token);
}
