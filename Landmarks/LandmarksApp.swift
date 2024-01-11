/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The top-level definition of the Landmarks app.
*/

import ComposableArchitecture
import SwiftUI

@main
struct LandmarksApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(
                    initialState: AppViewFeature.State()
                ) {
                    AppViewFeature()
                }
            )
                .environment(modelData)
        }
    }
}
