/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import ComposableArchitecture
import SwiftUI

struct LandmarkListFeature: Reducer {
    struct State : Equatable {
        var landmarkList: IdentifiedArrayOf<Landmark> = []
        var showFavoritesOnlyToggle: Bool =  false
    }
    
    enum Action {
        case showFavoritesOnlyToggleTapped(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            switch action {
            case let .showFavoritesOnlyToggleTapped(isEnabled):
                state.showFavoritesOnlyToggle =  isEnabled
                return .none
            }
        }
    }
}

struct LandmarkList: View {
    let store: StoreOf<LandmarkListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            let filteredLandmark = viewStore.landmarkList.filter { landmark in
                !viewStore.showFavoritesOnlyToggle || landmark.isFavorite
            }
            
            List {
                Toggle(
                    isOn: viewStore.binding(
                        get: \.showFavoritesOnlyToggle,
                        send: LandmarkListFeature.Action.showFavoritesOnlyToggleTapped
                    )
                ) {
                    Text("Favorites only")
                }
                
                ForEach(filteredLandmark) { landmark in
                    NavigationLink(
                        state: Routes.State.landmarkDetail(
                            LandmarkDetailFeature.State(landmark: landmark)
                        )) {
                            LandmarkRow(landmark: landmark)
                        }
                }
            }
            .animation(.default, value: filteredLandmark)
            .navigationTitle("Landmarks")
        }
    
    }
}

#Preview {
    NavigationStack {
        LandmarkList( store: Store(
            initialState: LandmarkListFeature.State(landmarkList: ModelData().landmarks)
        ) {
            LandmarkListFeature()
        })
    }
}
