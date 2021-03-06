//
//  FlickrNetworking.swift
//  Virtual Tourist 10.0
//
//  Created by Cesar Ramirez on 11/23/15.
//  Copyright © 2015 Cesar Ramirez. All rights reserved.
//


import Foundation
import UIKit

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "f4b626aa00fb30a0a2dc28043cc13a3d"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"
let BOUNDING_BOX_HALF_WIDTH = 1.0
let BOUNDING_BOX_HALF_HEIGHT = 1.0
let LAT_MIN = -90.0
let LAT_MAX = 90.0
let LON_MIN = -180.0
let LON_MAX = 180.0

class FlickerNetworking : UIViewController {
    
    
    var photo: Photo!
    

    
    
    func createBoundingBoxString(lati: Double?, long: Double?) -> String {
        
        print(lati, long)

        
        let latitude = lati!
        let longitude = long!
        
        let bottom_left_lon = (longitude - 0.02)
        let bottom_left_lat = (latitude - 0.02)
        let top_right_lon = (longitude + 0.02)
        let top_right_lat = (latitude + 0.02)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
    
 
    func getImageFromFlickrBySearchWithPage( lati: Double?, long: Double?, completionHandler: (success: Bool, photoUrls: [String], errorString: AnyObject?) -> Void) {
        
        
        print("here i am")
    
    let methodArguments = [
        "method": METHOD_NAME,
        "api_key": API_KEY,
        "bbox": createBoundingBoxString(lati, long: long),
        "safe_search": SAFE_SEARCH,
        "extras": EXTRAS,
        "format": DATA_FORMAT,
        "nojsoncallback": NO_JSON_CALLBACK
    ]
    
        /* Add the page to the method's arguments */
        var withPageDictionary = methodArguments
        withPageDictionary["page"] = String(1)
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(withPageDictionary)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            var photoUrls : [String] = [String]()

            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* Parse the data! */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
            //    print(parsedResult)
                
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            
            if let photosDictionary = parsedResult["photos"] as? [String : AnyObject] {
                
              //  print(photosDictionary)
                
//                // Determine number of photos
//                let numPhotos : Int
//                if let totalPhotosVal = photosDictionary["total"] as? String {
//                    numPhotos = (totalPhotosVal as NSString).integerValue
//                } else {
//                    numPhotos = 0
//                }
//                
//                print("Found \(numPhotos) photos")
//                
//                if numPhotos > 0 {
                
                    // Get URLs for photos
                    if let photosArray = photosDictionary["photo"] as? [[String : AnyObject]] {
                        
                        print("photosDictionary contains \(photosArray.count) photos")
                        
                        // Return array of up to 24 randomly selected photo URLs
//                        let maxPhotosToReturn = 24
//                        let numPhotosToReturn = min(maxPhotosToReturn, photosArray.count)
//                        
//                        let randomArrayIndices = self.getRandomIndicesWithArraySize(photosArray.count)
//                        
                        for index in 1 ... 10 {
                            
                            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
                            
                            let photoURL = photosArray[randomPhotoIndex]
                            
                            if let photoUrlString = photoURL["url_m"] as? String {
                                
                                photoUrls.append(photoUrlString)
                                
                            }
                        }
                        
                    }
             //   }
                
              //  success = true
                
            } else {
                print("Error. Could not find \"photos\" object in JSON result.")
            }
            
            
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(success: true, photoUrls: photoUrls, errorString: "none")
            }
        }
        
        task.resume()
       
    }
    
            
            
            
