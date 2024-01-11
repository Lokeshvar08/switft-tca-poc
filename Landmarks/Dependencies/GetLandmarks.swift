import ComposableArchitecture

struct GetLandmarksClient {
    var fetch: () async -> IdentifiedArrayOf<Landmark>
}

extension GetLandmarksClient: DependencyKey {
    static var liveValue: GetLandmarksClient = Self {
        return ModelData().landmarks
    }
}

extension DependencyValues {
    var getLandmarks : GetLandmarksClient{
        get  {
            self[GetLandmarksClient.self]
        }
        
        set {
            self [GetLandmarksClient.self] = newValue
        }
    }
}
