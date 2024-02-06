//
//  ExploreDataModel.swift
//  ANF Code Test
//
//  Created by Mike Phan on 2/5/24.
//

import Foundation

struct ExploreDataResponse: Decodable {
    let title: String
    var backgroundImage: String
    let content: [ContentResponse]?
    let promoMessage: String?
    let topDescription: String?
    let bottomDescription: String?
}

struct ContentResponse: Decodable {
    let target: String
    let title: String
}
