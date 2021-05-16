package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.member.Member;

public class MemberDTO {

    private Long id;
    private String name;
    private double AVG;

    public MemberDTO(Long id, String name, double AVG) {
        this.id = id;
        this.name = name;
        this.AVG = AVG;
    }

    public static MemberDTO createMemberDTO(Member member) {
        return new MemberDTO(member.getId(), member.getName(), member.getAvg());
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public double getAVG() {
        return AVG;
    }
}
