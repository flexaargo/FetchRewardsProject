//
//  ItemListViewModel.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import Foundation
import Combine

protocol ItemListDelegate: class {
  func itemList(receivedItems: [[Item]])
  func itemList(receivedError: Error)
}

class ItemListViewModel {
  private let dataController: DataController
  private var fetchItemsSubscription: AnyCancellable?
  
  private(set) var items: [[Item]] = []
  public weak var itemListDelegate: ItemListDelegate?
  
  init(dataController: DataController) {
    self.dataController = dataController
  }
  
  public func fetchItems() {
    guard fetchItemsSubscription == nil else { return }
    
    fetchItemsSubscription = dataController.fetchAllItemsPublisher()
      .map({ items -> [Int: [Item]] in
        // Map the items to a dictionary (keyed by listId)
        var itemDict = [Int: [Item]]()
        items.forEach { item in
          guard item.name != nil,
                item.name?.trimmingCharacters(in: .whitespacesAndNewlines) != ""
          else { return }  // Ensures all items in the dict will have a name
          
          itemDict[item.listId, default: []].append(item)
        }
        return itemDict
      })
      .map({ itemDict -> [[Item]] in
        // Map dictionary to 2D array array separated by listId
        var items: [[Item]] = []
        itemDict.keys.forEach { key in
          if itemDict[key] != nil {
            items.append(itemDict[key]!.sorted(by: { $0.name ?? "" < $1.name ?? "" }))  // name should never be nil here
          }
        }
        
        // Sort lists by listId
        return items.sorted(by: { $0.first?.listId ?? 0 < $1.first?.listId ?? 0 })   // There should always be at least 1 item in each list
      })
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        if case let .failure(error) = completion {
          print(error)
          self?.itemListDelegate?.itemList(receivedError: error)
        }
        
        self?.fetchItemsSubscription?.cancel()
        self?.fetchItemsSubscription = nil
      } receiveValue: { [weak self] items in
        self?.items = items
        self?.itemListDelegate?.itemList(receivedItems: items)
        
        self?.fetchItemsSubscription?.cancel()
        self?.fetchItemsSubscription = nil
      }
  }
  
  public func numberOfSections() -> Int {
    return items.count
  }
  
  public func numberOfItems(forSection section: Int) -> Int {
    guard items.indices.contains(section) else { return 0 }
    return items[section].count
  }
  
  public func item(forIndex indexPath: IndexPath) -> Item? {
    guard items.indices.contains(indexPath.section),
          items[indexPath.section].indices.contains(indexPath.row)
    else { return nil }
    return items[indexPath.section][indexPath.row]
  }
  
  public func title(forSection section: Int) -> String? {
    guard items.indices.contains(section),
          let listId = items[section].first?.listId
    else { return nil }
    return "List: \(listId)"
  }
}
