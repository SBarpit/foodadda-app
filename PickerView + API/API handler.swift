//
//  API handler.swift
//  PickerView + API
//
//  Created by Appinventiv Mac on 15/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import Foundation


class Network {
    
    var vc:ViewController!
    
    var name:[String]=[]
    var address:[String]=[]
    var rating:[NSNumber]=[]
    var imageURLS:[String]=[]
    var desc:[String] = []
    let headers = [
        "Cache-Control": "no-cache",
        "Postman-Token": "f332f7b2-b335-447e-b0a7-fbcc75f69701"
    ]
    
    //MARK: API key
    
   fileprivate var key = "AIzaSyBXSZOOoR3kNLHEy1maOLnJzrUoGZRgAIM"
    
   func getResponce(_ Search:String) {
        
        let request = getRequest(Search)
        
        request.httpMethod = "GET"
        
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                
                print(error as Any)
                
                
            } else {
                
                let httpResponse = response as? HTTPURLResponse
                
                print(httpResponse as Any)
                
            }
            
            guard let data = data else {return}
            
            let v = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
            
            print(v)
            
            let results = v["results"] as! [[String:Any]]
            
            let status = v["status"] as! String
            
            if status != "ZERO_RESULTS" || status != "INVALID_REQUEST"{
                
                for result in results{
                    
                    for(key,value) in result
                    {
                        if key=="name"
                        {
                            self.name.append(value as! String)
                        }
                        else if key == "rating"
                        {
                            self.rating.append(value as! NSNumber)
                        }
                        else if key=="formatted_address"
                        {
                            self.address.append(value as! String)
                        }
                        else if key == "icon"
                        {
                            self.imageURLS.append(value as! String)
                        }
                    }
                }
            }else{
//              self.vc.displayAlertMessage("No results found ! 😅")
                print("No results found ! 😅")
            }
        }).resume()
        
    }
    
    // MARK: Send request to server
    
    func getRequest(_ search:String) -> NSMutableURLRequest{
        return NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(search)&key=AIzaSyBatToiKxdUkBLl_pB-COLqUUeEH3UljoY")! as URL,
                                   cachePolicy: .useProtocolCachePolicy,
                                   timeoutInterval: 10.0)
    }
    
}
