import ComposableArchitecture

struct GetCategoryLandmarksClient {
    var fetch: (_ landmarks: IdentifiedArrayOf<Landmark>) async -> Dictionary<String, [IdentifiedArrayOf<Landmark>.Element]>
}

extension GetCategoryLandmarksClient: DependencyKey {
    static var liveValue: GetCategoryLandmarksClient = Self { landmarks in
        return Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
}

extension DependencyValues {
    var getCategoryLandmarks : GetCategoryLandmarksClient{
        get  {
            self[GetCategoryLandmarksClient.self]
        }
        
        set {
            self [GetCategoryLandmarksClient.self] = newValue
        }
    }
}

