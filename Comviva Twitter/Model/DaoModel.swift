//
//  DaoModel.swift
//  Comviva Twitter
//
//  Created by com.mfs.db on 17/01/20.
//  Copyright © 2020 com.mfs.db. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable{
    let statuses: [Status]
    
}

// MARK: - Status
struct Status : Codable {
    let text: String
    let user: User
}


// MARK: - User
struct User : Codable{
    let  name, screen_name: String
    let profile_image_url_https: String
    let profile_banner_url: String?
}

struct Token : Codable {
    let access_token : String
}
