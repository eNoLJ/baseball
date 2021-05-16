package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.hitterHistory.HitterHistory;
import com.eNoLJ.baseball.domain.member.Member;

public class HitterDTO {

    private final String name;
    private final double AVG;
    private final int TPA;
    private final int hits;

    public HitterDTO(String name, double AVG, int TPA, int hits) {
        this.name = name;
        this.AVG = AVG;
        this.TPA = TPA;
        this.hits = hits;
    }

    public static HitterDTO createHitterDTO(Member member, HitterHistory hitterHistory) {
        return new HitterDTO(member.getName(), member.getAvg(), hitterHistory.getTpa(), hitterHistory.getHits());
    }

    public String getName() {
        return name;
    }

    public double getAVG() {
        return AVG;
    }

    public int getTPA() {
        return TPA;
    }

    public int getHits() {
        return hits;
    }
}
