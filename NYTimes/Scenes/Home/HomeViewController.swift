//
//  HomeVC.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayArticles(viewModel: Home.GetArticles.ViewModel)
    func displayError(message: String)
}

class HomeViewController: UIViewController, HomeDisplayLogic {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        doGetArticles()
    }
    // MARK: IBOutlet
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    // MARK: IBAction
    
    // @IBAction private func btnTapped(_ sender: UIButton) {
    
    // }
    
    let refreshControl = UIRefreshControl()
    var viewed1Day: [Article] = []
    var viewed7Days: [Article] = []
    var viewed30Days: [Article] = []
    // MARK: SetupView
    
    private func setupView() {
        setupArticleCollectionView()
    }
    
    func setupArticleCollectionView() {
        articleCollectionView.register(UINib.init(nibName: ArticleCell.className, bundle: nil), forCellWithReuseIdentifier: ArticleCell.className)
        articleCollectionView.register(UINib.init(nibName: MinArticleCell.className, bundle: nil), forCellWithReuseIdentifier: MinArticleCell.className)
        articleCollectionView.register(UINib.init(nibName: HorizontalArticleCell.className, bundle: nil), forCellWithReuseIdentifier: HorizontalArticleCell.className)
        articleCollectionView.register(UINib(nibName: ArticleHeaderView.className, bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: ArticleHeaderView.className)
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.collectionViewLayout = createCollectionViewLayout()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        articleCollectionView.refreshControl = refreshControl
    }
    
    func doGetArticles() {
        showLoading()
        let request = Home.GetArticles.Request()
        interactor?.doGetArticles(request: request)
        interactor?.doGetArticles(request: Home.GetArticles.Request(period: .sevenDays))
        interactor?.doGetArticles(request: Home.GetArticles.Request(period: .thirtyDays))
    }
    
    func displayArticles(viewModel: Home.GetArticles.ViewModel) {
        hideLoading(completion: {[weak self] in
            self?.refreshControl.endRefreshing()
            if viewModel.period == .oneDay {
                self?.viewed1Day = viewModel.articles ?? []
                self?.articleCollectionView.reloadSections(IndexSet(integer: 0))
            } else if viewModel.period == .sevenDays {
                self?.viewed7Days = viewModel.articles ?? []
                self?.articleCollectionView.reloadSections(IndexSet(integer: 1))
            } else if viewModel.period == .thirtyDays {
                self?.viewed30Days = viewModel.articles ?? []
                self?.articleCollectionView.reloadSections(IndexSet(integer: 2))
            }
        })
    }
    
    func displayError(message: String) {
        hideLoading(completion: {[weak self] in
            self?.refreshControl.endRefreshing()
            self?.showAlert(message: message)
        })
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    @objc private func refresh(_ sender: AnyObject) {
        doGetArticles()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewed1Day.count
        } else if section == 1 {
            return viewed7Days.count
        }  else {
            return viewed30Days.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArticleHeaderView.className, for: indexPath) as? ArticleHeaderView else {
            return ArticleHeaderView()
        }
        let section = indexPath.section
        if section == 0 {
            headerView.headerTitle.text = "Viewed 1 Day"
        } else if section == 1 {
            headerView.headerTitle.text = "Viewed 7 Days"
        } else if section == 2 {
            headerView.headerTitle.text = "Viewed 30 Days"
        }
        
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.className, for: indexPath) as? ArticleCell
            cell?.configure(with: viewed1Day[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MinArticleCell.className, for: indexPath) as? MinArticleCell
            cell?.configure(with: viewed7Days[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalArticleCell.className, for: indexPath) as? HorizontalArticleCell
            cell?.configure(with: viewed30Days[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToDetails()
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            if section == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(250)
                    ),
                    subitem: item,
                    count: 1
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.boundarySupplementaryItems = [headerItem]
                return section
            } else if section == 1 {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1/3),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(200)
                    ),
                    subitem: item,
                    count: 3
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                return section
            } else  {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(200)
                    )
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(200*20)
                    ),
                    subitem: item,
                    count: 20
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [headerItem]
                return section
            }
        }
    }
}
