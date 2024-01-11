/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A button that acts as a favorites indicator.
*/

import ComposableArchitecture
import SwiftUI

struct FavoriteButtonFeature: Reducer {
    struct State: Equatable {
        var isFavorite: Bool = false
    }
    enum Action {
        case isFavoriteTapped
    }
    var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            switch action {
            case .isFavoriteTapped:
                state.isFavorite.toggle()
                return .none
            }
        }
    }
}

struct FavoriteButton: View {
    let store: StoreOf<FavoriteButtonFeature>
    
    var body: some View {
        WithViewStore(
            self.store, observe: { $0 }
        ) { viewStore in
            Button {
                viewStore.send(.isFavoriteTapped)
            } label: {
                Label("Toggle Favorite", systemImage: viewStore.isFavorite ? "star.fill" : "star")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(viewStore.isFavorite ? .yellow : .gray)
            }
        }
    }
}

#Preview {
    FavoriteButton(        
        store: Store(
            initialState: FavoriteButtonFeature.State(isFavorite: true)
        ) {
            FavoriteButtonFeature()._printChanges()
    })
}
