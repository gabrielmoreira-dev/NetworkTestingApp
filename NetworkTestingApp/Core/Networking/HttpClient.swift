import Foundation

protocol HttpClientType {
    typealias Completion<T: Decodable> = (Result<T, ApiError>) -> Void
    
    func get<T>(_ urlString: String, completion: @escaping Completion<T>)
}

final class HttpClient {
    private let session: URLSessionType
    
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

extension HttpClient: HttpClientType {
    func get<T>(_ urlString: String, completion: @escaping Completion<T>) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        performRequest(request, completion: completion)
    }
}

private extension HttpClient {
    func performRequest<T>(_ request: URLRequest, completion: @escaping Completion<T>) {
        session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                return completion(.failure(.serverError))
            }
            guard let data = data else {
                return completion(.failure(.emptyData))
            }
            
            self.decode(data: data, completion: completion)
        }.resume()
    }
    
    func decode<T>(data: Data, completion: @escaping Completion<T>) {
        let decoded = try? JSONDecoder().decode(T.self, from: data)
        if let decoded = decoded {
            return completion(.success(decoded))
        }
        completion(.failure(.decodeError))
    }
}
