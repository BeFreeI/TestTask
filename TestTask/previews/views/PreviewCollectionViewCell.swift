//
//  PreviewCollectionViewCell.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import UIKit

class PreviewCollectionViewCell: UICollectionViewCell {

    //MARK: - properties

    static var collectionViewId = "collectionViewCell"

    //MARK: - IBOutlets

    let myImageView = UIImageView()
    let title = UILabel()

    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        addSubview(title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        myImageView.image = nil
        title.text = nil
    }

    //MARK: - Set Layouts

    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = contentView.frame
        myImageView.contentMode = .scaleToFill
        title.textAlignment = .left
        title.numberOfLines = .max
        title.lineBreakMode = .byWordWrapping
        guard let maxSize = (title.text as? NSString)?.size() else { return }
        let size = CGSize(
            width: bounds.width - 16,
            height: title.font.lineHeight * ceil(maxSize.width / (bounds.width - 16))
        )
        title.frame = CGRect(
            origin: CGPoint(x: 8, y: bounds.height - size.height),
            size: size
        )
    }

    func configure(with model: ImageModel) {
        myImageView.image = model.image
        title.text = model.title

        layoutSubviews()
    }
}

