
# RaceSpec — A DSL for Racing Sport Competitions

**Module:** Modellgetriebene Software Entwicklung (MDSE) · SoSe 2026  
**University:** Ostfalia University of Applied Sciences  
**Group:** Gruppe9  
**Authors:** Durio Ngnimpea, (Partner eintragen)  
**Submission:** 31.05.2026  
**Repository:** https://gitlab-fi.ostfalia.de/lv/ami-ss26/gruppe9/racespec

---

## What is RaceSpec?

RaceSpec is a Domain-Specific Language for specifying amateur racing sport
events such as biathlon, triathlon, or duathlon. It allows race directors to
define courses, competitions, penalty rules, and start conditions in a concise,
human-readable format. Based on a RaceSpec file, web content and validation
reports can be generated automatically.

---

## Framework Decision

**Eclipse Xtext 2.42 + Ecore (EMF)** — chosen because:
- Xtext automatically generates an ANTLR parser from the grammar
- Ecore provides a native meta-model editor (no manual AST needed)
- Built-in validator integration via @Check annotations
- Better documentation and community support than Scala Parser Combinators

---

## Prerequisites

- Java JDK 17+
- Eclipse IDE for Java and DSL Developers (2024-03 or newer)
- Xtext 2.42 (included in Eclipse DSL edition)
- Git

---

## How to Run

1. Clone this repository:
   ```
   git clone https://gitlab-fi.ostfalia.de/lv/ami-ss26/gruppe9/racespec.git
   ```

2. Open Eclipse → File → Import → General → Existing Projects into Workspace
   → Select the cloned folder → Import all 5 projects

3. Generate Xtext artifacts:
   ```
   Right-click RaceSpec.xtext → Run As → Generate Xtext Artifacts
   ```

4. Open any `.racespec` file in Eclipse to see syntax highlighting and validation

5. Open invalid test files in `/test/` to see validator error messages

---

## Project Structure

| Folder | Content |
|---|---|
| `/docs` | DomainAnalysis.md, RaceSpecConcepts.md, StaticSemantics.md |
| `/metamodel` | RaceSpec.ecore, 3 XMI instance examples |
| `/grammar` | RaceSpec.xtext grammar definition |
| `/examples` | 3 valid .racespec example files |
| `/src` | RaceSpecValidator.java with 6 @Check rules |
| `/test` | 6 invalid .racespec test files (one per rule) |

---

## DSL Example

```
event "Harz Mountain Winter 2025" {
    location: "Clausthal-Altenau"
    year: 2025
    course {
        length: 15.0km
        shootingRanges: 4
        firingPositions: 10
    }
    competition "Semi-professional Single" {
        type: individual
        teamSize: 1
        distance: 15.0km
        maxParticipants: 200
        start: interval(30sec)
        stage ski(3.75km)
        stage shooting(standing) {
            penalty: extraLap(100.0m)
        }
        stage ski(3.75km)
        stage shooting(laying) {
            penalty: timePenalty(30sec)
        }
        stage ski(3.75km)
        stage shooting(standing) {
            penalty: extraLap(100.0m)
        }
        stage ski(3.75km)
        stage shooting(laying) {
            penalty: timePenalty(30sec)
        }
    }
}
```

---

## Static Semantics Rules

| Rule | Description |
|---|---|
| R1 IndividualTeamSize | Individual race must have teamSize = 1 |
| R2 RelayTeamSize | Relay race must have teamSize > 1 |
| R3 DistanceConsistency | Sum of stage distances must equal declared distance |
| R4 PenaltyMaxMultiple | Max penalty must be a multiple of per-miss penalty |
| R5 ShootingStageCount | Shooting stages must not exceed course shooting ranges |
| R6 MassWaveValidity | Mass wave start values must be positive |

---

## Deliverables Checklist

| File | Location | Done |
|---|---|---|
| DomainAnalysis.md | /docs | yes |
| RaceSpecConcepts.md | /docs | yes |
| StaticSemantics.md | /docs | yes |
| RaceSpec.ecore | /metamodel | yes |
| ast_familyfriends.xmi | /metamodel | yes |
| ast_semipro.xmi | /metamodel | yes |
| ast_eigenes.xmi | /metamodel | yes |
| RaceSpec.xtext | /grammar | yes |
| harz_familyfriends.racespec | /examples | yes |
| harz_semipro.racespec | /examples | yes |
| eigenes.racespec | /examples | yes |
| RaceSpecValidator.java | /src | yes |
| invalid_regel1.racespec | /test | yes |
| invalid_regel2.racespec | /test | yes |
| invalid_regel3.racespec | /test | yes |
| invalid_regel4.racespec | /test | yes |
| invalid_regel5.racespec | /test | yes |
| invalid_regel6.racespec | /test | yes |
| README.md | / | yes |