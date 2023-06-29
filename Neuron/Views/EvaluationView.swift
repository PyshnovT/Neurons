import SwiftUI

struct EvaluationView: View {
    @ObservedObject var brain: Brain
    let data: [HouseData]

    var body: some View {
        VStack {
            Button("Evaluate Network / Get Learned Thoughts / Network Predictions") {
                let houses = [HouseData.random(),
                             HouseData.random(),
                             HouseData.random()]
                brain.learnedThoughts = brain.evaluateNetwork(withHouses: houses)
            }
            List {
                Section(header: Text("Unlearned Thoughts")) {
                    ForEach(brain.unlearnedThoughts) { thought in
                        HouseThoughtCell(thought: thought)
                    }
                }
                Section(header: Text("Learned Thoughts")) {
                    ForEach(brain.learnedThoughts) { thought in
                        HouseThoughtCell(thought: thought)
                    }
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
}

struct HouseThoughtCell: View {
    let thought: HouseThought
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Actual \(HouseData.formattedPrice(from: thought.data.value))")
                .padding(.bottom, -12)
            Text("Predicted \(HouseData.formattedPrice(from: thought.predictedValue))")
            Text("Difference \(HouseData.formattedPrice(from: abs(thought.predictedValue - thought.data.value)))")
                .fontWeight(.bold)
        }

    }
}