//            /* GUARD: Is the "photos" key in our result? */
//            guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
//                print("Cannot find key 'photos' in \(parsedResult)")
//                return
//            }
//            
//            /* GUARD: Is the "total" key in photosDictionary? */
//            guard let totalPhotosVal = (photosDictionary["total"] as? NSString)?.integerValue else {
//                print("Cannot find key 'total' in \(photosDictionary)")
//                return
//            }
//            
//          for index in 1...10 {
//                
//        //        print(index)
//                
//           //     if totalPhotosVal > 0 {
//                    
//                    /* GUARD: Is the "photo" key in photosDictionary? */
//                    guard let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
//                        print("Cannot find key 'photo' in \(photosDictionary)")
//                        return
//                    }
//            
//            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
//            
//             let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
//            
//             let photosArrayy = photosDictionary["photo"] as? [[String : AnyObject]]
//
//            
//            
//            
//            
//            
//                                if let photoUrlString = photosArrayy["url_m"] as? String {
//            
//                                    photoUrls.append(photoUrlString)
//            
//                                }
//            
//            
//            
//            
//            
//                    //                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
//                    //                let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
//                    //                let photoTitle = photoDictionary["title"] as? String /* non-fatal */
//                    //
//                    
//                    
//                    // print("\(index) times 5 is \(index * 5)")
//                    
//                    //let randomPhotoIndex = (photosArray.count)
//                    let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
//                    let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
//                    
//                    //  let photoDictionary = photosArray as [String: AnyObject]
//                    
//                    let photoTitle = photoDictionary["title"] as? String /* non-fatal */
//                    
//                    /* GUARD: Does our photo have a key for 'url_m'? */
//                    guard let imageUrlString = photoDictionary["url_m"] as? String else {
//                        print("Cannot find key 'url_m' in \(photoDictionary)")
//                        return
//                    }
////            
////            if let photosArray = photosDictionary["photo"] as? [[String : AnyObject]] {
////                
////                print("photosDictionary contains \(photosArray.count) photos")
////                
////                // Return array of up to 24 randomly selected photo URLs
////                let maxPhotosToReturn = 24
////                let numPhotosToReturn = min(maxPhotosToReturn, photosArray.count)
////                
////                let randomArrayIndices = self.getRandomIndicesWithArraySize(photosArray.count)
////                
////                for i in 0 ..< numPhotosToReturn {
////                    
////                    let photoMetaData = photosArray[ randomArrayIndices[i] ]
////                    
////                    if let photoUrlString = photoMetaData["url_m"] as? String {
////                        
////                        photoUrls.append(photoUrlString)
////                        
////                    }
////                }
////                
////            }
////            }
//
//            
//                 //   let imageURL = NSURL(string: imageUrlString)
//            
//            
//            
////                    if let imageData = NSData(contentsOfURL: imageURL!) {
////                        dispatch_async(dispatch_get_main_queue(), {
////                            
////                      //      print(imageUrlString)
////                            
////                     //       let photo = UIImage(data: imageData)
////
////                           // let photo = UIImage(data: imageData)
////                            
////                        //    completionHandler(success: true, parsedResult: parsedResult,   errorString: "success")
////
////                            
////                           //    print(imageUrlString)
////                            
////                            
////                       //     let photo = UIImage(data: imageData)
////                            
////                            //    print(imageUrlString)
////                            
//////                            let pictures = Photo(photo : photo!)
//////                            (UIApplication.sharedApplication().delegate as! AppDelegate).photos.append(pictures)
//////                            
////                            
////                            
////                     //    let photourl = imageUrlString
////              //              print(photourl)
////                            
////
////                            
////                    //     (UIApplication.sharedApplication().delegate as! AppDelegate).photos.append(pictures)
////                            
////                            if methodArguments["bbox"] != nil {
////                                if let photoTitle = photoTitle {
////                                    //                self.photoTitleLabel.text = " \(photoTitle)"
////                                } else {
////                                    //                self.photoTitleLabel.text = "(Untitled)"
////                                }
////                            } else {
////                                //            self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
////                            }
////                        })
//////                    } else {
////                        print("Image does not exist at \(imageURL)")
////                    }
////                } else {
////                    dispatch_async(dispatch_get_main_queue(), {
////                        
////                        //                    self.photoTitleLabel.text = "No Photos Found. Search Again."
////                        //                    self.defaultLabel.alpha = 1.0
////                        //                    self.photoImageView.image = nil
////                    })
//                    
//                    
//             //   }
//          //}
//             completionHandler(success: true, photoUrls: imageUrlString,   errorString: "success")
//        }
//    }
//      //  completionHandler(success: true, errorString: "success")
//
//       //  completionHandler(success: true, parsedResult: parsedResult,   errorString: "success")
//        
//        task.resume()
  //  }
    
    
    
    
    
    
    
    
    
    // MARK: Escape HTML Parameters
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    
    
    
    
    struct Caches {
        static let imageCache = ImageCache()
    }
    
    
    
    
    
}
