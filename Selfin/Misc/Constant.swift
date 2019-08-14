//
//  Constant.swift
//  MY ACTIPAL
//
//  Created by cis on 1/4/18.
//  Copyright © 2017 cis. All rights reserved.
//


import SystemConfiguration
import UIKit
typealias StringConsumer = (_ result: NSDictionary, _ error: NSError?) -> Void

let ConstantManagerSharedInstance = ConstantManager()

struct API {
    static let BASE_URL = environment.host
    static let IMAGE_URL = environment.imageHost
}
class ConstantManager: NSObject {
    class var sharedInstance: ConstantManager {
        return ConstantManagerSharedInstance
    }

    // MARK: Convert String To Json & Return dictionary

    func setTheJsonToDictionary(strJson: String) -> Dictionary<String, Any> {
        let jaonString = strJson
        let data = jaonString.data(using: .utf8)
        print(data as Any)
        let jsonString = try? JSONSerialization.jsonObject(with: data!, options: [])
        print(jsonString!)

        return jsonString as! Dictionary<String, Any>
    }

    func isNetworkConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    func errorDict() -> NSDictionary {
        let errorDict = ["status": false, "message": "Server error"] as [String: Any]
        return errorDict as NSDictionary
    }

    // MARK: -

    // MARK: -  Get & Post WebService

    func PostRequestWithURL1(dictionary: NSDictionary, url: String, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = method
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions(rawValue: 0)
        )

        let jsonString = NSString(data: theJSONData!,
                                  encoding: String.Encoding.ascii.rawValue)

        print("Request Object:\(dictionary)")
        print("Request string = \(jsonString!)")

