import SwiftUI

struct ContentView: View {
    @StateObject var brain = Brain()

    var body: some View {
        TabView {
            TrainingView(viewModel: TrainingViewModel(brain: brain))
                .tabItem {
                    Label("Train", systemImage: "train.side.front.car")
                }
            EvaluationView(brain: brain, data: HouseData.random(count: 500))
                .tabItem {
                    Label("Evaluation", systemImage: "wand.and.stars")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
