/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import ComposableArchitecture
import SwiftUI

struct LandmarkDetailFeature: Reducer {
    struct State: Equatable {
        var landmark: Landmark
        var addToFavoriteState = FavoriteButtonFeature.State()
        var isLandmarkFeatured = false
    }
    enum Action {
        case initStates
        case toggleFavorite(FavoriteButtonFeature.Action)
        case toggleFeatured
        case delegate(Delegate)
        
        enum Delegate {
            case addLandmarkToFavorite(landmark: Landmark)
            case removeLandmarkFromFavorite(landmark: Landmark)
            case addToFeaturedlandmark(landmark: Landmark)
            case removeFromFeaturedLandmark(landmark: Landmark)
        }
    }
    var body: some ReducerOf<Self> {
        Scope(
            state: \.addToFavoriteState,
            action: /LandmarkDetailFeature.Action.toggleFavorite
        ){
            FavoriteButtonFeature()
        }
        Reduce {
            state, action in
            switch action {
            case .toggleFavorite(.isFavoriteTapped):
                if state.addToFavoriteState.isFavorite {
                    state.landmark.isFavorite = true
                    return .send(.delegate(.addLandmarkToFavorite(landmark: state.landmark)))
                } else {
                    state.landmark.isFavorite = false
                    return .send(.delegate(.removeLandmarkFromFavorite(landmark: state.landmark)))
                }
            case .toggleFeatured:
                state.isLandmarkFeatured.toggle()
                if state.isLandmarkFeatured {
                    state.landmark.isFeatured = true
                    return .send(.delegate(.addToFeaturedlandmark(landmark: state.landmark)))
                } else {
                    state.landmark.isFeatured = false
                    return .send(.delegate(.removeFromFeaturedLandmark(landmark: state.landmark)))
                }
            case .delegate:
                return .none
            case .initStates:
                state.addToFavoriteState.isFavorite = state.landmark.isFavorite
                state.isLandmarkFeatured = state.landmark.isFeatured
                return .none
            }
        }
    }
}

struct LandmarkDetail: View {
    let store: StoreOf<LandmarkDetailFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                MapView(coordinate: viewStore.landmark.locationCoordinate)
                    .frame(height: 300)
                
                CircleImage(image: viewStore.landmark.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(viewStore.landmark.name)
                            .font(.title)
                    
                        Button(viewStore.isLandmarkFeatured ? "Featured":"Not Featured")
                        {
                            viewStore.send(.toggleFeatured)
                        }
                        .foregroundColor(viewStore.isLandmarkFeatured ? .blue : .gray)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(3)
                        .border(viewStore.isLandmarkFeatured ? .blue: .gray)
                        
                        FavoriteButton(
                            store: self.store.scope(
                                state: \.addToFavoriteState,
                                action: LandmarkDetailFeature.Action.toggleFavorite
                            )
                        ).onAppear {
                            viewStore.send(.initStates)
                        }
                    }
                    
                    HStack {
                        Text(viewStore.landmark.park)
                        Spacer()
                        Text(viewStore.landmark.state)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Text("About \(viewStore.landmark.name)")
                        .font(.title2)
                    Text(viewStore.landmark.description)
                }
                .padding()
            }
            .navigationTitle(viewStore.landmark.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LandmarkDetail(
        store: Store(
            initialState: LandmarkDetailFeature.State(landmark: ModelData().landmarks[1])
        ) {
            LandmarkDetailFeature()
    })
}
