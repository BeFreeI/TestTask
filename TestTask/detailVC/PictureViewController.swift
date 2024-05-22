//
//  PictureViewController.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import UIKit

class PictureViewController: UIViewController {
    private let imageView = UIImageView()

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)

        imageView.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = imageView
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = false
    }

    required init?(coder: NSCoder) {
        fatalError("error")
    }

    func setImage(image: UIImage) {
        imageView.image = image
    }
}
