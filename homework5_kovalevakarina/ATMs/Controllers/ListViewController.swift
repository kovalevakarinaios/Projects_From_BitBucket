//
//  ListViewController.swift
//  ATMs
//
//  Created by Karina Kovaleva on 27.12.22.
//

import UIKit

protocol ListViewControllerDelegate: AnyObject {
    func selectAnnotation(_ id: String, _ type: DataType)
}

final class ListViewController: UIViewController {

    private lazy var viewModel = {
        ViewModel()
    }()

    private var dataSource: UICollectionViewDiffableDataSource<SectionViewModel, CellModel>?

    weak var delegate: ListViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.reuseId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.initViewModel()
        self.collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addObservers()
        self.setupCollectionView()
        self.setupDataSource()
        self.createSnapshot()
    }

    private func initViewModel() {
        self.viewModel.getInfoFromApi()
        self.viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reloadData),
                                               name: NameNotification.filter.notification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.chooseMapVC),
                                               name: NameNotification.update.notification,
                                               object: nil)
    }

    @objc func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionViewModel, CellModel>()
        snapshot.appendSections(self.viewModel.sectionViewModels)
        for section in self.viewModel.sectionViewModels {
            snapshot.appendItems(section.infoForModel, toSection: section)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionViewModel, CellModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId,
                                                              for: indexPath) as? CollectionViewCell
                let cellViewModel = self.viewModel.getCellViewModel(at: indexPath)
                cell?.cellViewModel = cellViewModel
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
            sectionHeader.setHeaderText(city)
            return sectionHeader
        }
    }

    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionViewModel, CellModel>()
        snapshot.appendSections(self.viewModel.sectionViewModels)
        for section in self.viewModel.sectionViewModels {
            snapshot.appendItems(section.infoForModel, toSection: section)
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

        let spacing = CGFloat(4)
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

    @objc private func chooseMapVC() {
        guard let viewController = self.navigationController?.viewControllers.first
                as? MainViewController else { return }
        viewController.chooseMapViewController()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.filter.notification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NameNotification.update.notification,
                                                  object: nil)
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.navigationController?.viewControllers.first
                as? MainViewController else { return }
        viewController.chooseMapViewController()
        let cellModel = self.viewModel.sectionViewModels[indexPath.section].infoForModel[indexPath.row]
        switch cellModel.type {
        case .atm:
            guard let id = cellModel.id else { return }
            self.delegate?.selectAnnotation(id, .atm)
        case .infobox:
            guard let id = cellModel.idInfoBox else { return }
            self.delegate?.selectAnnotation(String(id), .infobox)
        case .filial:
            guard let id = cellModel.filialID else { return }
            self.delegate?.selectAnnotation(id, .filial)
        }
    }
}
