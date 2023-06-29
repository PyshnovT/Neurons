import Combine
import Foundation

final class Brain: ObservableObject {
    
    var network: NeuralNetwork = NeuralNetwork(inputSize: 0, hiddenSize: 0, outputSize: 0)
    
    @Published var learnedThoughts: [HouseThought] = []
    @Published var unlearnedThoughts: [HouseThought] = []
    
    init() {
        initializeNetwork()
    }
    
    private func initializeNetwork() {
        self.network = NeuralNetwork(inputSize: 3, hiddenSize: 7, outputSize: 1)
        let houses = [HouseData.random(),
                      HouseData.random(),
                      HouseData.random()]
        unlearnedThoughts = evaluateNetwork(withHouses: houses)
    }
    
    func clearNetwork() {
        initializeNetwork()
    }
    
    func evaluateNetwork(withHouses houses: [HouseData]) -> [HouseThought] {
        houses.map { house in
            let resultList = network.predict(input: house.trainingData.features)
            let predictedValue = resultList[0]
            
            return HouseThought(data: house, predictedValue: predictedValue)
        }
    }
    
    func learn(from data: [HouseData], reporter: ProgressReporter) {
        let featureData = data.map(\.trainingData.features)
        let targetData = data.map(\.trainingData.targets)
        
        let epochs = 100
        let learningRate: Float = 0.1
        
        network.train(featureInput: featureData,
                      targetOutput: targetData,
                      epochs: epochs,
                      learingRate: learningRate,
                      loss: .mse,
                      reporter: reporter)
    }
    
}

struct HouseThought: Identifiable {
    let id = UUID()
    var data: HouseData
    let predictedValue: Float
}
