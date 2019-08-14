//
//  MultiPartDispatcher.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/22/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import Reachability
enum MultiPartDispatcherAction {
	case failed(err :APIError)
	case progress(progress:Float)
	case success(response:Any)
}
protocol MultiPartDispatcherDelegate: class {
	func onMultipartActions(action:MultiPartDispatcherAction)
}

// MARK: - MULTIPART DISPATCHER

final class MultiPartDispatcher: NSObject, URLSessionDelegate, URLSessionDataDelegate {
	let host: String
	let network = Reachability()
	private var expectsData = true
	private var image: UIImage!
	private let boundary = "Boundary-\(NSUUID().uuidString)"
	private var bodyData = Data()
	var headers: [String: String] = [:]
	
	weak var delegate: MultiPartDispatcherDelegate?
	private var session: URLSession {
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
		let s = URLSession(configuration: config, delegate: self, delegateQueue: nil)
		return s
	}
	
	override init() {
		self.host = environment.host
		do {
			try network?.startNotifier()
		} catch {
			delegate?.onMultipartActions(action: .failed(err: .network))
		}
	}
	
	func execute(request: RequestRepresentable, with image: UIImage, expectsData: Bool = true) {
		self.image = image
		self.expectsData = expectsData
		let ulrRequst = prepareRequest(request: request)
		print(ulrRequst)
		session.dataTask(with: ulrRequst).resume()
	}
	
	private func prepareRequest(request: RequestRepresentable) -> URLRequest {
		let s = "\(host)/\(request.endpoint)"
		let scaped = s.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
		let url = URL(string: scaped!)
		var r = URLRequest(url: url!)
		headers(in: request, for: &r)
		prepareBody(request: request)
		params(in: request)
		r.httpBody = bodyData
		return r
	}
	
	private func prepareBody(request _: RequestRepresentable) {
		let fileKey = "image"
		let filename = "image.jpg"
		let data = image.jpegData(compressionQuality: 1.0)!
		
		bodyData.append("--\(boundary)\r\n")
		bodyData.append("Content-Disposition: form-data; name=\"\(fileKey)\"; filename=\"\(filename)\"\r\n")
		bodyData.append("Content-Type: \("application/octet-stream")\r\n\r\n")
		bodyData.append(data)
		bodyData.append("\r\n")
		bodyData.append("--\(boundary)--\r\n")
	}
	
	func buildBodyParams(params: [String: String]) {
		for (key, value) in params {
			bodyData.append("--\(boundary)\r\n")
			bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
			bodyData.append("\(value)\r\n")
		}
	}
	
	private func addDefaultHeaders() {
		headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        if UserStore.user != nil {
            if UserStore.token() != "" {
                headers["Authorization"] = UserStore.token()
            }
        }
	}
	
	private func headers(in request: RequestRepresentable, for urlRequest: inout URLRequest) {
        urlRequest.httpMethod = request.method.rawValue
		addDefaultHeaders()
        print(request.method.rawValue)
        headers.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
        })
		request.headers?.forEach({ key, value in
			urlRequest.setValue(value, forHTTPHeaderField: "\(key)")
		})
        
	}

	private func params(in request: RequestRepresentable) {
        print(request.parameters)
		switch request.parameters {
		case let .body(data):
			guard let data = data else { break}
			bodyData.append(data)
		default: break
		}
	}
	
	func urlSession(_: URLSession, task _: URLSessionTask, didSendBodyData _: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
		let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
		delegate?.onMultipartActions(action: .progress(progress: progress))
	}
	
	func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive response: URLResponse, completionHandler _: @escaping (URLSession.ResponseDisposition) -> Void) {
		let urlResponse = response as! HTTPURLResponse
		let status = urlResponse.statusCode
		print(status)
		if status >= 200 && status < 400 {
			delegate?.onMultipartActions(action: .success(response: status))
		} else if status >= 400 || status <= 504 {
			delegate?.onMultipartActions(action: .failed(err: .server))
		} else { delegate?.onMultipartActions(action: .failed(err: .badRequest))
			
		}
	}
	
	func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError _: Error?) {
		delegate?.onMultipartActions(action: .failed(err: .server))
	}
	
	func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didBecome _: URLSessionDownloadTask) {}
	
	func urlSession(_: URLSession, dataTask _: URLSessionDataTask, didReceive data: Data) {
		let response = try! JSONSerialization.jsonObject(with: data, options: [.allowFragments])
		delegate?.onMultipartActions(action: .success(response: response))
	}
}

// extension to append string to Data
extension Data {
	mutating func append(_ string: String) {
		let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
		append(data!)
	}
}
