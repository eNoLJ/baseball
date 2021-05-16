package com.eNoLJ.baseball.web.dto;

import java.util.List;

public class GameInfoResponseDTO {

    private final String playTeam;
    private final RoundInfoDTO roundInfo;
    private final OffenceTeamDTO OffenceTeam;
    private final DefenseTeamDTO defenseTeam;
    private final List<String> story;

    public GameInfoResponseDTO(String playTeam, RoundInfoDTO roundInfo, OffenceTeamDTO offenceTeam, DefenseTeamDTO defenseTeam, List<String> story) {
        this.playTeam = playTeam;
        this.roundInfo = roundInfo;
        OffenceTeam = offenceTeam;
        this.defenseTeam = defenseTeam;
        this.story = story;
    }

    public String getPlayTeam() {
        return playTeam;
    }

    public RoundInfoDTO getRoundInfo() {
        return roundInfo;
    }

    public OffenceTeamDTO getOffenceTeam() {
        return OffenceTeam;
    }

    public DefenseTeamDTO getDefenseTeam() {
        return defenseTeam;
    }

    public List<String> getStory() {
        return story;
    }
}
