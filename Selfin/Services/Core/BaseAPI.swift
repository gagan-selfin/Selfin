//
//  BaseAPI.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit
import Reachability

public enum Environment {
	 var host: String {
		switch self {
		case .dev:
			return "https://dev.selfin.io"
		 case .staging:
			return "https://staging.selfin.io"
		 case .production:
			return "https://api.selfin.io"
		}
	}
	var imageHost:String {
		return "https://image.selfin.io/"
	}
	case staging
	case dev
	case production
}

let APIVersion = "v1"

let environment: Environment = .production

public enum APIError: Error {
    case badRequest
    case noData
    case network
    case server
    case authorize
    case parsing
}

public enum APIs: String {
	  case changeAvatarApi =   "v1/user/USERNAME/profile/change-profile-picture/"
	 case userProfileApi =     "user/profile/"
}

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

public enum Parameters {
    case none
    case body(data: Data?)
    case url(_: [String: String])
}

protocol RequestRepresentable {
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var headers: [String: String]? { get }
}

extension RequestRepresentable {
	var headers:[String:String]? { return nil   }
	var method: HTTPMethod 		  { return .get  }
	var parameters: Parameters   { return .none }
	
    func encodeBody<T: Codable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
	
	func encodeBody(body:[String:Any]) ->Data? {
		return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
	}
	
	func encodeBody(body:Any) -> Data? {
	 return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
	}
}

public struct Parser<T: Decodable> {
    static func from(_ data: Data) -> (T?, Error?) {
        do {
            let decodedModel = try JSONDecoder().decode(T.self, from: data)
            return (decodedModel, nil)
        } catch {
            return (nil, error)
        }
    }
	static func from(_ data: Data) -> T? {
		return try? JSONDecoder().decode(T.self, from: data)
	}
	
    static func to<T: Encodable>(_ model: T) -> (Data?, Error?) {
        do { return (try JSONEncoder().encode(model), nil) } catch { return (nil, error) }
    }
	static func to<T:Encodable>(_ model:T) -> Data? {
		return try? JSONEncoder().encode(model)
	}
}

public enum Response<T: Decodable> {
    case success(date: T)
    case failed(error: APIError)

    init(r: HTTPURLResponse?, d: Data?) {
        guard let response = r else { self = .failed(error: .noData); return }
        switch response.statusCode {
        case 400:
            self = .failed(error: .badRequest)
        // return
        case 401 ... 404:
            self = .failed(error: .authorize)
        // return
        case 500 ... 504:
            self = .failed(error: .server)
        // return
        default:
            break
        }
        
        if let data = d {
            let (model, err) = Parser<T>.from(data)
            if err != nil {
                self = .failed(error: .parsing)
                return
            } else { self = .success(date: model!)
                return
            }
        }
        self = .failed(error: .noData)
    }
}

final class SessionDispatcher: NSObject, URLSessionDelegate {
    var headers: [String: String] = [:]
    
    func execute<T: Decodable>(requst: RequestRepresentable, modeling _: T.Type) -> Promise<T> {
        let promise = Promise<T>.pending()
        if network?.connection == .none {
            promise.resolver.reject(APIError.network)
        }

        session.dataTask(with: prepareRequest(request: requst), completionHandler: { data, response, err in
            if err != nil { promise.resolver.reject(err!) }
            let resp = Response<T>(r: response as? HTTPURLResponse, d: data)
             switch resp {
            case let .success(data): promise.resolver.fulfill(data)
            case let .failed(err): promise.resolver.reject(err)
            }
        }).resume()
        return promise.promise
    }

    let host: String
    let network = Reachability()
    var session: URLSession {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let s = URLSession(configuration: config)
        return s
    }

     override init() {
		self.host = environment.host
        do {
            try network?.startNotifier()
        } catch {
            print("Unable to start network monitoring", error)
        }
    }
    private func prepareRequest(request: RequestRepresentable) -> URLRequest {
        let s = "\(host)/\(request.endpoint)"
        let scaped = s.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: scaped!)
        var r = URLRequest(url: url!)
        headers(in: request, for: &r)
        params(in: request, for: &r)
        print("sending request :", s)
        return r
    }

    private func headers(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        urlRequest.httpMethod = request.method.rawValue
        addDefaultHeaders()
        headers.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
        request.headers?.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
    }

    private func addDefaultHeaders() {
        headers["Content-Type"] = "application/json"
        
        if UserStore.user != nil {
            if UserStore.token() != "" {
                 headers["Authorization"] = UserStore.token()
            }
        }
    }

    private func params(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        switch request.parameters {
        case let .body(data):
            urlRequest.httpBody = data
        case let .url(urlencoded):
            var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: true)
            urlencoded.forEach { key, value in
                let query = URLQueryItem(name: key, value: value)
                urlComponents?.queryItems?.append(query)
            }
            urlRequest = URLRequest(url: (urlComponents?.url)!)
        default: break
        }
    }
}