        let postLength = NSString(format: "%lu", jsonString!.length) as String
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonString!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)

        // set URL
        let completeURL = url
        request.url = NSURL(string: completeURL as String) as URL?

        return request
    }

    func PostRequestWithURL(dictionary: NSDictionary, url: String, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = method
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: JSONSerialization.WritingOptions(rawValue: 0)
        )

        let jsonString = NSString(data: theJSONData!,
                                  encoding: String.Encoding.ascii.rawValue)

        print("Request Object:\(dictionary)")
        print("Request string = \(jsonString!)")

        let postLength = NSString(format: "%lu", jsonString!.length) as String
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.httpBody = jsonString!.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)

        // set URL
        let completeURL = environment.host + url
        request.url = NSURL(string: completeURL as String) as URL?

        return request
    }

    func callGetService1(urlString: String, consumer: @escaping StringConsumer) {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        // set URL
        let completeURL = urlString
        request.url = NSURL(string: completeURL as String) as URL?

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }

                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")
                consumer(self.errorDict(), nil)
            }
        }
        task.resume()
    }

    func callGetService(urlString: String, consumer: @escaping StringConsumer) {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        // set URL
        let completeURL = environment.host + urlString
        request.url = NSURL(string: completeURL as String) as URL?

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }

                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")
                consumer(self.errorDict(), nil)
            }
        }
        task.resume()
    }

    // MARK: -

    // MARK: -  Multipart WebServices

    func callPutServiceForSendingImage(postdata: NSDictionary, urlString: String, isMultipart: Bool, isImage: Bool, imageObj: UIImage, imageParam: String, consumer: @escaping StringConsumer) {
        let request: NSMutableURLRequest!

        if isMultipart {
            request = multipartRequestWithURL(dictionary: postdata, url: urlString, isImage: isImage, image: imageObj, imageParam: imageParam, method: "PUT")

        } else {
            request = PostRequestWithURL(dictionary: postdata, url: urlString, method: "PUT")
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }
                print(todo)
                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")

                consumer(self.errorDict(), nil)
            }
        }
        task.resume()
    }

    func callPostServiceForSendingImage(postdata: NSDictionary, urlString: String, isMultipart: Bool, isImage: Bool, imageObj: UIImage, imageParam: String, consumer: @escaping StringConsumer) {
        let request: NSMutableURLRequest!

        if isMultipart {
            request = multipartRequestWithURL(dictionary: postdata, url: urlString, isImage: isImage, image: imageObj, imageParam: imageParam, method: "POST")

        } else {
            request = PostRequestWithURL(dictionary: postdata, url: urlString, method: "POST")
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }
                print(todo)
                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")

                consumer(self.errorDict(), nil)
            }
        }

        task.resume()
    }

    func callPostServiceForMultipleImages(postdata: NSDictionary, urlString: String, isMultipart: Bool, isImage: Bool, imageParam: String, imageArray: Array<Any>, isVideo: Bool, videoPath: Array<Any>, thumbnail: UIImage, consumer: @escaping StringConsumer) {
        let request: NSMutableURLRequest!

        if isMultipart {
            request = multipartRequestWithURLForMultipleImages(dictionary: postdata, url: urlString, isImage: isImage, imageParam: imageParam, imageArray: imageArray, isVideo: isVideo, videoPath: videoPath, thumbnail: thumbnail, method: "POST")

        } else {
            request = PostRequestWithURL(dictionary: postdata, url: urlString, method: "POST")
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)
                consumer(self.errorDict(), nil)
                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                consumer(self.errorDict(), nil)
                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }
                print(todo)
                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")

                consumer(self.errorDict(), nil)
            }
        }
        task.resume()
    }

    func multipartRequestWithURLForMultipleImages(dictionary: NSDictionary, url: String, isImage: Bool, imageParam: String, imageArray: Array<Any>, isVideo: Bool, videoPath: Array<Any>, thumbnail: UIImage, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = method

        let dt = NSDate(timeIntervalSinceNow: 0)
        let timeStamp: Int = Int(dt.timeIntervalSince1970)
        let boundary = "BOUNDARY-\(timeStamp)-\(ProcessInfo.processInfo.globallyUniqueString)"

        // set Content-Type in HTTP header
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        request.addValue(UserStore.token(), forHTTPHeaderField: "Authorization")

        // post body
        let body = NSMutableData()

        for (param, value) in dictionary {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(param)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }

        if isImage {
            for i in 0 ..< imageArray.count {
                if isVideo {
                    for i in 0 ..< videoPath.count {
                        if let fileURL = URL(string: (videoPath[i] as? String)!) {
                            let img: UIImage = thumbnail
                            let imageData = img.jpegData(compressionQuality: 0.2)!

                            let param1 = String(format: "thumbnail")
                            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Disposition: form-data; name=\"\(param1)\" ;filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8)!)
                            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)

                            body.append(imageData)

                            body.append("\r\n".data(using: String.Encoding.utf8)!)

                            if let videoData = NSData(contentsOf: fileURL) {
                                print(videoData.length)

                                let param = String(format: "image%d", i + 1)
                                body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Disposition: form-data; name=\"\(param)\" ;filename=\"image.mp4\"\r\n".data(using: String.Encoding.utf8)!)
                                //                            body.append("Content-Type: video/mp4\r\n\r\n".data(using: String.Encoding.utf8)!)
                                body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)

                                body.append(videoData as Data)

                                body.append("\r\n".data(using: String.Encoding.utf8)!)
                            }
                        }
                    }
                } else {
                    let img: UIImage = imageArray[i] as! UIImage
                    let imageData = img.jpegData(compressionQuality: 0.2)!

                    let param = String(format: "%@%d", imageParam, i + 1)
                    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(param)\" ;filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)

                    body.append(imageData)
                    body.append("\r\n".data(using: String.Encoding.utf8)!)
                }
            }
        }

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        // setting the body of the post to the reqeust
        request.httpBody = body as Data
        // set URL

        let completeURL = environment.host + url
        request.url = NSURL(string: completeURL as String) as URL?

        return request
    }

    func callGetService(postdata: NSDictionary, urlString: String, consumer: @escaping StringConsumer) {
        let request: NSMutableURLRequest!

        request = PostRequestWithURL1(dictionary: postdata, url: urlString, method: "GET")

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }
                print(todo)
                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")

                consumer(self.errorDict(), nil)
            }
        }

        task.resume()
    }

    func callPostService(postdata: NSDictionary, urlString: String, consumer: @escaping StringConsumer) {
        let request: NSMutableURLRequest!

        request = PostRequestWithURL(dictionary: postdata, url: urlString, method: "POST")

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // Parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }
                print(todo)
                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")

                consumer(self.errorDict(), nil)
            }
        }
        task.resume()
    }

    func callPostService(postdata: NSDictionary, urlString: String, isMultipart: Bool, isVideo: Bool, videoURL: NSURL, videoParam: String, thumbnail: UIImage, isThumNail: Bool, thumbNailParam: String, consumer: @escaping StringConsumer) {
        let request: NSMutableURLRequest!

        if isMultipart {
            request = multipartRequestWithVideoURL(dictionary: postdata, url: urlString, isVideo: isVideo, video: videoURL, videoParam: videoParam, method: "POST", thumbNail: thumbnail, isThumbNail: isThumNail, imagrParam: thumbNailParam)
        } else {
            request = PostRequestWithURL(dictionary: postdata, url: urlString, method: "POST")
        }

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request as URLRequest) {
            data, _, error in
            // check for any errors

            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error.debugDescription)

                consumer(self.errorDict(), nil)

                return
            }

            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")

                consumer(self.errorDict(), nil)

                return
            }

            // Parse the result as JSON, since that's what the API provides
            do {
                guard let todo: [String: AnyObject] = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")

                    consumer(self.errorDict(), nil)
                    return
                }
                print(todo)
                consumer(todo as NSDictionary, nil)

            } catch {
                let res: String = String(data: responseData, encoding: String.Encoding.utf8)!
                print(" Error Res Str \(res)")
                print("error trying to convert data to JSON")

                consumer(self.errorDict(), nil)
            }
        }

        task.resume()
    }

    func multipartRequestWithURL(dictionary: NSDictionary, url: String, isImage: Bool, image: UIImage, imageParam: String, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = method

        let dt = NSDate(timeIntervalSinceNow: 0)
        let timeStamp: Int = Int(dt.timeIntervalSince1970)
        let boundary = "BOUNDARY-\(timeStamp)-\(ProcessInfo.processInfo.globallyUniqueString)"

        // set Content-Type in HTTP header
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        request.addValue(UserStore.token(), forHTTPHeaderField: "Authorization")

        // post body
        let body = NSMutableData()

        for (param, value) in dictionary {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(param)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }

        if isImage {
            let param = imageParam

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"image.jpg\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(image.jpegData(compressionQuality: 1.0)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        // setting the body of the post to the reqeust
        request.httpBody = body as Data

        // set URL
        let completeURL = environment.host + url
        request.url = NSURL(string: completeURL as String) as URL?

        return request
    }

    // MARK: -

    // MARK: - Send Video Using Multipart

    func multipartRequestWithVideoURL(dictionary: NSDictionary, url: String, isVideo: Bool, video: NSURL, videoParam: String, method: String, thumbNail: UIImage, isThumbNail: Bool, imagrParam: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.timeoutInterval = 120
        request.httpMethod = method

        let dt = NSDate(timeIntervalSinceNow: 0)
        let timeStamp: Int = Int(dt.timeIntervalSince1970)
        let boundary = "BOUNDARY-\(timeStamp)-\(ProcessInfo.processInfo.globallyUniqueString)"

        // set Content-Type in HTTP header
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        // post body
        let body = NSMutableData()

        for (param, value) in dictionary {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(param)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
        }

        if isThumbNail {
            let param = imagrParam

            let imageToBase64String = (thumbNail.jpegData(compressionQuality: 0.1)!).base64EncodedString()
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(param)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(imageToBase64String)\r\n".data(using: String.Encoding.utf8)!)
        }

        if isVideo {
            let param = videoParam

            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)

            var movieData: NSData?
            do {
                movieData = try NSData(contentsOf: (video as URL), options: NSData.ReadingOptions.alwaysMapped)

            } catch _ {
                movieData = nil
            }

            body.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(String(describing: video.lastPathComponent))\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: video/MOV\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(movieData! as Data)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

        // setting the body of the post to the reqeust
        request.httpBody = body as Data
        // set URL

        let completeURL = environment.host + url
        request.url = NSURL(string: completeURL as String) as URL?

        return request
    }

    func updateUI_InMainThread() -> OperationQueue {
        return OperationQueue.main
    }

    func updateUI_withDispatchQueue() -> DispatchQueue {
        return DispatchQueue.main
    }

    func converDateFormate_FromString(apiDate: String) -> NSString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strConvertedDate = dateFormatter.date(from: apiDate as String)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let actulDate = dateFormatter.string(from: strConvertedDate!)

        return actulDate as NSString
    }
}
