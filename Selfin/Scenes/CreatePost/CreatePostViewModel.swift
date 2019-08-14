//
//  CreatePostViewModel.swift
//  Selfin
//
//  Created by cis on 27/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import CoreLocation
import  UIKit

protocol createPostDelegate : class  {
    func didReceived(result : NSDictionary )
    func didReceived(error msg:String)
}

final class CreatePostViewModel {
    weak var delegate:createPostDelegate?
    
    func createPost(image : UIImage, locationName : String, long : Double, lat : Double, content : String, scheduleTime : String, taggedUsers : [Int]) {
        var postContent = content
        if postContent == "Add a caption"{postContent = ""}
        let dict = ["location_name":locationName, "longitude":long, "latitude":lat, "post_content":postContent, "scheduled_time":scheduleTime,"tag_users":taggedUsers] as [String : Any]
        
        if ConstantManagerSharedInstance.isNetworkConnected() {
            let url = "/v1/post/"
            ConstantManagerSharedInstance.callPostServiceForSendingImage(postdata: dict as NSDictionary, urlString: url, isMultipart: true, isImage: true, imageObj: image, imageParam: "image") { (result, error) in
                if result["status"] as! Bool == true {
                    self.delegate?.didReceived(result: result)
                }else if result["status"] as! Bool == false {self.delegate?.didReceived(error: result["message"] as! String)
                }else  {
                    self.delegate?.didReceived(error: error?.localizedDescription ?? "")
                }
            }
        }
    }

    var isLocation: ((String) -> Void)?
    var locationManager = CLLocationManager()
    
    func getUserCurrentLocation(coordinates: CLLocationCoordinate2D)  {
        var placeName = ""
        
        let currentLocation = CLLocation(latitude: (coordinates.latitude), longitude: (coordinates.longitude))
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: { (placemark, error) -> Void in
            if error == nil && (placemark?.count)! > 0 {
                let placemarkCount: CLPlacemark = placemark![0]
                
                let dict = placemarkCount.addressDictionary as! Dictionary<String, Any>
                
                if dict["Street"] != nil {
                    print(dict["Street"] as! String)
                }
                
                if dict["SubLocality"] != nil {
                    print(dict["SubLocality"] as! String)
                }
                
                if dict["State"] != nil {
                    print(dict["State"] as! String)
                }
                
                if dict["City"] != nil {
                    placeName = dict["City"] as! String
                }
                
                if dict["Country"] != nil {
                    placeName.append(", \(dict["Country"] as! String)")
                }
                self.isLocation?(placeName)
            } else if error == nil && placemark?.count == 0 {
                print("No result were returned")
            } else if error != nil {
                print("error in finding location")
            }
        })
    }
}
