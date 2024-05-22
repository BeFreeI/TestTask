//
//  ViewController.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import UIKit

class PreviewsViewController: UIViewController {
    let previewsView = PreviewsView()
    var dataSource: ImagesDataSource?
    private var viewModel: PreviewsViewModelProtocol = PreviewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = previewsView
        configureCollectionView()
        previewsView.myCollectionView.delegate = self
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillLayoutSubviews() {
        previewsView.frame = view.frame
    }

    @objc private func refreshAction(refreshControl: UIRefreshControl) {
        dataSource?.reload([], needRemoveAll: true)
        viewModel.refresh {
            DispatchQueue.main.async {
                refreshControl.endRefreshing()
            }
        }
    }

    private func configureCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        previewsView.myCollectionView.refreshControl = refreshControl

        dataSource = .init(
            collectionView: previewsView.myCollectionView,
            cellProvider: {[weak self] collectionView, indexPath, itemIdentifier in
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PreviewCollectionViewCell.collectionViewId,
                        for: indexPath
                    ) as? PreviewCollectionViewCell
                else {
                    return UICollectionViewCell()
                }

                self?.viewModel.loadImage(
                    type: .thumbnail,
                    at: indexPath.row
                ) { imageModel in
                    DispatchQueue.main.async {
                        cell.configure(with: imageModel)
                    }
                }

                return cell
            }
        )

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: SearchBar.reuseIdentifier,
                    for: indexPath
                ) as? SearchBar,
                kind == UICollectionView.elementKindSectionHeader
            else {
                return nil
            }

            headerView.searchBar.delegate = self

            return headerView
        }

        dataSource?.reload([])
        previewsView.myCollectionView.dataSource = dataSource
    }

    private func set(SearchString: String) {
        viewModel.set(searchString: SearchString)
    }
}

extension PreviewsViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if (scrollView.contentSize.height - targetContentOffset.pointee.y) < view.frame.height * 2 {
            viewModel.nextFetch()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard 
            let image = (collectionView
                .cellForItem(at: indexPath) as? PreviewCollectionViewCell)?
                .myImageView
                .image
        else { return }
        
        let pictureVC = PictureViewController(image: image)
        self.navigationController?.pushViewController(pictureVC, animated: true)

        viewModel.loadImage(type: .original, at: indexPath.row) { imageModel in
            DispatchQueue.main.async {
                pictureVC.setImage(image: imageModel.image)
            }
        }
    }
}

extension PreviewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellInRow = floor(self.view.frame.width / 150)
        let size = (self.view.frame.width - 5 * cellInRow) / cellInRow
        return CGSize(
            width: size,
            height: size
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

extension PreviewsViewController: ImagesViewModelDelegate {
    func imagesFetched(newInfos: [ApiImageModel], needRemoveAll: Bool) {
        dataSource?.reload(newInfos, needRemoveAll: needRemoveAll)
    }
}

extension PreviewsViewController: UISearchBarDelegate {
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        set(SearchString: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        set(SearchString: "")
        searchBar.resignFirstResponder()
    }
}
