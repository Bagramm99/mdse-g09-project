# Domain Analysis — RaceSpec DSL

**Module:** Modellgetriebene Software Entwicklung (MDSE) · SoSe 2026 · Ostfalia University  
**Group:** GXX  
**Authors:** (Namen eintragen)  
**Date:** April 2026

---

## 1. Name of the DSL

**RaceSpec** — A Domain-Specific Language for Racing Sport Competitions

---

## 2. The Five Key Questions

### Q1: What does the DSL describe?

RaceSpec describes the configuration of amateur racing sport events.
A *RaceSpec* document captures all information needed to fully define a sporting event:
- **Event metadata:** name, location, year
- **Course layout:** total distance, number and placement of shooting ranges, available extra laps
- **Competitions:** one or more contests held at the event, each with a race type (individual or relay), distance, maximum number of participants, and team size
- **Stages:** the ordered sequence of segments within a competition — ski/running stages and shooting stages
- **Penalty rules:** what happens when a participant misses a target or violates a rule (time penalty or extra lap)
- **Start conditions:** how participants begin the race (interval start or mass wave start)

RaceSpec does **not** capture real-time race data, GPS tracking, results, or athlete profiles.

---

### Q2: Who are the users of the DSL?

| User Role | Usage |
|---|---|
| **Race Director / Organiser** | Primary user — defines and validates the full event configuration |
| **Referee / Judge** | Reads competition rules and penalty definitions for their section of the course |
| **Timekeeper / Timer** | Extracts start intervals, wave sizes, and penalty times |
| **Webmaster / Content Editor** | Uses generated output to publish event information on the race website |
| **Simulator** | Feeds the structured spec into a simulation to verify physical feasibility |

---

### Q3: What are the core concepts of the domain?

| Concept | Description |
|---|---|
| **Event** | The top-level sporting event (e.g. "Harz Mountain Winter 2025") with a location and year |
| **Course** | The physical race track — total length, number of shooting ranges, firing positions per range |
| **ShootingRange** | A single range along the course with optional extra lap lane and its length |
| **Competition** | A specific contest within the event (e.g. "Semi-professional Single"), with type, distance, and participant limit |
| **Stage** | One segment of a competition: either a **SkiStage** (skiing/running distance) or a **ShootingStage** |
| **ShootingStage** | A shooting segment with a specified body position (standing or laying) and associated penalty |
| **Penalty** | The consequence of a missed target: either a **TimePenalty** (seconds per miss, optional maximum) or an **ExtraLapPenalty** (lap distance in metres) |
| **StartCondition** | How participants start: **IntervalStart** (one by one, fixed gap in seconds) or **MassWaveStart** (groups of N, with a gap between waves) |
| **TeamSize** | Number of athletes per team — 1 for individual races, >1 for relay races |

---

### Q4: What is OUT of scope?

The following aspects are explicitly **not** part of RaceSpec:

- Real-time GPS tracking and live race monitoring
- Athlete registration, profiles, or personal data
- Payment processing and entry fees
- Anti-doping and WADA compliance
- Weather forecasting or course conditions
- Live result lists and scoring calculations
- Course mapping or geographic coordinates
- Equipment checks and technical regulations beyond rule violations

---

### Q5: What is the advantage over a General-Purpose Language (GPL)?

In a GPL such as Java or Python, specifying a single competition requires roughly 150–250 lines of boilerplate code (class definitions, constructors, validation logic, serialisation). The same information in RaceSpec fits in approximately 15–25 lines of structured, human-readable text.

Concrete advantages:

| Aspect | GPL (Java) | RaceSpec |
|---|---|---|
| Lines of code for one competition | ~150–200 | ~15–20 |
| Domain vocabulary | Generic (`int`, `String`) | Domain-specific (`standing`, `extraLap`, `massWave`) |
| Automatic validation | Manual implementation required | Built into the language via static semantics rules |
| Readable by non-programmers | No | Yes — race directors can write and review specs directly |
| Generation of web content | Manual serialisation needed | Automatic from the structured AST |

---

