//
//  ToastListViewController.swift
//  Toast Delivery
//

import UIKit

class ToastListViewController: UICollectionViewController {

    let viewModel: ToastListViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ToastItem>?

    init(viewModel: ToastListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: ToastListViewController.createLayout())
        configureDataSource()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(cellNib: UINib(nibName: "ToastCell", bundle: nil)) { (cell: ToastCell, _, item: ToastItem) in
            cell.configure(
                for: item,
                price: env
                    .currencyService
                    .format(price: item.price)
            )
        }

        let dataSource = UICollectionViewDiffableDataSource<Int, ToastItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ToastItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, ToastItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.items)
        dataSource.apply(snapshot, animatingDifferences: false)

        self.dataSource = dataSource
    }

    private static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItemAtIndex.send(indexPath.row)
    }
}
