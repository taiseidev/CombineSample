//
//  JokeResponse.swift
//  CombineSample
//
//  Created by 大西　泰生 on 2023/07/02.
//

import Foundation

struct JokeResponse: Codable {
    var id: String
    var joke: String
    var status: Int
}
