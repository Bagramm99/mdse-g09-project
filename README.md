# RaceSpec — A DSL for Racing Sport Competitions

**Module:** Modellgetriebene Software Entwicklung (MDSE) · SoSe 2026  
**Group:** Gruppe9  
**Authors:** Durio Ngnimpea, (Partner eintragen)  
**Repository:** https://gitlab-fi.ostfalia.de/lv/ami-ss26/gruppe9/racespec

## What is RaceSpec?

RaceSpec is a Domain-Specific Language for specifying amateur racing sport
events such as biathlon, triathlon, or duathlon. It allows race directors to
define courses, competitions, penalty rules, and start conditions in a concise,
human-readable format. Based on a RaceSpec file, web content and validation
reports can be generated automatically.

## Framework Decision

**Eclipse Xtext + Ecore** — chosen because:
- Xtext automatically generates an ANTLR parser from the grammar
- Ecore provides a native meta-model editor (no manual AST needed)
- Built-in validator integration via @Check annotations
- Better documentation and community support than Scala Parser Combinators

## Prerequisites

- Java JDK 17+
- Eclipse IDE for Java and DSL Developers (includes Xtext)
- Git

## Project Structure

| Folder | Content |
|---|---|
| /docs | Documentation files (DomainAnalysis.md, Concepts, StaticSemantics) |
| /metamodel | Ecore meta-model (.ecore, .xmi instances) |
| /grammar | Xtext grammar definition (.xtext) |
| /examples | Valid .racespec example files |
| /src | Validator implementation (Java) |
| /test | Invalid .racespec test files (one per rule) |

## How to Run

1. Clone this repository
2. Open Eclipse → File → Import → Existing Projects into Workspace
3. Right-click RaceSpec.xtext → Run As → Generate Xtext Artifacts
4. Open any .racespec file in Eclipse to see syntax highlighting and validation