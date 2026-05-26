# RaceSpec Concepts — Glossary

**Module:** Modellgetriebene Software Entwicklung (MDSE) · SoSe 2026 · Ostfalia University  
**Group:** Gruppe9  
**Authors:** Durio Ngnimpea and Dhia Filfel
**Date:** Mai 2026

---

## Overview

This document describes all concepts (EClasses), their attributes, and their relations in the RaceSpec meta-model. Each concept corresponds to one EClass in `RaceSpec.ecore`.

---

## 1. Event

**Description:** The top-level concept representing a complete sporting event. An Event has a name, a location, and a year. It owns exactly one Course and at least one Competition.

| Attribute | Type | Description |
|---|---|---|
| `name` | EString | The official name of the event (e.g. "Harz Mountain Winter 2025") |
| `location` | EString | The city or venue where the event takes place |
| `year` | EInt | The calendar year of the event |

| Association | Type | Multiplicity | Description |
|---|---|---|---|
| `course` | Course | 1..1 | The physical race track used by all competitions |
| `competitions` | Competition | 1..* | One or more competitions held at this event |

---

## 2. Course

**Description:** Represents the physical race track. A Course has a total length and a number of firing positions per shooting range. It may contain zero or more ShootingRanges along the track.

| Attribute | Type | Description |
|---|---|---|
| `totalLength` | EDouble | Total length of the course in kilometres |
| `firingPositions` | EInt | Number of parallel firing positions at each shooting range |

| Association | Type | Multiplicity | Description |
|---|---|---|---|
| `shootingRanges` | ShootingRange | 0..* | All shooting ranges positioned along the course |

---

## 3. ShootingRange

**Description:** A single shooting range positioned along the Course. Each ShootingRange may or may not have an adjacent extra lap lane for penalty laps. If no extra lap is available, a time penalty must be used instead.

| Attribute | Type | Description |
|---|---|---|
| `rangeId` | EInt | Unique identifier of this range (e.g. 1, 2, 3, 4) |
| `hasExtraLap` | EBoolean | True if an extra lap lane is available next to this range |
| `extraLapLength` | EDouble | Length of the extra lap in metres (only relevant if hasExtraLap = true) |

---

## 4. Competition

**Description:** A specific contest held within an Event. A Competition has a type (Individual or Relay), a total distance, a maximum number of participants, and a team size. It consists of an ordered sequence of Stages and exactly one StartCondition.

| Attribute | Type | Description |
|---|---|---|
| `name` | EString | The name of the competition (e.g. "Semi-professional Single") |
| `distance` | EDouble | Total race distance in kilometres |
| `maxParticipants` | EInt | Maximum number of participants or teams allowed |
| `teamSize` | EInt | Number of athletes per team (1 for individual, >1 for relay) |

| Association | Type | Multiplicity | Description |
|---|---|---|---|
| `stages` | Stage | 1..* | The ordered sequence of stages in this competition |
| `startCondition` | StartCondition | 1..1 | How participants are started (interval or mass wave) |

---

## 5. Stage *(abstract)*

**Description:** Abstract base concept for a single segment within a Competition. A Stage is either a SkiStage (skiing or running) or a ShootingStage. Stages are ordered and together define the full structure of a competition.

*No attributes — defined by subclasses.*

| Subclass | Description |
|---|---|
| `SkiStage` | A skiing or running segment with a given distance |
| `ShootingStage` | A shooting segment with a position and a penalty rule |

---

## 6. SkiStage

**Description:** A skiing or running segment within a Competition. Inherits from Stage. Represents one continuous movement phase between two shooting ranges (or between start/finish and a shooting range).

| Attribute | Type | Description |
|---|---|---|
| `distance` | EDouble | Length of this ski or running segment in kilometres |

*Inherits from:* `Stage`

---

## 7. ShootingStage

**Description:** A shooting segment within a Competition. Inherits from Stage. Specifies the required body position (Standing or Laying) and the penalty applied for each missed target.

| Attribute | Type | Description |
|---|---|---|
| `targetCount` | EInt | Number of targets to shoot at this stage |
| `position` | EString | Required shooting position: "standing" or "laying" |

| Association | Type | Multiplicity | Description |
|---|---|---|---|
| `penalty` | Penalty | 1..1 | The penalty applied for each missed target |

*Inherits from:* `Stage`

---

## 8. Penalty *(abstract)*

**Description:** Abstract base concept for a penalty rule applied when a participant misses a shooting target. A Penalty is either a TimePenalty (fixed time added) or an ExtraLapPenalty (extra distance to run).

*No attributes — defined by subclasses.*

| Subclass | Description |
|---|---|
| `TimePenalty` | A fixed number of seconds added per missed target |
| `ExtraLapPenalty` | An extra lap of a given distance to be run per missed target |

---

## 9. TimePenalty

**Description:** A penalty where a fixed number of seconds is added to the participant's total time for each missed target. An optional maximum cap limits the total penalty regardless of how many targets are missed.

| Attribute | Type | Description |
|---|---|---|
| `secondsPerMiss` | EInt | Seconds added to total time per missed target |
| `maxSeconds` | EInt | Maximum total time penalty in seconds (0 = no limit) |

*Inherits from:* `Penalty`

---

## 10. ExtraLapPenalty

**Description:** A penalty where the participant must run an extra lap of a defined length for each missed target before re-entering the main course.

| Attribute | Type | Description |
|---|---|---|
| `lapLength` | EDouble | Length of the extra lap in metres (e.g. 100.0) |

*Inherits from:* `Penalty`

---

## 11. StartCondition *(abstract)*

**Description:** Abstract base concept for how participants begin a competition. A StartCondition is either an IntervalStart (participants start one by one at fixed intervals) or a MassWaveStart (groups of participants start together in waves).

*No attributes — defined by subclasses.*

| Subclass | Description |
|---|---|
| `IntervalStart` | One participant (or team) starts every N seconds |
| `MassWaveStart` | Groups of N participants start together at fixed wave intervals |

---

## 12. IntervalStart

**Description:** A start condition where participants begin the race one at a time, separated by a fixed interval in seconds. Commonly used in biathlon individual and relay races.

| Attribute | Type | Description |
|---|---|---|
| `intervalSeconds` | EInt | Time gap in seconds between consecutive starters |

*Inherits from:* `StartCondition`

---

## 13. MassWaveStart

**Description:** A start condition where a defined number of participants start simultaneously in a wave, with a fixed time gap between successive waves. Used in mass-start biathlon and triathlon events.

| Attribute | Type | Description |
|---|---|---|
| `participantsPerWave` | EInt | Number of participants starting together in each wave |
| `waveIntervalSeconds` | EInt | Time gap in seconds between consecutive waves |

*Inherits from:* `StartCondition`

---

## Inheritance Hierarchy

```
Stage (abstract)
├── SkiStage
└── ShootingStage

Penalty (abstract)
├── TimePenalty
└── ExtraLapPenalty

StartCondition (abstract)
├── IntervalStart
└── MassWaveStart
```

---

## Containment Relations Overview

```
Event
├── course : Course [1]
│   └── shootingRanges : ShootingRange [0..*]
└── competitions : Competition [1..*]
    ├── stages : Stage [1..*]
    │   └── penalty : Penalty [1]   (only ShootingStage)
    └── startCondition : StartCondition [1]
```