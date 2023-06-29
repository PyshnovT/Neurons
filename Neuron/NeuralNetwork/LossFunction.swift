import Foundation

enum LossFunction {
    case mse
}

extension LossFunction {
    
    func loss(forExpected expected: [Float], predicted: [Float]) -> Float {
        let squaredDifference = zip(expected, predicted)
            .map { expected, predicted in
                pow(expected - predicted, 2.0)
            }
        
        // calculate average
        return squaredDifference.reduce(0, +) / Float(predicted.count)
    }
    
    func derivative(expected: [Float], predicted: [Float]) -> Float {
        let dirrerence = zip(expected, predicted)
            .map { expected, predicted in
                2 * (expected - predicted)
            }
        
        let sum = dirrerence.reduce(0, +)
        return -(sum / Float(expected.count))
    }
    
}
