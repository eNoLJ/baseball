package com.eNoLJ.baseball.web;

import com.eNoLJ.baseball.service.GameService;
import com.eNoLJ.baseball.web.dto.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class GameController {

    public final GameService gameService;
    private final Logger logger = LoggerFactory.getLogger(GameController.class);

    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    @GetMapping("/games")
    public List<GameEntryDTO> viewGameList() {
        logger.info("게임 목록 요청");
        return gameService.getGameList();
    }

    @GetMapping("/members/{teamName}")
    public List<MemberDTO> viewMembers(@PathVariable String teamName) {
        logger.info("{}팀의 선수 목록 요청", teamName);
        return gameService.getMembersByTeamName(teamName);
    }

    @GetMapping("/games/{teamName}")
    public GameInfoResponseDTO startGame(@PathVariable String teamName) {
        logger.info("{}팀으로 게임 시작 요청", teamName);
        return gameService.startGameByTeamName(teamName);
    }

    @PatchMapping("/games")
    public GameInfoResponseDTO pitchGame(@RequestBody GameInfoRequestDTO requestDTO) {
        logger.info("피치 요청 공수교대 X");
        return gameService.pitchGame(requestDTO);
    }

    @PostMapping("/games")
    public GameInfoResponseDTO postGame(@RequestBody GameInfoRequestDTO requestDTO) {
        logger.info("피치 요청 공수교대 O");
        return gameService.pitchGame(requestDTO);
    }

    @GetMapping("/games/scores")
    public GameScoresResponseDTO viewGameScores() {
        logger.info("게임 상세 스코어 요청");
        return gameService.getGameScores();
    }

    @GetMapping("/games/scores/{teamName}")
    public List<MemberScoreDTO> viewGameScoreByTeam(@PathVariable String teamName) {
        logger.info("{}팀의 멤버 스코어 정보 요청", teamName);
        return gameService.getGameScoresByTeam(teamName);
    }
}
