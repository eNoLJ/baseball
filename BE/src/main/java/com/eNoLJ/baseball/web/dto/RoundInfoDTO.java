package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.inning.Inning;

public class RoundInfoDTO {

    private final int round;
    private final int strike;
    private final int ball;
    private final int out;
    private final boolean firstBase;
    private final boolean secondBase;
    private final boolean thirdBase;

    public RoundInfoDTO(int round, int strike, int ball, int out, boolean firstBase, boolean secondBase, boolean thirdBase) {
        this.round = round;
        this.strike = strike;
        this.ball = ball;
        this.out = out;
        this.firstBase = firstBase;
        this.secondBase = secondBase;
        this.thirdBase = thirdBase;
    }

    public static RoundInfoDTO createRoundInfoDTO(Inning inning) {
        return new RoundInfoDTO(inning.getRound(), inning.getStrikeCount(), inning.getBallCount(),
                inning.getOutCount(), inning.isFirstBase(), inning.isSecondBase(), inning.isThirdBase());
    }

    public int getRound() {
        return round;
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

    public boolean isFirstBase() {
        return firstBase;
    }

    public boolean isSecondBase() {
        return secondBase;
    }

    public boolean isThirdBase() {
        return thirdBase;
    }
}
