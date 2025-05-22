import Combine
import Foundation

/// An unimplemented version of the `JournalService`.
class LiveJournalService: JournalService {
    @Published private var token: Token?
    
    private let baseURL: URL = URL(string: "http://localhost:8000")!
    
    
    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }
    
    private func createURLRequest(path: String, method: String, isAuthenticationRequired: Bool = true, contentType: String = "application/json") throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        if isAuthenticationRequired {
            guard let authToken = token?.accessToken else {
                throw URLError(.userAuthenticationRequired)
            }
            
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    
    func register(username : String, password : String) async throws -> Token {
        var request = try createURLRequest(path: "register", method: "POST", isAuthenticationRequired: false)
                
        let body: [String: Any] = ["username": username, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let authToken = try jsonDecoder.decode(Token.self, from: data)
        self.token = authToken
        return authToken
    }

    func logIn(username : String, password : String) async throws -> Token {
        var request = try createURLRequest(path: "token", method: "POST", isAuthenticationRequired: false, contentType: "application/x-www-form-urlencoded")
        request.httpBody = "grant_type=&username=\(username)&password=\(password)".data(using: .utf8)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let authToken = try jsonDecoder.decode(Token.self, from: data)
        self.token = authToken
        return authToken
    }
    
    func logOut() {
        self.token = nil
    }

    
    
    func createTrip(with tripCreate: TripCreate) async throws -> Trip {
        var request = try createURLRequest(path: "trips", method: "POST")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        request.httpBody = try jsonEncoder.encode(tripCreate)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        let trip = try jsonDecoder.decode(Trip.self, from: data)
        return trip
    }

    func getTrips() async throws -> [Trip] {
        let request = try createURLRequest(path: "trips", method: "GET")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        let trips = try jsonDecoder.decode([Trip].self, from: data)
        return trips
    }

    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        let request = try createURLRequest(path: "trips/\(tripId)", method: "GET")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let trip = try jsonDecoder.decode(Trip.self, from: data)
        return trip
    }

    func updateTrip(withId tripId: Trip.ID, and tripUpdate: TripUpdate) async throws -> Trip {
        var request = try createURLRequest(path: "trips/\(tripId)", method: "PUT")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        request.httpBody = try jsonEncoder.encode(tripUpdate)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let trip = try jsonDecoder.decode(Trip.self, from: data)
        return trip
    }

    func deleteTrip(withId tripId: Trip.ID) async throws {
        let request = try createURLRequest(path: "trips/\(tripId)", method: "DELETE", contentType: "*/*")
        
        let _ = try await URLSession.shared.data(for: request)
    }

    
    
    func createEvent(with eventCreate: EventCreate) async throws -> Event {
        var request = try createURLRequest(path: "events", method: "POST")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        request.httpBody = try jsonEncoder.encode(eventCreate)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        let event = try jsonDecoder.decode(Event.self, from: data)
        return event
    }

    func updateEvent(withId eventId: Event.ID, and eventUpdate: EventUpdate) async throws -> Event {
        var request = try createURLRequest(path: "events/\(eventId)", method: "PUT")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        request.httpBody = try jsonEncoder.encode(eventUpdate)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let event = try jsonDecoder.decode(Event.self, from: data)
        return event
    }

    func deleteEvent(withId eventId: Event.ID) async throws {
        let request = try createURLRequest(path: "events/\(eventId)", method: "DELETE", contentType: "*/*")
        
        let _ = try await URLSession.shared.data(for: request)
    }

    
    
    func createMedia(with mediaCreate: MediaCreate) async throws -> Media {
        var request = try createURLRequest(path: "media", method: "POST")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        jsonEncoder.dateEncodingStrategy = .iso8601
        request.httpBody = try jsonEncoder.encode(mediaCreate)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        let media = try jsonDecoder.decode(Media.self, from: data)
        return media
    }

    func deleteMedia(withId mediaId: Media.ID) async throws {
        let request = try createURLRequest(path: "media/\(mediaId)", method: "DELETE", contentType: "*/*")
        
        let _ = try await URLSession.shared.data(for: request)
    }
}
