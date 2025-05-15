import SwiftUI
import SwiftData

@main
struct SwiftBitesApp: App {
  
    @State private var modelContainer: ModelContainer = {
      let schema = Schema([Ingredient.self, Category.self, Recipe.self, RecipeIngredient.self])
      let configuration = ModelConfiguration()
      return try! ModelContainer(for: schema, configurations: configuration)
    }()
    
    var body: some Scene {
      WindowGroup {
        ContentView()
          .modelContainer(modelContainer)
    }
  }
}
