package com.eNoLJ.baseball.web.dto;

import java.util.List;

public class GameScoresDTO {

    private final String teamName;
    private final List<Integer> scores;

    public GameScoresDTO(String teamName, List<Integer> scores) {
        this.teamName = teamName;
        this.scores = scores;
    }

    public String getTeamName() {
        return teamName;
    }

    public List<Integer> getScores() {
        return scores;
    }
}
