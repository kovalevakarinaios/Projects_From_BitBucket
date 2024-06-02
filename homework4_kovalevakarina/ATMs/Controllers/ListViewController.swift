//
//  ListViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func selectAnnotation(_ id: String)
}

final class ListViewController: UIViewController {

    private let network = NetworkAPI()

    private var atms = [ATM]()
    private var sections = [ATMSection]()
    private var dataSource: UICollectionViewDiffableDataSource<ATMSection, ATM>?

    weak var delegate: ListViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "atmCell")
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setupCollectionView()
        setupDataSource()
        createSnapshot()
    }

    private func createGroupedData(_ atms: [ATM]) {
        let items = Dictionary(grouping: self.atms, by: {$0.city})
        let allKeys = Array(items.keys)
        var sections = [ATMSection]()
        for key in allKeys {
            guard let items = items[key] else { return }
            var section = ATMSection(city: key, atm: items)
            for index in section.atm.indices {
                guard Int(section.atm[index].id) != nil else { return }
                section.atm.sort { $0.id < $1.id }
            }
            sections.sort { $0.atm.count > $1.atm.count }
            sections.append(section)
        }
        self.sections = sections
    }

    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ATMSection, ATM>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, atm -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId,
                                                              for: indexPath) as? CollectionViewCell
                cell?.configureCell(model: atm)
                return cell }
        )
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeader.reuseId,
                for: indexPath
            ) as? SectionHeader else { return nil }
            guard let firstAtm = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(
                containingItem: firstAtm) else { return nil }
            var city = section.city
            city.isEmpty ? city = "Нет информации" : nil
            sectionHeader.headerLabel.text = city
            return sectionHeader
        }
    }

    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ATMSection, ATM>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.atm, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize:
                                            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                   heightDimension: .fractionalHeight(1)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                               heightDimension: .estimated(130)),
                                                       repeatingSubitem: item, count: 3)

        let spacing = CGFloat(3)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let header = createSectionHeader()
        header.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeader = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                         heightDimension: .estimated(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeader,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return header
    }

    public func getAtms(atms: [ATM]) {
        self.atms = atms
        self.createGroupedData(atms)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = navigationController?.viewControllers.first as? MainViewController else { return }
        viewController.chooseMapViewController()
        let atmId = sections[indexPath.section].atm[indexPath.row].id
        delegate?.selectAnnotation(atmId)
    }
}
