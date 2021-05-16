package com.eNoLJ.baseball.domain.inning;

import com.eNoLJ.baseball.domain.hitterHistory.HitterHistory;
import com.eNoLJ.baseball.domain.member.Member;
import com.eNoLJ.baseball.domain.pitcherHistory.PitcherHistory;
import com.eNoLJ.baseball.domain.scoreHistory.ScoreHistory;
import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

public class Inning {

    @Id
    private Long id;
    private int round;
    private boolean firstBase;
    private boolean secondBase;
    private boolean thirdBase;
    private List<ScoreHistory> scoreHistories = new ArrayList<>();
    private List<HitterHistory> hitterHistories = new ArrayList<>();
    private List<PitcherHistory> pitcherHistories = new ArrayList<>();

    public Inning() {}

    public Inning(int round, boolean firstBase, boolean secondBase, boolean thirdBase) {
        this.round = round;
        this.firstBase = firstBase;
        this.secondBase = secondBase;
        this.thirdBase = thirdBase;
    }

    public static Inning createInning(ScoreHistory scoreHistory, HitterHistory hitterHistory, PitcherHistory pitcherHistory) {
        Inning inning = new Inning(1, false, false, false);
        inning.addScoreHistory(scoreHistory);
        inning.addHitterHistory(hitterHistory);
        inning.addPitcherHistory(pitcherHistory);
        return inning;
    }

    public List<String> getSboHistory() {
        return pitcherHistories.stream()
                .map(PitcherHistory::sboHistoryToString)
                .flatMap(Collection::stream)
                .collect(Collectors.toList());
    }

    public int getTotalScoreByTeamId(Long teamId) {
        return this.scoreHistories.stream()
                .filter(scoreHistory -> scoreHistory.verifyScoreHistoryByTeamId(teamId))
                .mapToInt(ScoreHistory::getInningScore)
                .sum();
    }

    public List<HitterHistory> getHitterHistoriesByMember(Member member) {
        return hitterHistories.stream()
                .filter(hitterHistory -> hitterHistory.verifyMember(member))
                .collect(Collectors.toList());
    }

    public void addScoreHistory(ScoreHistory scoreHistory) {
        this.scoreHistories.add(scoreHistory);
    }

    public void addHitterHistory(HitterHistory hitterHistory) {
        this.hitterHistories.add(hitterHistory);
    }

    public void addPitcherHistory(PitcherHistory pitcherHistory) {
        this.pitcherHistories.add(pitcherHistory);
    }

    public int getStrikeCount() {
        return this.pitcherHistories.stream()
                .mapToInt(PitcherHistory::getStrike)
                .sum();
    }

    public int getBallCount() {
        return this.pitcherHistories.stream()
                .mapToInt(PitcherHistory::getBall)
                .sum();
    }

    public int getOutCount() {
        return this.pitcherHistories.stream()
                .mapToInt(PitcherHistory::getOut)
                .sum();
    }

    public Long getId() {
        return id;
    }

    public int getRound() {
        return round;
    }

    public boolean isFirstBase() {
        return firstBase;
    }

    public boolean isSecondBase() {
        return secondBase;
    }

    public boolean isThirdBase() {
        return thirdBase;
    }

    public List<ScoreHistory> getScoreHistories() {
        return scoreHistories;
    }

    public List<HitterHistory> getHitterHistories() {
        return hitterHistories;
    }

    public List<PitcherHistory> getPitcherHistories() {
        return pitcherHistories;
    }
}
