import Combine

final class ProgressReporter: ObservableObject {
    
    struct LearningError: Identifiable {
        var id: Int { epoch }
        let epoch: Int
        let error: Float
    }
    
    @MainActor
    func setData(newData: [LearningError]) async {
        data = newData
    }
    
    @MainActor
    func setFinished(_ finished: Bool) async {
        self.finished = finished
    }
    
    @Published var data: [LearningError] = []
    
    @Published var finished = false
    
}
