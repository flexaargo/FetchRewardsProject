//
//  ReuseIdentifiable.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import Foundation

protocol ReuseIdentifiable {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
  static var reuseIdentifier: String { String(describing: Self.self) }
}
