//
//  ImageModel.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import UIKit

struct ImageModel {
    let title: String
    let image: UIImage

    init(title: String, imageData: Data) {
        self.title = title
        self.image = UIImage(data: imageData) ?? UIImage()
    }
}
