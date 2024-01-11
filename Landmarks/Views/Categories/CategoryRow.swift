/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view showing a scrollable list of landmarks.
*/
import ComposableArchitecture
import SwiftUI

//struct CategoryRowFeature: Reducer {
//    
//    struct State: Equatable, Identifiable {
//        var id: UUID
//        var categoryName: String = ""
//        var landmarks: IdentifiedArrayOf<Landmark> = []
//        
//        init(id: UUID, categoryName: String, landmarks: IdentifiedArrayOf<Landmark>) {
//            self.id = id
//            self.categoryName = categoryName
//            self.landmarks = landmarks
//        }
//    }
//    
//    enum Action {
//        
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce {
//            state, action in
//            switch action {
//                
//            }
//        }
//    }
//}

struct CategoryRow: View {
    var categoryName: String
    var landmarks: [Landmark]

    var body: some View {
//        WithViewStore(self.store, observe: { $0 }) { viewStore in
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(landmarks) { landmark in
                        NavigationLink {
                        } label: {
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

//#Preview {
//    CategoryRow(categoryName: "River", landmarks: ModelData().landmarks)
//}
