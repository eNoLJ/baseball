package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.member.Member;
import com.eNoLJ.baseball.domain.pitcherHistory.PitcherHistory;

public class PitcherDTO {

    private final String name;
    private final int pit;

    public PitcherDTO(String name, int pit) {
        this.name = name;
        this.pit = pit;
    }

    public static PitcherDTO createPitcherDTO(Member member, PitcherHistory pitcherHistory) {
        return new PitcherDTO(member.getName(), pitcherHistory.getPit());
    }

    public String getName() {
        return name;
    }

    public int getPit() {
        return pit;
    }
}