## 3. Own Examples

### Example 1: Harz Mountain Winter 2025 — Biathlon at Clausthal

The Harz Mountain Winter is a fictional annual event in the Harz mountains.
The main competition takes place on a circular course of 15 km between Clausthal and Altenau.
The course has four shooting ranges, each with 10 firing positions in parallel.
The first three ranges have an extra lap lane of 100 m; the fourth range offers no extra lap space.

**Competition A — Family and Friends Relay**

- Type: Relay, 4 team members
- Distance per member: 7.5 km
- Shooting 1: standing position; penalty: 15 seconds per missed target, maximum 45 seconds
- Shooting 2: laying position; penalty: 30 seconds per missed target, maximum 90 seconds
- Start condition: interval start, 30 seconds between teams
- Maximum participants: 50 teams

**Competition B — Semi-professional Single**

- Type: Individual race
- Distance: 15 km
- Shooting 1: standing — extra lap 100 m per miss
- Shooting 2: laying — extra lap 100 m per miss
- Shooting 3: standing — extra lap 100 m per miss
- Shooting 4: laying — time penalty 30 seconds per miss (no extra lap available)
- Start condition: interval start, 30 seconds between athletes
- Maximum participants: 200

**Competition C — Semi-professional Mass**

- Type: Individual race
- Distance: 15 km
- Shooting 1 & 2: standing — extra lap 100 m per miss
- Shooting 3 & 4: laying — shooting 4 with time penalty 30 seconds per miss
- Start condition: mass wave start, 20 participants per wave, 300 seconds between waves
- Maximum participants: 200

**Key RaceSpec concepts illustrated:**
- `ExtraLapPenalty` vs. `TimePenalty` depending on physical course constraints
- `IntervalStart` vs. `MassWaveStart` as two distinct start modes
- `Relay` vs. `Individual` competition types with different team size semantics

---

### Example 2: Wolfenbüttel Sprint Triathlon

The Wolfenbüttel Sprint Triathlon is a fictional urban triathlon held annually at the Oker lake.
It combines three disciplines in a fixed order and targets amateur athletes of all age groups.

**Event details:**
- Location: Wolfenbüttel, Niedersachsen
- Course: lake swim segment (750 m), road cycling loop (20 km), road running course (5 km)
- No shooting ranges; discipline transitions are handled as stage boundaries

**Competition — Sprint Triathlon Open**

- Type: Individual race
- Stages in order:
  1. Swim stage: 0.75 km (open water)
  2. Cycling stage: 20 km (road, draft-forbidden zone)
  3. Run stage: 5 km (road)
- Penalty rule: drafting violation during cycling → time penalty 2 minutes per infringement, maximum 4 minutes
- Start condition: mass wave start, 10 participants per wave, 120 seconds between waves
- Maximum participants: 300 athletes

**Why this example is useful for RaceSpec:**
- Shows that RaceSpec generalises beyond biathlon — any multi-stage race with penalties fits the model
- Introduces a purely time-penalty-based event with no shooting ranges
- Illustrates that `ShootingRange` count can be zero (course has no ranges)
- Shows that `TimePenalty` can be applied at the competition level by judges, not only at a `ShootingStage`

---

## 4. Inspiration from Reference Applications

Two existing race management applications were reviewed to inform the RaceSpec domain model:

**raceclocker.com** — focuses on timing and results management. Relevant observations:
- Events are structured as a collection of named races, each with a distance and category
- Participant limits and wave starts are first-class configuration options
- Time penalties are entered as fixed offsets on a per-participant basis

**webscorer.com** — a broader race management platform. Relevant observations:
- Supports interval and mass starts as distinct start types
- Penalty laps and time penalties are both supported as rule outcomes
- Race categories (age group, team vs. individual) are defined per competition, not per event

Both applications confirm that the concepts chosen for RaceSpec — `Competition`, `StartCondition`, `Penalty`, and `Stage` — represent the essential building blocks of amateur race management. RaceSpec differs by providing a *declarative specification language* rather than a web form interface, enabling automatic validation and content generation.