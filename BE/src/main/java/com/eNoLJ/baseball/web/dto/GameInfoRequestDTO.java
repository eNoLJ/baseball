package com.eNoLJ.baseball.web.dto;

import java.util.List;

public class GameInfoRequestDTO {

    private String playTeam;
    private RoundInfoDTO roundInfo;
    private OffenceTeamDTO OffenceTeam;
    private DefenseTeamDTO defenseTeam;
    private List<String> story;

    public GameInfoRequestDTO(String playTeam, RoundInfoDTO roundInfo, OffenceTeamDTO offenceTeam, DefenseTeamDTO defenseTeam, List<String> story) {
        this.playTeam = playTeam;
        this.roundInfo = roundInfo;
        OffenceTeam = offenceTeam;
        this.defenseTeam = defenseTeam;
        this.story = story;
    }

    public String getPlayTeam() {
        return playTeam;
    }

    public void setPlayTeam(String playTeam) {
        this.playTeam = playTeam;
    }

    public RoundInfoDTO getRoundInfo() {
        return roundInfo;
    }

    public void setRoundInfo(RoundInfoDTO roundInfo) {
        this.roundInfo = roundInfo;
    }

    public OffenceTeamDTO getOffenceTeam() {
        return OffenceTeam;
    }

    public void setOffenceTeam(OffenceTeamDTO offenceTeam) {
        OffenceTeam = offenceTeam;
    }

    public DefenseTeamDTO getDefenseTeam() {
        return defenseTeam;
    }

    public void setDefenseTeam(DefenseTeamDTO defenseTeam) {
        this.defenseTeam = defenseTeam;
    }

    public List<String> getStory() {
        return story;
    }

    public void setStory(List<String> story) {
        this.story = story;
    }
}
