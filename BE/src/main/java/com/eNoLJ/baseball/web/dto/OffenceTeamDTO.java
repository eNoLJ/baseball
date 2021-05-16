package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.game.Game;
import com.eNoLJ.baseball.web.utils.Type;

public class OffenceTeamDTO {

    private final String teamName;
    private final int score;
    private final HitterDTO hitter;

    public OffenceTeamDTO(String teamName, int score, HitterDTO hitter) {
        this.teamName = teamName;
        this.score = score;
        this.hitter = hitter;
    }

    public static OffenceTeamDTO createOffenceTeamDTO(Game game, HitterDTO hitter) {
        return new OffenceTeamDTO(game.getTeamNameByType(Type.AWAY), game.getTeamScoreByType(Type.AWAY), hitter);
    }

    public String getTeamName() {
        return teamName;
    }

    public int getScore() {
        return score;
    }

    public HitterDTO getHitter() {
        return hitter;
    }
}
