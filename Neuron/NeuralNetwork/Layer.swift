final class Layer {
    var neurons: [Neuron] = []
    var inputSize = 0
    var activation: ActivationFunction
    
    init(inputSize: Int = 0, outputSize: Int, activation: ActivationFunction) {
        for _ in 0 ..< outputSize {
            let neuron = Neuron(
                weightCount: inputSize,
                activation: activation
            )
            neurons.append(neuron)
        }
        
        self.inputSize = inputSize
        self.activation = activation
    }
}

extension Layer {
    
    // MARK: - Activation
    
    func forward(inputs: [Float]) -> [Float] {
        var newInputs: [Float] = []
        
        for neuron in neurons {
            let activationValue = neuron.activate(inputs: inputs)
            newInputs.append(activationValue)
        }
        
        return newInputs
    }
    
}

extension Layer {
    
    // MARK: - Back Propagation
    
    func backward(errors: [Float], learningRate: Float) -> [Float] {
        // Here we prepare errors that we will pass to the layer behind us.
        var errorsForPreviousLayer: [Float] = Array(repeating: 0, count: inputSize)
        
        for (neuronIndex, neuron) in neurons.enumerated() {
            let error = errors[neuronIndex]
            
            // The neurons wil update their weigths with the errors,
            // and also update the errors that will be passed to the previous layer.
            errorsForPreviousLayer = neuron.backward(
                error: error,
                learningRate: learningRate,
                errorsForPreviousLayer: errorsForPreviousLayer
            )
        }
        
        // Finally, we pass those errors to the layer behind us.
        return errorsForPreviousLayer
    }
    
}
