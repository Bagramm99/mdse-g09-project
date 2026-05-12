package org.xtext.example.racespec.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.example.racespec.raceSpec.Event
import org.xtext.example.racespec.raceSpec.Competition
import org.xtext.example.racespec.raceSpec.SkiStage
import org.xtext.example.racespec.raceSpec.ShootingStage
import org.xtext.example.racespec.raceSpec.TimePenalty
import org.xtext.example.racespec.raceSpec.ExtraLapPenalty

class RaceSpecGenerator extends AbstractGenerator {

    override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
        for (event : resource.allContents.toIterable.filter(Event)) {
            val fileName = event.name.replace(" ", "_").replace("\"", "") + ".html"
            fsa.generateFile(fileName, event.toHtml)
        }
    }

    def toHtml(Event event) '''
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>«event.name»</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 40px;
                    background-color: #f7f7f7;
                    color: #222;
                }
                .container {
                    max-width: 1000px;
                    margin: auto;
                    background: white;
                    padding: 30px;
                    border-radius: 12px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                }
                h1 {
                    color: #1f4e79;
                    border-bottom: 2px solid #1f4e79;
                    padding-bottom: 10px;
                }
                h2 {
                    color: #2f6f4e;
                    margin-top: 30px;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 15px;
                }
                th, td {
                    border: 1px solid #ccc;
                    padding: 10px;
                    text-align: left;
                }
                th {
                    background-color: #1f4e79;
                    color: white;
                }
                .section {
                    margin-top: 25px;
                }
                .badge {
                    display: inline-block;
                    padding: 4px 8px;
                    background: #e8f0fe;
                    border-radius: 6px;
                    color: #1f4e79;
                    font-weight: bold;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>«event.name»</h1>

                <div class="section">
                    <p><strong>Location:</strong> «event.location»</p>
                    <p><strong>Total course length:</strong> «event.course.totalLength» km</p>
                    <p><strong>Firing positions:</strong> «event.course.firingPositions»</p>
                </div>

                <h2>Competitions</h2>

                «FOR competition : event.competitions»
                    «competition.toHtml»
                «ENDFOR»

                <div class="section">
                    <p><em>Generated automatically from RaceSpec DSL.</em></p>
                </div>
            </div>
        </body>
        </html>
    '''

    def toHtml(Competition competition) '''
        <div class="section">
            <h3>«competition.name»</h3>
            <p><span class="badge">«competition.type»</span></p>

            <table>
                <tr>
                    <th>Property</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Team size</td>
                    <td>«competition.teamSize»</td>
                </tr>
                <tr>
                    <td>Distance</td>
                    <td>«competition.distance» km</td>
                </tr>
                <tr>
                    <td>Max participants</td>
                    <td>«competition.maxParticipants»</td>
                </tr>
            </table>

            <h4>Stages</h4>
            <table>
                <tr>
                    <th>Stage</th>
                    <th>Details</th>
                    <th>Penalty</th>
                </tr>
                «FOR stage : competition.stages»
                    «IF stage instanceof SkiStage»
                        <tr>
                            <td>Ski</td>
                            <td>Distance: «(stage as SkiStage).distance» km</td>
                            <td>-</td>
                        </tr>
                    «ENDIF»
                    «IF stage instanceof ShootingStage»
                        <tr>
                            <td>Shooting</td>
                            <td>
                                Position: «(stage as ShootingStage).position»,
                                Targets: «(stage as ShootingStage).targetCount»
                            </td>
                            <td>
                                «(stage as ShootingStage).penalty.penaltyText»
                            </td>
                        </tr>
                    «ENDIF»
                «ENDFOR»
            </table>
        </div>
    '''

    def penaltyText(Object penalty) {
        if (penalty instanceof TimePenalty) {
            return "Time penalty: " + penalty.secondsPerMiss + " sec per miss"
        }

        if (penalty instanceof ExtraLapPenalty) {
            return "Extra lap: " + penalty.lapLength + " m"
        }

        return "-"
    }
}