package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.hitterHistory.HitterHistory;
import com.eNoLJ.baseball.domain.member.Member;

import java.util.List;

public class MemberScoreDTO {

    private final Long id;
    private final String name;
    private final int TPA;
    private final int hits;
    private final int out;

    public MemberScoreDTO(Long id, String name, int TPA, int hits, int out) {
        this.id = id;
        this.name = name;
        this.TPA = TPA;
        this.hits = hits;
        this.out = out;
    }

    public static MemberScoreDTO createMemberScoreDTO(Member member, List<HitterHistory> hitterHistories) {
        return new MemberScoreDTO(member.getId(), member.getName(), totalTpaByHitterHistories(hitterHistories),
                totalHitsByHitterHistories(hitterHistories), totalOutByHitterHistories(hitterHistories));
    }

    private static int totalTpaByHitterHistories(List<HitterHistory> hitterHistories) {
        return hitterHistories.stream()
                .mapToInt(HitterHistory::getTpa)
                .sum();
    }

    private static int totalHitsByHitterHistories(List<HitterHistory> hitterHistories) {
        return hitterHistories.stream()
                .mapToInt(HitterHistory::getHits)
                .sum();
    }

    private static int totalOutByHitterHistories(List<HitterHistory> hitterHistories) {
        return hitterHistories.stream()
                .mapToInt(HitterHistory::getOut)
                .sum();
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getTPA() {
        return TPA;
    }

    public int getHits() {
        return hits;
    }

    public int getOut() {
        return out;
    }
}
