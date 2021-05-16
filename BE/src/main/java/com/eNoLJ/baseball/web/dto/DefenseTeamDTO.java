package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.game.Game;
import com.eNoLJ.baseball.web.utils.Type;

public class DefenseTeamDTO {

    private final String teamName;
    private final int score;
    private final PitcherDTO pitcher;

    public DefenseTeamDTO(String teamName, int score, PitcherDTO pitcher) {
        this.teamName = teamName;
        this.score = score;
        this.pitcher = pitcher;
    }

    public static DefenseTeamDTO createDefenseTeamDTO(Game game, PitcherDTO pitcher) {
        return new DefenseTeamDTO(game.getTeamNameByType(Type.HOME), game.getTeamScoreByType(Type.HOME), pitcher);
    }

    public String getTeamName() {
        return teamName;
    }

    public int getScore() {
        return score;
    }

    public PitcherDTO getPitcher() {
        return pitcher;
    }
}
