import Foundation
import Alamofire

enum NetworkRequestError: Error {
    case invalidURL
    case urlEncodingFailed
}

class NetworkRequest: URLRequestConvertible {
    private let baseUrl: String
    private let path: String
    private let method: HTTPMethod
    private let headers: [String: String]?
    private let queryItems: [URLQueryItem]?
    private let body: Data?

    private var urlComponents: URLComponents? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path.append(path)
        urlComponents?.queryItems = queryItems
        return urlComponents
    }

    init(_ baseUrl: String,
         _ path: String,
         _ method: HTTPMethod,
         _ headers: [String: String]? = nil,
         queryItems: [URLQueryItem]? = nil,
         body: Data? = nil) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }

    private func getURL() throws -> URL {
        guard let url = urlComponents?.url else { print("TODO: Log error message here. (Invalid URL)")
            throw NetworkRequestError.invalidURL
        }
        return url
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try getURL()
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 60.0)

        // Set the HTTP method
        urlRequest.httpMethod = method.rawValue

        // Set Headers
        urlRequest.allHTTPHeaderFields = headers

        // Set Body
        if let body = body {
            urlRequest.httpBody = body
        }

        return urlRequest
    }
}

extension URLRequestConvertible {
    var description: String {
        guard let request = urlRequest else { return "Invalid urlRequest: urlRequest is nil." }
        var debugDescription = "\n\n================ REQUEST INFO START ================\n"
        debugDescription += "METHOD:\t\t\(request.httpMethod ?? "--> Invalid method")\n"
        debugDescription += "URL:\t\t\(request.url?.debugDescription ?? "--> Invalid URL")\n"
        debugDescription += "HEADERS:\t\(getHeaderDescription(request.headers))\n"
        if let body = request.httpBody {
            debugDescription += "BODY:\t\(String(data: body, encoding: .utf8) ?? "--> INVALID BODY")\n"
        } else {
            debugDescription += "BODY:\t--> EMPTY BODY)\n"
        }
        debugDescription += "================= REQUEST INFO END =================\n"
        return debugDescription
    }

    func getHeaderDescription(_ headers: HTTPHeaders) -> String {
        var debugDescription = "[\n"
        let mappedHeaders = headers.map { "\t\($0)" }.joined(separator: ",\n")
        debugDescription += mappedHeaders
        debugDescription += "\n]"
        return debugDescription
    }
}
