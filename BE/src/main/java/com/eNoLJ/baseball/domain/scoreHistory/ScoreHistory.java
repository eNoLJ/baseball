package com.eNoLJ.baseball.domain.scoreHistory;

import com.eNoLJ.baseball.domain.team.Team;
import org.springframework.data.annotation.Id;

public class ScoreHistory {

    @Id
    private Long id;
    private int inningScore;
    private Long teamId;

    public ScoreHistory() {}

    public ScoreHistory(int inningScore, Long teamId) {
        this.inningScore = inningScore;
        this.teamId = teamId;
    }

    public static ScoreHistory createScoreHistory(Team team) {
        return new ScoreHistory(0, team.getId());
    }

    public boolean verifyScoreHistoryByTeamId(Long teamId) {
        return this.teamId.equals(teamId);
    }

    public Long getId() {
        return id;
    }

    public int getInningScore() {
        return inningScore;
    }

    public Long getTeamId() {
        return teamId;
    }
}
