//
//  Utitlity.swift
//  MovieShowList
//
//  Created by Macbook Pro on 6/3/23.
//

import Foundation
import UIKit
import SystemConfiguration


class Utility: NSObject{
    
    class func convertHeightMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/896
        return value*UIScreen.main.bounds.height
    }
    
    class func convertWidthMultiplier(constant : CGFloat) -> CGFloat{
        let value = constant/414
        return value*UIScreen.main.bounds.width
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    //MARK: - Alert Related
    class func showAlert(_ VC: UIViewController, _ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default: print("default")
            case .cancel: print("cancel")
            case .destructive: print("destructive")
            default: break
            }}))
        DispatchQueue.main.async {
            VC.present(alert, animated: true, completion: nil)
        }
    }
    
    class func calculateHeight(inString:String) -> CGFloat{
        let detailString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)]
        
        let attributedString = NSAttributedString(string: detailString, attributes: attributes)
        let rect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude),
                                                          options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize = rect
        return requredSize.height
    }
}
