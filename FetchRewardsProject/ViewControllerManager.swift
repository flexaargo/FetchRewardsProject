//
//  ViewControllerManager.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import UIKit

enum ViewControllerManager {
  case itemList(dataController: DataController)
  
  func instance(embedInNavigationController: Bool = false) -> UIViewController {
    var vc: UIViewController
    
    switch self {
    case .itemList(let dataController):
      let viewModel = ItemListViewModel(dataController: dataController)
      let viewController = ItemListViewController(itemListViewModel: viewModel)
      viewModel.itemListDelegate = viewController
      vc = viewController
    }
    
    if embedInNavigationController {
      let navigationController = UINavigationController(rootViewController: vc)
      return navigationController
    } else {
      return vc
    }
  }
}
