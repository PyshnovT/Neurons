import SwiftUI
import Charts

final class TrainingViewModel: ObservableObject {
    
    @Published var brain: Brain
    
    init(brain: Brain) {
        self.brain = brain
    }
    
    let initialData = HouseData.random(count: 500)
    
}

struct TrainingView: View {
    
    @ObservedObject var viewModel: TrainingViewModel
    @StateObject var reporter = ProgressReporter()
    
    var body: some View {
        VStack {
            Text("Finshed Training: \(String(reporter.finished))")
                .font(.title)
                .padding()
            
            Chart(reporter.data) { trainingError in
                LineMark(
                    x: .value("Epoch", trainingError.epoch),
                    y: .value("Total Error", trainingError.error)
                )
            }
            .chartXAxisLabel("Epochs")
            .chartYAxisLabel("Learning Error")
            .padding()
            
            HStack {
                Button("Train") {
                    viewModel.brain.learn(from: viewModel.initialData,
                                          reporter: reporter)
                }
                Button("Rebuild Network/Start over") {
                    viewModel.brain.clearNetwork()
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
}
