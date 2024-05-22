//
//  SearchBar.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 22.05.24.
//

import UIKit

class SearchBar: UICollectionReusableView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()

        return searchBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        searchBar.showsCancelButton = true
        addSubview(searchBar)
    }

    override func layoutSubviews() {
        searchBar.frame = self.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
