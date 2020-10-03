//
//  ItemCell.swift
//  FetchRewardsProject
//
//  Created by Alex Fargo on 10/2/20.
//

import UIKit

class ItemCell: UITableViewCell, ReuseIdentifiable {
  lazy var idLabel: UILabel = {
    let l = UILabel()
    l.font = .preferredFont(forTextStyle: .headline)
    return l
  }()
  
  lazy var groupLabel: UILabel = {
    let l = UILabel()
    l.font = .preferredFont(forTextStyle: .headline)
    return l
  }()
  
  lazy var nameLabel: UILabel = {
    let l = UILabel()
    l.font = .preferredFont(forTextStyle: .body)
    return l
  }()
  
  lazy var headerStack: UIStackView = {
    let s = UIStackView(arrangedSubviews: [idLabel, groupLabel])
    s.alignment = .leading
    s.axis = .vertical
    s.spacing = 2
    s.distribution = .fill
    return s
  }()
  
  lazy var stack: UIStackView = {
    
    let s = UIStackView(arrangedSubviews: [headerStack, nameLabel])
    s.alignment = .leading
    s.axis = .vertical
    s.spacing = 8
    s.distribution = .fill
    s.translatesAutoresizingMaskIntoConstraints = false
    return s
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Configuration
extension ItemCell {
  func configure(withItem item: Item) {
    self.nameLabel.text = "Name: \(item.name ?? "No name")"
    self.idLabel.text = "ID: \(item.id)"
    self.groupLabel.text = "List ID: \(item.listId)"
  }
}

// MARK: - Setup
private extension ItemCell {
  func setup() {
    addSubview(stack)
    makeConstraints()
  }
  
  func makeConstraints() {
    let stackConstraints: [NSLayoutConstraint] = [
      stack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
    ]
    
    NSLayoutConstraint.activate(stackConstraints)
  }
}
