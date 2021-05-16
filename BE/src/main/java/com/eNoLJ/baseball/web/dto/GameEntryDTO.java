package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.team.Team;

public class GameEntryDTO {

    private final String homeTeamName;
    private final String awayTeamName;

    public GameEntryDTO(String homeTeamName, String awayTeamName) {
        this.homeTeamName = homeTeamName;
        this.awayTeamName = awayTeamName;
    }

    public static GameEntryDTO createGameEntryDTO(Team homeTeam, Team awayTeam) {
        return new GameEntryDTO(homeTeam.getName(), awayTeam.getName());
    }

    public String getHomeTeamName() {
        return homeTeamName;
    }

    public String getAwayTeamName() {
        return awayTeamName;
    }
}
