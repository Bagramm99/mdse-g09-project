
# Static Semantics — RaceSpec DSL

**Module:** Modellgetriebene Software Entwicklung (MDSE) · SoSe 2026 · Ostfalia University  
**Group:** Gruppe9  
**Date:** April 2026

---

## Overview

This document defines the static semantic rules for the RaceSpec DSL.
Each rule is specified as a First-Order Logic (FOL) formula, accompanied by
an informal description and a concrete example of a violation.

---

## R1 — IndividualTeamSize

**FOL Formula:**
∀c ∈ Competition: c.type = "individual" ⟹ c.teamSize = 1

**Description:**
An individual race must have exactly one athlete per team.
If the competition type is set to "individual", the teamSize must be 1.

**Violation Example:**
```
competition "Solo Race" {
    type: individual
    teamSize: 4   -- ERROR: individual race cannot have teamSize 4
    ...
}
```

---

## R2 — RelayTeamSize

**FOL Formula:**
∀c ∈ Competition: c.type = "relay" ⟹ c.teamSize > 1

**Description:**
A relay race must have more than one athlete per team.
If the competition type is "relay", the teamSize must be at least 2.

**Violation Example:**
```
competition "Relay Race" {
    type: relay
    teamSize: 1   -- ERROR: relay race must have teamSize > 1
    ...
}
```

---

## R3 — DistanceConsistency

**FOL Formula:**
∀c ∈ Competition: Σ(s.distance | s ∈ c.stages, s isa SkiStage) = c.distance

**Description:**
The sum of all SkiStage distances must equal the declared total distance
of the competition.

**Violation Example:**
```
competition "Single Race" {
    type: individual
    distance: 15.0km   -- declared total
    stage ski(3.0km)
    stage ski(3.0km)
    stage ski(3.0km)   -- sum = 9.0km ≠ 15.0km -- ERROR
    ...
}
```

---

## R4 — PenaltyMaxMultiple

**FOL Formula:**
∀p ∈ TimePenalty: p.maxSeconds > 0 ⟹ p.maxSeconds % p.secondsPerMiss = 0

**Description:**
The maximum time penalty must be a positive integer multiple of the
per-miss penalty. This ensures the cap is always reachable.

**Violation Example:**
```
stage shooting(standing) {
    penalty: timePenalty(15sec max: 40sec)
    -- ERROR: 40 is not a multiple of 15
}
```

---

## R5 — ShootingStageCount

**FOL Formula:**
∀c ∈ Competition: |{s ∈ c.stages | s isa ShootingStage}| ≤ c.event.course.numRanges

**Description:**
The number of ShootingStages in a competition must not exceed the number
of shooting ranges defined in the course.

**Violation Example:**
```
course { length: 15.0km  shootingRanges: 2  firingPositions: 10 }
competition "Race" {
    stage shooting(standing) { penalty: extraLap(100.0m) }
    stage shooting(laying)   { penalty: extraLap(100.0m) }
    stage shooting(standing) { penalty: extraLap(100.0m) }
    stage shooting(laying)   { penalty: extraLap(100.0m) }
    -- ERROR: 4 ShootingStages but only 2 shootingRanges in course
}
```

---

## R6 — MassWaveValidity

**FOL Formula:**
∀s ∈ MassWaveStart: s.participantsPerWave > 0 ∧ s.waveIntervalSeconds > 0

**Description:**
A mass wave start must have a positive number of participants per wave
and a positive interval between waves.

**Violation Example:**
```
start: massWave(0 participants, 300sec)
-- ERROR: participantsPerWave must be > 0
```

