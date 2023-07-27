import Foundation

protocol URLSessionType {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskType
}

extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskType {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
