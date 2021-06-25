//
//  ToastListViewController.swift
//  Toast Delivery
//

import UIKit

class ToastListViewController: UICollectionViewController {

    var viewModel: ToastListViewModel!
    
    internal var didSelectToast: ((ToastItem) -> ())?
    
    private let items: [ToastItem]
    private var dataSource: UICollectionViewDiffableDataSource<Int, ToastItem>?

    convenience init?(contentsOfURL url: URL) {
        guard let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([ToastItem].self, from: data) else {
            return nil
        }

        self.init(items: items)
    }

    init(items: [ToastItem]) {
        self.items = items
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
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .autoupdatingCurrent

        let cellRegistration = UICollectionView.CellRegistration(cellNib: UINib(nibName: "ToastCell", bundle: nil)) { (cell: ToastCell, _, item: ToastItem) in
            cell.configure(for: item, formatter: formatter)
        }

        let dataSource = UICollectionViewDiffableDataSource<Int, ToastItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: ToastItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, ToastItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
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
        guard indexPath.row < items.count else { return }
        
        let toast = items[indexPath.row]
        viewModel.didSelectToast.send(toast)
    }
}
