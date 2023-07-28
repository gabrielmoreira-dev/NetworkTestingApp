import Foundation

protocol HttpClientType<T> {
    associatedtype T: Decodable
    typealias Completion = (Result<T, ApiError>) -> Void
    
    func get(_ urlString: String, completion: @escaping Completion)
}

final class HttpClient<T: Decodable> {
    private let session: URLSessionType
    
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

extension HttpClient: HttpClientType {
    func get(_ urlString: String, completion: @escaping Completion) {
        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        performRequest(request, completion: completion)
    }
}

private extension HttpClient {
    func performRequest(_ request: URLRequest, completion: @escaping Completion) {
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
    
    func decode(data: Data, completion: @escaping Completion) {
        let decoded = try? JSONDecoder().decode(T.self, from: data)
        if let decoded = decoded {
            return completion(.success(decoded))
        }
        completion(.failure(.decodeError))
    }
}
