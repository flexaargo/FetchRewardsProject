//
//  Routable.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import Foundation

public typealias HTTPParameters = [String: AnyHashable]

public enum HTTPMethod: String {
  case get    = "GET"
  case post   = "POST"
  case put    = "PUT"
  case patch  = "PATCH"
  case delete = "DELETE"
}

public protocol Routable {
  var baseUrl: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: HTTPParameters { get }
}
