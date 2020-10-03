//
//  ItemListViewController.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import UIKit

class ItemListViewController: UITableViewController {
  var itemListViewModel: ItemListViewModel
  
  init(itemListViewModel: ItemListViewModel) {
    self.itemListViewModel = itemListViewModel
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Lifecycle
extension ItemListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    itemListViewModel.fetchItems()
  }
}

// MARK: - Actions
extension ItemListViewController {
  @objc func refreshItems(_ sender: UIBarButtonItem) {
    itemListViewModel.fetchItems()
  }
}

// MARK: - ItemListDelegate
extension ItemListViewController: ItemListDelegate {
  func itemList(receivedItems: [[Item]]) {
    DispatchQueue.main.async { [self] in
      tableView.reloadData()
    }
  }
  
  func itemList(receivedError: Error) {
    let alertController = UIAlertController(
      title: "Whoops!",
      message: "There was an error retrieving the item data.",
      preferredStyle: .alert
    )
    
    alertController.addAction(
      UIAlertAction(
        title: "Try Again",
        style: .default,
        handler: { [weak self] _ in
          self?.itemListViewModel.fetchItems()
        }
      )
    )
    
    DispatchQueue.main.async { [self] in
      present(alertController, animated: true)
    }
  }
}

// MARK: - UITableViewDelegate
extension ItemListViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension ItemListViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    itemListViewModel.numberOfSections()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    itemListViewModel.numberOfItems(forSection: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier) as? ItemCell else {
      return UITableViewCell()
    }
    if let item = itemListViewModel.item(forIndex: indexPath) {
      dequeuedCell.configure(withItem: item)
    }
    return dequeuedCell
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    itemListViewModel.title(forSection: section)
  }
}

// MARK: - Setup
private extension ItemListViewController {
  func setup() {
    tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuseIdentifier)
    title = "Item List"
    
    let refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(refreshItems(_:)))
    navigationItem.setRightBarButton(refreshButton, animated: false)
  }
}
