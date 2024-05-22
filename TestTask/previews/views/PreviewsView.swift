//
//  PreviewsView.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import UIKit

class PreviewsView: UIView {

    lazy var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: PreviewCollectionViewCell.collectionViewId)
        collectionView.register(SearchBar.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchBar.reuseIdentifier)


        return collectionView
    }()

    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myCollectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Set Layouts

    override func layoutSubviews() {
        myCollectionView.frame = frame
    }
}
