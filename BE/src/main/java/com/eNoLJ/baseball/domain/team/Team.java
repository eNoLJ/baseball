package com.eNoLJ.baseball.domain.team;

import com.eNoLJ.baseball.domain.member.Member;
import com.eNoLJ.baseball.web.utils.Type;
import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.List;

public class Team {

    @Id
    private Long id;
    private String name;
    private Type type;
    private List<Member> members = new ArrayList<>();

    public boolean verifyTeamName(String teamName) {
        return this.name.equals(teamName);
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Type getType() {
        return type;
    }

    public List<Member> getMembers() {
        return members;
    }
}
