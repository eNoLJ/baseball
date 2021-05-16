package com.eNoLJ.baseball.domain.pitcherHistory;

import com.eNoLJ.baseball.domain.member.Member;
import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.List;

public class PitcherHistory {

    @Id
    private Long id;
    private int pit;
    private int strike;
    private int ball;
    private int out;
    private Long memberId;

    public PitcherHistory() {}

    public PitcherHistory(int pit, int strike, int ball, int out, Long memberId) {
        this.pit = pit;
        this.strike = strike;
        this.ball = ball;
        this.out = out;
        this.memberId = memberId;
    }

    public static PitcherHistory createPitcherHistory(Member member) {
        return new PitcherHistory(0, 0, 0, 0, member.getId());
    }

    public List<String> sboHistoryToString() {
        List<String> sboHistories = new ArrayList<>();
        if (strike == 1) {
            sboHistories.add("스트라이크");
        }
        if (ball == 1) {
            sboHistories.add("볼");
        }
        if (out == 1) {
            sboHistories.add("아웃");
        }
        return sboHistories;
    }

    public Long getId() {
        return id;
    }

    public int getPit() {
        return pit;
    }

    public int getStrike() {
        return strike;
    }

    public int getBall() {
        return ball;
    }

    public int getOut() {
        return out;
    }

    public Long getMemberId() {
        return memberId;
    }
}
