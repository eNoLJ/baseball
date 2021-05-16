package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.domain.game.Game;
import com.eNoLJ.baseball.domain.game.GameRepository;
import com.eNoLJ.baseball.domain.hitterHistory.HitterHistory;
import com.eNoLJ.baseball.domain.inning.Inning;
import com.eNoLJ.baseball.domain.member.Member;
import com.eNoLJ.baseball.domain.pitcherHistory.PitcherHistory;
import com.eNoLJ.baseball.domain.scoreHistory.ScoreHistory;
import com.eNoLJ.baseball.domain.team.Team;
import com.eNoLJ.baseball.exception.EntityNotFoundException;
import com.eNoLJ.baseball.web.dto.*;
import com.eNoLJ.baseball.web.utils.Type;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

import static com.eNoLJ.baseball.web.dto.GameEntryDTO.createGameEntryDTO;

@Service
public class GameService {

    private final GameRepository gameRepository;

    public GameService(GameRepository gameRepository) {
        this.gameRepository = gameRepository;
    }

    public List<GameEntryDTO> getGameList() {
        return gameRepository.findAll().stream()
                .map(game -> createGameEntryDTO(game.getTeamByType(Type.HOME), game.getTeamByType(Type.AWAY)))
                .collect(Collectors.toList());
    }

    public List<MemberDTO> getMembersByTeamName(String teamName) {
        return findTeamByTeamName(teamName).getMembers().stream()
                .map(MemberDTO::createMemberDTO)
                .collect(Collectors.toList());
    }

    private Team findTeamByTeamName(String teamName) {
        return findAllTeam().stream()
                .filter(team -> team.verifyTeamName(teamName))
                .findFirst()
                .orElseThrow(EntityNotFoundException::new);
    }

    private List<Team> findAllTeam() {
        return this.gameRepository.findAll().stream()
                .map(Game::getTeams)
                .flatMap(Collection::stream)
                .collect(Collectors.toList());
    }

    public GameInfoResponseDTO startGameByTeamName(String teamName) {
        // game에 선택한 team name 넣기
        Game game = findGameByTeamName(teamName);
        game.choiceTeam(teamName);

        // score_history 만들기, 선공은 awayTeam
        ScoreHistory scoreHistory = ScoreHistory.createScoreHistory(game.getTeamByType(Type.AWAY));

        // hitter_history 만들기, member는 awayTeam의 첫번째 멤버
        Member hitterMember = findFirstMemberByGameAndType(game, Type.AWAY);
        HitterHistory hitterHistory = HitterHistory.createHitterHistory(hitterMember);

        // pitcher_history 만들기, member는 homeTeam의 첫번째 멤버
        Member pitcherMember = findFirstMemberByGameAndType(game, Type.HOME);
        PitcherHistory pitcherHistory = PitcherHistory.createPitcherHistory(pitcherMember);

        // inning 만들기
        Inning inning = Inning.createInning(scoreHistory, hitterHistory, pitcherHistory);
        game.addInning(inning);
        gameRepository.save(game);

        // DTO 만들기
        RoundInfoDTO roundInfoDTO = RoundInfoDTO.createRoundInfoDTO(inning);
        OffenceTeamDTO offenceTeamDTO = OffenceTeamDTO.createOffenceTeamDTO(game, HitterDTO.createHitterDTO(hitterMember, hitterHistory));
        DefenseTeamDTO defenseTeamDTO = DefenseTeamDTO.createDefenseTeamDTO(game, PitcherDTO.createPitcherDTO(pitcherMember, pitcherHistory));
        List<String> story = game.getSboHistoryByRecentInning();
        return new GameInfoResponseDTO(game.getChoiceTeamName(), roundInfoDTO, offenceTeamDTO, defenseTeamDTO, story);
    }

    private Game findGameByTeamName(String teamName) {
        return gameRepository.findAll().stream()
                .filter(game -> game.verifyTeamName(teamName))
                .findFirst()
                .orElseThrow(EntityNotFoundException::new);
    }

    private Member findFirstMemberByGameAndType(Game game, Type type) {
        return game.getTeamMembersByType(type).stream()
                .findFirst()
                .orElseThrow(EntityNotFoundException::new);
    }

    public GameInfoResponseDTO pitchGame(GameInfoRequestDTO requestDTO) {
        return new GameInfoResponseDTO(requestDTO.getPlayTeam(), requestDTO.getRoundInfo(), requestDTO.getOffenceTeam(), requestDTO.getDefenseTeam(), requestDTO.getStory());
    }

    public GameScoresResponseDTO getGameScores() {
        Game game = findGameById(1L);
        GameScoresDTO homeTeam = new GameScoresDTO(game.getTeamNameByType(Type.HOME), game.getTeamScoreListByType(Type.HOME));
        GameScoresDTO awayTeam = new GameScoresDTO(game.getTeamNameByType(Type.AWAY), game.getTeamScoreListByType(Type.AWAY));
        return new GameScoresResponseDTO(homeTeam, awayTeam);
    }

    private Game findGameById(Long id) {
        return gameRepository.findById(id).orElseThrow(EntityNotFoundException::new);
    }

    public List<MemberScoreDTO> getGameScoresByTeam(String teamName) {
        Game game = findGameByTeamName(teamName);
        return findTeamByTeamName(teamName).getMembers().stream()
                .map(member -> MemberScoreDTO.createMemberScoreDTO(member, game.getHitterHistoriesByMember(member)))
                .collect(Collectors.toList());
    }
}
