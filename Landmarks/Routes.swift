import ComposableArchitecture

struct Routes: Reducer {
    enum State {
        case landmarkDetail(LandmarkDetailFeature.State)
    }
    
    enum Action  {
        case landmarkDetail(LandmarkDetailFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: /State.landmarkDetail, action: /Action.landmarkDetail) {
            LandmarkDetailFeature()
        }
    }
}
