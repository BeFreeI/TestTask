//
//  ViewModel.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import Foundation

enum ImageType {
    case thumbnail
    case original
}

protocol PreviewsViewModelProtocol {
    var delegate: ImagesViewModelDelegate? { get set }
    var imagesCount: Int { get }
    func loadImage(type: ImageType, at index: Int, completion: @escaping (ImageModel) -> Void)
    func nextFetch()
    func nextFetch(completion: (() -> Void)?)
    func refresh(completion: @escaping () -> Void)
    func set(searchString: String)
}

protocol ImagesViewModelDelegate: AnyObject {
    func imagesFetched(newInfos: [ApiImageModel], needRemoveAll: Bool)
}

class PreviewsViewModel {
    private var cache = NSCache<NSString, NSData>()
    private let imageService: ImageServiceProtocol = ImageService()
    private var images = [ApiImageModel]()
    private var filteredImages: [ApiImageModel] {
        images.filter { apiImageModel in
            if searchString.isEmpty { return true }
            return apiImageModel.title.lowercased().contains(searchString.lowercased())
        }
    }
    private var currentPage = 0
    private var isFetching = false
    private var searchString: String = "" {
        didSet {
            delegate?.imagesFetched(
                newInfos: filteredImages,
                needRemoveAll: true
            )
        }
    }

    weak var delegate: ImagesViewModelDelegate? {
        didSet {
            delegate?.imagesFetched(newInfos: images, needRemoveAll: false)
        }
    }

    init() {
        nextFetch()
    }
}

extension PreviewsViewModel: PreviewsViewModelProtocol {
    func set(searchString: String) {
        self.searchString = searchString
    }
    
    func nextFetch() {
        nextFetch(completion: nil)
    }
    
    func refresh(completion: @escaping () -> Void) {
        images = []
        currentPage = 0

        nextFetch(completion: completion)
    }

    func nextFetch(completion: (() -> Void)?) {
        if !isFetching {
            isFetching = true
            imageService.fetchImages(page: currentPage + 1) { newImages in
                completion?()
                var result = newImages

                if !self.searchString.isEmpty {
                    result = newImages.filter { apiImageModel in
                        if self.searchString.isEmpty { return true }
                        return apiImageModel.title.lowercased().contains(self.searchString.lowercased())
                    }
                }

                self.images.append(contentsOf: newImages)
                self.currentPage += 1
                self.delegate?.imagesFetched(
                    newInfos: result,
                    needRemoveAll: false
                )
                self.isFetching = false
            }
        }
    }

    var imagesCount: Int {
        filteredImages.count
    }

    func loadImage(
        type: ImageType,
        at index: Int,
        completion: @escaping (ImageModel) -> Void
    ) {
        guard let imageInfo = filteredImages[safe: index] else { return }

        let url = switch type {
        case .original:
            imageInfo.url
        case .thumbnail:
            imageInfo.thumbnailUrl
        }

        if let cachedImage = cache.object(
            forKey: url as NSString
        ) {
            completion(ImageModel(
                title: imageInfo.title,
                imageData: cachedImage as Data
            ))
            print("You get image from cache")
        } else {
            if let url = URL(string: url) {
                imageService.loadImage(
                    for: url
                ) { imageData in
                    self.cache.setObject(
                        imageData as NSData,
                        forKey: url.absoluteString as NSString
                    )

                    completion(ImageModel(
                        title: imageInfo.title,
                        imageData: imageData
                    ))
                }
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
