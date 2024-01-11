/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing featured landmarks above a list of landmarks grouped by category.
*/

import ComposableArchitecture
import SwiftUI

struct CategoryHomeFeature: Reducer {
    struct State: Equatable {
        var landmarks: IdentifiedArrayOf<Landmark> = []
        var categoryLandmarks: Dictionary<String, [IdentifiedArrayOf<Landmark>.Element]> = [:]
    
//        var categoryRows: IdentifiedArrayOf<CategoryRowFeature.State> = []
    }
    
    @Dependency(\.getCategoryLandmarks) var getCategoryLandmarks
    @Dependency(\.uuid) var uuid
    
    enum Action {
        case fetchCategorizedLandmarks
        case updateCategoryLandmarks(Dictionary<String, [IdentifiedArrayOf<Landmark>.Element]>)
//        case categoryRows(id: CategoryRowFeature.State.ID, action: CategoryRowFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            switch action {
            case .fetchCategorizedLandmarks:
                return .run { [landmarks = state.landmarks] send in
                    let categorylandmarks = await getCategoryLandmarks.fetch(landmarks)
                    await send(.updateCategoryLandmarks(categorylandmarks))
                }
            case let .updateCategoryLandmarks(landmarks):
                state.categoryLandmarks = landmarks
                return .none
//            case .categoryRows:
//                return .none
            }
        }
        .onChange(of: \.landmarks) {
            oldVaue, newValue in
            Reduce {
                state, action in
                return .send(.fetchCategorizedLandmarks)
            }
        }
//        .forEach(\.categoryRows, action: /Action.categoryRows(id:action:)) {
//            CategoryRowFeature()
//        }
    }
}

struct CategoryHome: View {
    let store: StoreOf<CategoryHomeFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            var features: [Landmark] {
                viewStore.landmarks.filter { $0.isFeatured }
            }
            let featured = features.count != 0 ? features[0] : viewStore.landmarks.randomElement()
            
            let category = viewStore.categoryLandmarks
            
            List {
                featured?.image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())

                ForEach(category.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, landmarks: category[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Featured")
            .onAppear {
                viewStore.send(.fetchCategorizedLandmarks)
            }
        }
    }
}

#Preview {
    CategoryHome(
        store: Store(initialState: CategoryHomeFeature.State(landmarks: ModelData().landmarks)) {
            CategoryHomeFeature()
        }
    )
}
