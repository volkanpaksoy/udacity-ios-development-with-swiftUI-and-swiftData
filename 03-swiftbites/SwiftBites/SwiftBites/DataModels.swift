import Foundation
import SwiftData

@Model
class Category: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var recipes: [Recipe]
    
    init(id: UUID = UUID(), name: String, recipes: [Recipe] = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class Ingredient: Identifiable, Hashable {
    var id = UUID()
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class RecipeIngredient: Identifiable, Hashable {
    var id = UUID()
    var ingredient: Ingredient
    var quantity: String
    
    init(ingredient: Ingredient, quantity: String) {
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class Recipe: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var summary: String
    var category: Category?
    var serving: Int
    var time: Int
    var instructions: String
    var imageData: Data?
    
    @Relationship(deleteRule: .cascade)
    var ingredients: [RecipeIngredient]
    
    init(id: UUID = UUID(),
         name: String = "",
         summary: String = "",
         category: Category? = nil,
         serving: Int = 1,
         time: Int = 5,
         ingredients: [RecipeIngredient] = [],
         instructions: String = "",
         imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
