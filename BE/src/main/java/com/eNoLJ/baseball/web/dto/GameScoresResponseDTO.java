package com.eNoLJ.baseball.web.dto;

public class GameScoresResponseDTO {

    private final GameScoresDTO homeTeam;
    private final GameScoresDTO awayTeam;

    public GameScoresResponseDTO(GameScoresDTO homeTeam, GameScoresDTO awayTeam) {
        this.homeTeam = homeTeam;
        this.awayTeam = awayTeam;
    }

    public GameScoresDTO getHomeTeam() {
        return homeTeam;
    }

    public GameScoresDTO getAwayTeam() {
        return awayTeam;
    }
}
