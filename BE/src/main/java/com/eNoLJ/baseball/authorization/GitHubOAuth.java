package com.eNoLJ.baseball.authorization;

import com.eNoLJ.baseball.errorHandler.RestTemplateResponseErrorHandler;
import com.eNoLJ.baseball.exception.ErrorMessage;
import com.eNoLJ.baseball.exception.OAuthException;
import com.eNoLJ.baseball.web.dto.EmailDTO;
import com.eNoLJ.baseball.web.dto.TokenDTO;
import com.eNoLJ.baseball.web.dto.UserInfoDTO;
import com.eNoLJ.baseball.web.utils.GitHubUrl;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;

@PropertySource("classpath:/oauth.properties")
@Component
public class GitHubOAuth implements OAuth{

    public static final String GITHUB_CLIENT_ID = "github.client.id";
    public static final String GITHUB_SECRET = "github.secret";
    public static final String CLIENT_ID = "client_id";
    public static final String CLIENT_SECRET = "client_secret";
    public static final String CODE = "code";
    public static final String TOKEN = "token";

    private final RestTemplate restTemplate;
    private final Environment environment;

    public GitHubOAuth(Environment environment, RestTemplateBuilder restTemplateBuilder) {
        this.restTemplate = restTemplateBuilder.errorHandler(new RestTemplateResponseErrorHandler()).build();
        this.environment = environment;
    }

    @Override
    public TokenDTO getTokenAPI(String code) {
        String id = environment.getProperty(GITHUB_CLIENT_ID);
        String secret = environment.getProperty(GITHUB_SECRET);
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(GitHubUrl.ACCESS_TOKEN.getUrl())
                .queryParam(CLIENT_ID, id)
                .queryParam(CLIENT_SECRET, secret)
                .queryParam(CODE, code);
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.set(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE);
        httpHeaders.set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
        HttpEntity<?> httpEntity = new HttpEntity<>(httpHeaders);
        return restTemplate.exchange(builder.toUriString(), HttpMethod.POST, httpEntity, TokenDTO.class).getBody();
    }

    @Override
    public UserInfoDTO getUserInfoAPI(String token) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(GitHubUrl.USER_INFO.getUrl());
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.set(HttpHeaders.AUTHORIZATION, TOKEN + " " + token);
        HttpEntity<?> httpEntity = new HttpEntity<>(httpHeaders);
        return restTemplate.exchange(builder.toUriString(), HttpMethod.GET, httpEntity, UserInfoDTO.class).getBody();
    }

    @Override
    public EmailDTO getEmailAPI(String token) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(GitHubUrl.USER_EMAIL.getUrl());
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.set(HttpHeaders.AUTHORIZATION, TOKEN + " " + token);
        HttpEntity<?> httpEntity = new HttpEntity<>(httpHeaders);
        List<EmailDTO> emailDTOList = restTemplate.exchange(builder.toUriString(), HttpMethod.GET, httpEntity, new ParameterizedTypeReference<List<EmailDTO>>() {}).getBody();
        return emailDTOList.stream().findFirst().orElseThrow(
                () -> new OAuthException(ErrorMessage.OAUTH_FAILED)
        );
    }
}
