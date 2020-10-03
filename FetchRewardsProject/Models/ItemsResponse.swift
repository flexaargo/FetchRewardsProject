//
//  ItemsResponse.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import Foundation

struct ItemsResponse: Codable {
  let items: [Item]
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    items = try container.decode([Item].self)
  }
}

struct Item: Codable {
  let id: Int
  let listId: Int
  let name: String?
}
