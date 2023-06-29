final class NeuralNetwork {
    let layers: [Layer]
    
    init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        self.layers = [
            Layer(inputSize: inputSize, outputSize: hiddenSize, activation: .sigmoid),
            Layer(inputSize: hiddenSize, outputSize: outputSize, activation: .sigmoid)
        ]
    }
    
}

extension NeuralNetwork {
    
    // MARK: - Activation
    
    func predict(input: [Float]) -> [Float] {
        forward(data: input)
    }
    
    private func forward(data: [Float]) -> [Float] {
        layers.reduce(data) { layerInputs, layer in
            layer.forward(inputs: layerInputs)
        }
    }
    
}

extension NeuralNetwork {
    
    // MARK: - Back Propagation
    
    func backward(errors: [Float], learningRate: Float) {
        var errors = errors
        for layer in layers.reversed() {
            errors = layer.backward(errors: errors, learningRate: learningRate)
        }
    }
    
}

extension NeuralNetwork {
    
    // MARK: - Training
    
    func train(
        featureInput: [[Float]],
        targetOutput: [[Float]],
        epochs: Int,
        learingRate: Float,
        loss: LossFunction,
        reporter: ProgressReporter
    ) {
        Task {
            await reporter.setFinished(false)
            
            var learningErrors: [ProgressReporter.LearningError] = []
            
            for epoch in 0..<epochs {
                var averageEpochError: Float = 0
                
                for (featureIndex, features) in featureInput.enumerated() {
                    let outputs = forward(data: features)
                    let expected = targetOutput[featureIndex]
                    
                    let error = loss.loss(forExpected: expected, predicted: outputs)
                    
                    // Total error is just for our reporting
                    averageEpochError += (error / 2.0)
                    
                    let derivativeError = loss.derivative(expected: expected, predicted: outputs)
                    
                    backward(errors: [derivativeError], learningRate: learingRate)
                }
                
                let errorToReport = ProgressReporter.LearningError(epoch: epoch, error: averageEpochError)
                learningErrors.append(errorToReport)
                let errorsToReport = learningErrors

                await reporter.setData(newData: errorsToReport)
            }
            
            await reporter.setFinished(true)
        }
    }
    
}
