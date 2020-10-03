//
//  FetchRewardsRoutable.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import Foundation

enum FetchRewardsRoutable: Routable {
  case itemList
  
  var baseUrl: String {
    return "fetch-hiring.s3.amazonaws.com"
  }
  
  var method: HTTPMethod {
    switch self {
    default:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .itemList:
      return "/hiring.json"
    }
  }
  
  var parameters: HTTPParameters {
    return [:]
  }
}
