import Foundation

/// House data for neurons to calculate on.
struct HouseData {
    /// Normalized neighborhood quality with values between 0 and 1.
    let neighborhoodQuality: Float
    
    /// Normalized number of rooms with values between 0 and 1
    /// where 0 equals one room and 1 equals ten rooms.
    let numberOfRooms: Float
    
    /// Normalized square footage with values between 0 and 1
    /// where 0 equals five hundred square footage and 1 equals ten thousand square footage.
    let squareFootage: Float
    
    /// Normalized house value with values between 0 and 1.
    /// We use a custom formula to calculate this parameter and take
    /// neighborhood quality, number of rooms, and squre footage as inputs.
    var value: Float
}

extension HouseData {
    
    var trainingData: (features: [Float], targets: [Float]) {
        (
            features: [neighborhoodQuality, numberOfRooms, squareFootage],
            targets: [value]
        )
    }
    
}

extension HouseData {
    
    /// Calculates value from the inputs and creates house data.
    init(
        neighborhoodQuality: Float,
        numberOfRooms: Float,
        squareFootage: Float
    ) {
        self.init(
            neighborhoodQuality: neighborhoodQuality,
            numberOfRooms: numberOfRooms,
            squareFootage: squareFootage,
            value: HouseData.calculateValue(neighborhoodQuality: neighborhoodQuality,
                                            numberOfRooms: numberOfRooms,
                                            squareFootage: squareFootage))
    }
    
    /// Calculates value from the inputs and returns a house value.
    static func calculateValue(
        neighborhoodQuality: Float,
        numberOfRooms: Float,
        squareFootage: Float
    ) -> Float {
        let neighborhoodQualityCoefficient: Float = 0.25
        let numberOfRoomsCoefficient: Float = 0.35
        let squareFootageCoefficient: Float = 0.4
        
        var value: Float = 0
        value += neighborhoodQuality * neighborhoodQualityCoefficient
        value += numberOfRooms * numberOfRoomsCoefficient
        value += squareFootage * squareFootageCoefficient
        
        return value
    }
    
}

extension HouseData {
    
    /// Makes a random house with normalized parameters.
    static func random() -> Self {
        // calculate square footage
        let maxSquareFootage: Float = 10000.0
        let minSquareFootage: Float = 500.0
        let squareFootage = Float.random(in: minSquareFootage..<maxSquareFootage)
        
        // scale between 0 and 1
        let normalizedSquareFootage = (squareFootage - minSquareFootage) / (maxSquareFootage - minSquareFootage)
        
        // neighborhood
        let neighborhoodQuality = Float.random(in: 0..<1)
        
        // rooms
        let maxNumberOfRooms = 10
        let minNumberOfRooms = 1
        let numberOfRooms = Int.random(in: 1..<10)
        
        // scale between 0 and 1
        let normalizedRooms = Float(numberOfRooms - minNumberOfRooms) / Float(maxNumberOfRooms - minNumberOfRooms)
        
        return HouseData(neighborhoodQuality: neighborhoodQuality,
                         numberOfRooms: normalizedRooms,
                         squareFootage: normalizedSquareFootage)
    }
    
}

extension HouseData {
    
    /// Price in dollars. We just multiply `value` by a million.
    var price: Int {
        HouseData.price(from: value)
    }
    
    var formattedPrice: String {
        HouseData.formattedPrice(from: value)
    }
    
    static let priceFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        currencyFormatter.maximumSignificantDigits = 4
        return currencyFormatter
    }()
    
    static func formattedPrice(from value: Float) -> String {
        let nsNumber = NSNumber(value: price(from: value))
        let priceString = priceFormatter.string(from: nsNumber) ?? "invalid number"
        return priceString
    }
    
    /// Price in dollars. We just multiply `value` by a million.
    static func price(from value: Float) -> Int {
        Int(value * 100000)
    }
    
}

extension HouseData {
    
    /// Creates data for `count` houses.
    static func random(count: Int) -> [Self] {
        var results: [HouseData] = []
        
        for _ in 0..<count {
            results.append(.random())
        }
        
        return results
    }
    
}
