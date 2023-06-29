final class Neuron {
    var weights: [Float]
    var bias: Float
    var inputCache: [Float] = []
    var outputCache: Float = 0
    var activation: ActivationFunction
    
    init(weightCount: Int, activation: ActivationFunction) {
        self.activation = activation
        self.bias = Float.random(in: 0..<1)
        
        var weights: [Float] = []
        for _ in 0 ..< weightCount {
            weights.append(Float.random(in: 0..<1))
        }
        
        self.weights = weights
    }
}

extension Neuron {
    
    // MARK: - Activation
    
    func activate(inputs: [Float]) -> Float {
        var value = bias
        
        for (index, weight) in weights.enumerated() {
            value += weight * inputs[index]
        }
        
        value = activation.forward(x: value)
        
        outputCache = value
        inputCache = inputs
        
        return value
    }
    
}

extension Neuron {
    
    // MARK: - Back Propagation
    
    func backward(error: Float, learningRate: Float, errorsForPreviousLayer: [Float]) -> [Float] {
        var errorsToPassBackward = errorsForPreviousLayer
        
        let outputDerivativeError = error * activation.derivative(x: outputCache)
        
        // The index of the weight will correspond to the index of the neuron in the previous layer.
        for (weightIndex, weight) in weights.enumerated() {
            errorsToPassBackward[weightIndex] += outputDerivativeError * weight
        }
        
        // Now that we have that error, we can update the weights of our current neuron
        for (inputIndex, input) in inputCache.enumerated() {
            var currentWeight = weights[inputIndex]
            currentWeight -= learningRate * outputDerivativeError * input
            weights[inputIndex] = currentWeight
        }
        
        bias -= learningRate * outputDerivativeError
        
        return errorsToPassBackward
    }
    
}
