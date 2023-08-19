import Foundation

protocol URLSessionDataTaskType {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskType {}
