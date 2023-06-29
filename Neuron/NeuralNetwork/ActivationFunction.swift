import Foundation

enum ActivationFunction {
    case sigmoid
    case blank
    
    func forward(x: Float) -> Float {
        switch self {
        case .sigmoid:
            return 1 / (1 + exp(-x))
        case .blank:
            return x * 1
        }
    }
    
    func derivative(x: Float) -> Float {
        switch self {
        case .sigmoid:
            return x * (1 - x)
        case .blank:
            return 1
        }
    }
}
