import Foundation
import CreateML
import CreateMLUI
import Cocoa

print("here")
let dataset = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/LordDavid/Desktop/FYP/AlcoholMonitor/AlcoholMonitor/testSubjects.json"))
print("done")
print(dataset)
let (trainingData, testingData) = dataset.randomSplit(by: 0.8) // we split the data as we want data for training and data for testing 80% of the data should be used for training and the remaining 20% to make sure training is working - takes random selection for the data table result to do so
print(dataset)
let metadata = MLModelMetadata(author: "David Donnellan", shortDescription: "This model analyzes alcohol consumed to actual BAC", version: "1.0") //used to store model info in coreML

//CREATING CLASSIFIER
let AnalysisRegressor = try MLRegressor(trainingData: trainingData, targetColumn:"testlarge")

let evaluationMetrics = AnalysisRegressor.evaluation(on: testingData)
print(evaluationMetrics.rootMeanSquaredError)
print(evaluationMetrics.maximumError)

do {
    try AnalysisRegressor.write(to: URL(fileURLWithPath:
        "/Users/LordDavid/Desktop/FYP/AlcoholMonitor/BACResults.mlmodel"), metadata: metadata)
} catch {
    print("Something went wrong, please try again!")
}

