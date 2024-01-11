/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing featured landmarks above a list of all of the landmarks.
*/

import ComposableArchitecture
import SwiftUI

enum Tab {
    case featured
    case list
}

struct AppViewFeature: Reducer {
    struct State {
        var routes = StackState<Routes.State>()
        var globalLandmarks: IdentifiedArrayOf<Landmark> = []
        
        var landmarkList = LandmarkListFeature.State()
        var categoryHome = CategoryHomeFeature.State()
        
        var currentTab = Tab.list
    }
    
    enum Action {
        case fetchLandmarks
        case changeCurrentTab(Tab)
        case updateLandmarks(IdentifiedArrayOf<Landmark>)
        case landmarksUpdated
        case routes(StackAction<Routes.State, Routes.Action>)
        
        case landmarkList(LandmarkListFeature.Action)
        case categoryHome(CategoryHomeFeature.Action)
    }
    
    @Dependency(\.getLandmarks) var getLandmarks

    var body: some ReducerOf<Self> {
        Scope(state: \.landmarkList, action: /Action.landmarkList) {
            LandmarkListFeature()
        }
        Scope(state: \.categoryHome, action: /Action.categoryHome) {
            CategoryHomeFeature()
        }
        Reduce {
            state, action in
            switch action {
            case let .routes(.element(id: _, action: .landmarkDetail(.delegate(action)))):
                switch action {
                case let .addLandmarkToFavorite(landmark):
                    state.globalLandmarks[id: landmark.id] = landmark
                    return .none
                case let .removeLandmarkFromFavorite(landmark):
                    state.globalLandmarks[id: landmark.id] = landmark
                    return .none
                case let .addToFeaturedlandmark(landmark):
                    state.globalLandmarks[id: landmark.id] = landmark
                    return .none
                case let .removeFromFeaturedLandmark(landmark):
                    state.globalLandmarks[id: landmark.id] = landmark
                    return .none
                    
                }
            case let .changeCurrentTab(tab):
                state.currentTab = tab
                return .none
            case .routes:
                return .none
            case .landmarkList:
                return .none
            case .landmarksUpdated:
                state.landmarkList.landmarkList = state.globalLandmarks
                state.categoryHome.landmarks = state.globalLandmarks
                return .none
            case let .updateLandmarks(landmarks):
                state.globalLandmarks = landmarks
                return .none
            case .fetchLandmarks:
                return .run { send in
                    let landmarks = await getLandmarks.fetch()
                    await send(.updateLandmarks(landmarks))
                }
            case .categoryHome:
                return .none
            }
        }
        .forEach(\.routes, action: /Action.routes) {
            Routes()
        }
        .onChange(of: \.globalLandmarks) {
            oldValue, newValue in
            Reduce {
                state, action in
                    .send(.landmarksUpdated)
            }
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppViewFeature>
    var body: some View {
        WithViewStore(self.store, observe: \.currentTab) { viewStore in
            NavigationStackStore(
                self.store.scope(
                    state: \.routes,
                    action: { .routes($0) }
                )
            ) {
                TabView(
                    selection: viewStore.binding(send: AppViewFeature.Action.changeCurrentTab)
                ) {
                    LandmarkList(
                        store: self.store.scope(
                            state: \.landmarkList,
                            action: { .landmarkList($0) }
                        )
                    ).tabItem {
                        Label("List", systemImage: "list.bullet")
                    }.tag(Tab.list)
                    
                    CategoryHome(
                        store: self.store.scope(
                            state: \.categoryHome,
                            action: { .categoryHome($0) }
                        )
                    )
                    .tabItem {
                        Label("Featured", systemImage: "star")
                    }
                    .tag(Tab.featured)

                }
                
            } destination: { state in
                switch state {
                case .landmarkDetail:
                    CaseLet(
                        /Routes.State.landmarkDetail,
                         action: Routes.Action.landmarkDetail,
                         then: LandmarkDetail.init(store:)
                    )
                }
            }
            .task {
                viewStore.send(.fetchLandmarks)
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppViewFeature.State()
        ) {
            AppViewFeature()
        }
    ).environment(ModelData())
}
