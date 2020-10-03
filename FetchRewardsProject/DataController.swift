//
//  DataController.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import Foundation
import Combine

class DataController {
  private let urlSession = URLSession(configuration: .default)
  private var subscriptions: Set<AnyCancellable> = .init()
  
  
  func fetchAllItems(completion: @escaping (Result<[Item], Error>) -> Void) {
    fetchAllItemsPublisher()
      .sink { result in
        if case let .failure(error) = result {
          completion(.failure(error))
        }
      } receiveValue: { items in
        completion(.success(items))
      }
      .store(in: &subscriptions)
  }
  
  func fetchAllItemsPublisher() -> AnyPublisher<[Item], Error> {
    guard let url = createUrl(forRoutable: FetchRewardsRoutable.itemList) else {
      return Fail(error: FetchRewardsError.invalidUrl)
        .eraseToAnyPublisher()
    }
    
    return makePublisher(forUrl: url)
      .decode(type: ItemsResponse.self, decoder: JSONDecoder())
      .map({ $0.items })
      .eraseToAnyPublisher()
  }
}

// MARK: - Helpers
extension DataController {
  private func makePublisher(forUrl url: URL) -> AnyPublisher<Data, Error> {
    urlSession
      .dataTaskPublisher(for: url)
      .tryMap({ out -> Data in
        guard let response = out.response as? HTTPURLResponse,
              200..<400 ~= response.statusCode
        else { throw FetchRewardsError.networkingError }
        return out.data
      })
      .eraseToAnyPublisher()
  }
  
  private func createUrl(forRoutable routable: Routable) -> URL? {
    var urlComponents = URLComponents()
    
    urlComponents.scheme = "https"
    urlComponents.host = routable.baseUrl
    urlComponents.path = routable.path
    let queryItems = routable.parameters.compactMap { key, value in URLQueryItem(name: key, value: "\(value)") }
    urlComponents.queryItems = queryItems.count > 0 ? queryItems : nil
    
    return urlComponents.url
  }
}
