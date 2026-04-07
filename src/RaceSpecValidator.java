package org.xtext.racespec.validation;

import org.eclipse.xtext.validation.Check;
import org.xtext.racespec.raceSpec.Competition;
import org.xtext.racespec.raceSpec.Event;
import org.xtext.racespec.raceSpec.MassWaveStart;
import org.xtext.racespec.raceSpec.ShootingStage;
import org.xtext.racespec.raceSpec.SkiStage;
import org.xtext.racespec.raceSpec.Stage;
import org.xtext.racespec.raceSpec.TimePenalty;

public class RaceSpecValidator extends AbstractRaceSpecValidator {

    // R1 — IndividualTeamSize
    @Check
    public void checkIndividualTeamSize(Competition c) {
        if ("individual".equals(c.getType()) && c.getTeamSize() != 1) {
            error("Individual competition must have teamSize = 1.",
                c, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.COMPETITION__TEAM_SIZE);
        }
    }

    // R2 — RelayTeamSize
    @Check
    public void checkRelayTeamSize(Competition c) {
        if ("relay".equals(c.getType()) && c.getTeamSize() <= 1) {
            error("Relay competition must have teamSize > 1.",
                c, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.COMPETITION__TEAM_SIZE);
        }
    }

    // R3 — DistanceConsistency
    @Check
    public void checkDistanceConsistency(Competition c) {
        double sum = 0.0;
        for (Stage s : c.getStages()) {
            if (s instanceof SkiStage) {
                sum += ((SkiStage) s).getDistance();
            }
        }
        double declared = c.getDistance();
        if (Math.abs(sum - declared) > 0.001) {
            error("Sum of stage distances (" + sum + " km) does not match declared distance (" + declared + " km).",
                c, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.COMPETITION__DISTANCE);
        }
    }

    // R4 — PenaltyMaxMultiple
    @Check
    public void checkPenaltyMaxMultiple(TimePenalty p) {
        if (p.getMaxSeconds() > 0 && p.getMaxSeconds() % p.getSecondsPerMiss() != 0) {
            error("Maximum penalty (" + p.getMaxSeconds() + " sec) must be a multiple of per-miss penalty (" + p.getSecondsPerMiss() + " sec).",
                p, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.TIME_PENALTY__MAX_SECONDS);
        }
    }

    // R5 — ShootingStageCount
    @Check
    public void checkShootingStageCount(Competition c) {
        long count = c.getStages().stream()
            .filter(s -> s instanceof ShootingStage)
            .count();
        Event event = (Event) c.eContainer();
        int ranges = event.getCourse().getNumRanges();
        if (count > ranges) {
            error("Number of shooting stages (" + count + ") exceeds number of shooting ranges in course (" + ranges + ").",
                c, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.COMPETITION__STAGES);
        }
    }

    // R6 — MassWaveValidity
    @Check
    public void checkMassWaveValidity(MassWaveStart s) {
        if (s.getParticipantsPerWave() <= 0) {
            error("participantsPerWave must be greater than 0.",
                s, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.MASS_WAVE_START__PARTICIPANTS_PER_WAVE);
        }
        if (s.getWaveIntervalSeconds() <= 0) {
            error("waveIntervalSeconds must be greater than 0.",
                s, org.xtext.racespec.raceSpec.RaceSpecPackage.Literals.MASS_WAVE_START__WAVE_INTERVAL_SECONDS);
        }
    }
}