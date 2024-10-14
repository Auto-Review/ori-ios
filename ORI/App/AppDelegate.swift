//
//  AppDelegate.swift
//  ORI
//
//  Created by Song Kim on 10/4/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Kakao SDK
        if let KAKAO_API_KEY = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String {
            KakaoSDK.initSDK(appKey: KAKAO_API_KEY)
        }
        
        // Initialize Naver Login
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.setOnlyPortraitSupportInIphone(true)
        instance?.serviceUrlScheme = Bundle.main.infoDictionary?["NAVER_API_URL"] as? String
        instance?.consumerKey = Bundle.main.infoDictionary?["NAVER_API_KEY"] as? String
        instance?.consumerSecret = Bundle.main.infoDictionary?["NAVER_API_SECRET"] as? String
        instance?.appName = "ORI"
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        if NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options) == true {
            return true
        }
        
        return false
    }
}

