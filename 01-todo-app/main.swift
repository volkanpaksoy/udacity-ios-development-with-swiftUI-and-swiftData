import Foundation

// * Create the `Todo` struct.
// * Ensure it has properties: id (UUID), title (String), and isCompleted (Bool).
struct Todo : CustomStringConvertible, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool

    var description: String {
        return "\(isCompleted ? "✅" : "❌") \(title)"
    }
}

// Create the `Cache` protocol that defines the following method signatures:
//  `func save(todos: [Todo])`: Persists the given todos.
//  `func load() -> [Todo]?`: Retrieves and returns the saved todos, or nil if none exist.
protocol Cache {
    func save(todos: [Todo])
    func load() -> [Todo]?
}

// `FileSystemCache`: This implementation should utilize the file system 
// to persist and retrieve the list of todos. 
// Utilize Swift's `FileManager` to handle file operations.
final class JSONFileManagerCache: Cache {
    private let dbName = "todos.json"
    let fileManager = FileManager.default

    func save(todos: [Todo]) {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(todos)
            
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent(dbName)
                try jsonData.write(to: fileURL)
            }
        } catch {
            print("Error while saving the todo database: \(error)")
        }
    }

    func load() -> [Todo]? {
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(dbName)

            do {
                let contents: Data? = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)
                let decoder = JSONDecoder()
                let decodedTodoList = try decoder.decode([Todo].self, from: contents!)
                return decodedTodoList
            } catch {
                print("Error while loading the todo database: \(error)")
            }
        }

        return []
    }
}

// `InMemoryCache`: : Keeps todos in an array or similar structure during the session. 
// This won't retain todos across different app launches, 
// but serves as a quick in-session cache.
final class InMemoryCache: Cache {
    private var todoList: [Todo] = []

    func save(todos: [Todo]) {
        todoList = todos
    }

    func load() -> [Todo]? {
        return todoList
    }
}

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)` 
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
final class TodoManager {
    let cacheManager = InMemoryCache() // Can be swapped with JSONFileManagerCache() for disk persistance in JSON format 

    func addTodo(with title: String) {
        let newTodo = Todo(id: UUID(), title: title, isCompleted: false)
        var todoList = cacheManager.load() ?? [];
        todoList.append(newTodo)
        cacheManager.save(todos: todoList)
        print("📌 Todo added!")
    }

    func listTodos() {
        print("📝 Your Todos:")

        let todoList = cacheManager.load() ?? []
        for (index, todo) in todoList.enumerated() {
            print("\(index + 1). \(todo)")
        }
    }

    func toggleCompletion(forTodoAtIndex index: Int) {
         if todoExists(index - 1) == false {
            print("Invalid index. Please enter a valid index.")
            return    
        }
        
        var todoList = cacheManager.load() ?? [];
        todoList[index - 1].isCompleted = true
        cacheManager.save(todos: todoList)
        print("🔄 Todo completion status toggled!")
    }

    func deleteTodo(atIndex index: Int) {
        if todoExists(index - 1) == false {
            print("Invalid index. Please enter a valid index.")
            return    
        }
        
        var todoList = cacheManager.load() ?? [];
        todoList.remove(at: index - 1)
        cacheManager.save(todos: todoList)
        print("🗑️ Todo deleted!")
    }

    func todoExists(_ index: Int) -> Bool {
         let todoList = cacheManager.load() ?? [];
         return index >= 0 && index < todoList.count
    } 
}


// * The `App` class should have a `func run()` method, this method should perpetually 
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases 
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
final class App {

    let todoManager = TodoManager()

    enum Command : String {
        case add
        case list
        case toggle
        case delete
        case exit
    }

    func run() {
        var command: Command?

        repeat {
            print("What would you like to do? (add, list, toggle, delete, exit): ")
            let rawCommand: String? = readLine()
            command = Command(rawValue: rawCommand!)

            switch command {
                case .add:
                    print("Enter todo title:")
                    let title: String? = readLine()
                    todoManager.addTodo(with: title!)
                case .list:
                    todoManager.listTodos()
                case .toggle:
                    print("Enter the number of the todo to toggle:")
                    let todoIndexRaw: String? = readLine()
                    if let todoIndex = Int(todoIndexRaw!) {
                        todoManager.toggleCompletion(forTodoAtIndex: todoIndex)
                    } else {
                        print("Please enter a valid number.")
                    }
                case .delete:
                    print("Enter the number of the todo to delete:")
                    let todoIndexRaw: String? = readLine()
                    if let todoIndex = Int(todoIndexRaw!) {
                        todoManager.deleteTodo(atIndex: todoIndex)
                    } else {
                        print("Please enter a valid number.")
                    }
                case .exit:
                    print("✋ Thanks for using Todo CLI! See you next time!")

                case .none:
                    print ("Invalid command.")
            }
        } while command != Command.exit
    }

}


// TODO: Write code to set up and run the app.
print("🌟 Welcome to TODO CLI 🌟")

let app = App()
app.run()
