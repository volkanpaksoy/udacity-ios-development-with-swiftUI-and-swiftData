import SwiftData
import SwiftUI

struct CategoriesView: View {
  @Environment(\.modelContext) private var context
  @State private var query = ""
  @Query var categories: [Category]
  private var filteredCategories: [Category] {
    let categoriesPredicate = #Predicate<Category> {
        $0.name.localizedStandardContains(query)
    }
    
    let descriptor = FetchDescriptor<Category>(
      predicate: query.isEmpty ? nil : categoriesPredicate
    )
    
    do {
        let filteredCategories = try context.fetch(descriptor)
        return filteredCategories
    } catch {
        return []
    }
  }
    
  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Categories")
        .toolbar {
          if !categories.isEmpty {
            NavigationLink(value: CategoryForm.Mode.add) {
              Label("Add", systemImage: "plus")
            }
          }
        }
        .navigationDestination(for: CategoryForm.Mode.self) { mode in
          CategoryForm(mode: mode)
        }
        .navigationDestination(for: RecipeForm.Mode.self) { mode in
          RecipeForm(mode: mode)
        }
    }
  }

  // MARK: - Views

  @ViewBuilder
  private var content: some View {
    if categories.isEmpty {
      empty
    } else {
      list(for: filteredCategories)
    }
  }

  private var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Categories", systemImage: "list.clipboard")
      },
      description: {
        Text("Categories you add will appear here.")
      },
      actions: {
        NavigationLink("Add Category", value: CategoryForm.Mode.add)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
      }
    )
  }

  private var noResults: some View {
    ContentUnavailableView(
      label: {
        Text("Couldn't find \"\(query)\"")
      }
    )
  }

  private func list(for categories: [Category]) -> some View {
    ScrollView(.vertical) {
      if categories.isEmpty {
        noResults
      } else {
        LazyVStack(spacing: 10) {
          ForEach(categories, content: CategorySection.init)
        }
      }
    }
    .searchable(text: $query)
  }
}
