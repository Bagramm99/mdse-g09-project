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