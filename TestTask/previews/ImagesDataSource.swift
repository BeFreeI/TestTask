//
//  ImagesDataSource.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import UIKit

enum Section: Hashable {
    case images
}

class ImagesDataSource: UICollectionViewDiffableDataSource<Section, ApiImageModel> {
    func reload(_ data: [ApiImageModel], needRemoveAll: Bool = false, animated: Bool = true) {
        var snapshot = snapshot()
        
        if needRemoveAll {
            snapshot.deleteAllItems()
        }

        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.images])
        }


        snapshot.appendItems(data, toSection: .images)

        DispatchQueue.main.async {
            self.apply(snapshot, animatingDifferences: animated)
        }
    }
}
