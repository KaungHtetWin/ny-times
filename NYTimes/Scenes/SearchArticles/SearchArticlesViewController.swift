//
//  SearchArticlesViewController.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit

protocol SearchArticlesDisplayLogic: AnyObject {
    func displaySearchArticles(viewModel: SearchArticles.Search.ViewModel)
    func displayError(message: String)
}

class SearchArticlesViewController: UIViewController, SearchArticlesDisplayLogic {
    var interactor: SearchArticlesBusinessLogic?
    var router: (NSObjectProtocol & SearchArticlesRoutingLogic & SearchArticlesDataPassing)?
    
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
        let interactor = SearchArticlesInteractor()
        let presenter = SearchArticlesPresenter()
        let router = SearchArticlesRouter()
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
        doGetSearchArticles(by: "")
    }
    
    // MARK: IBOutlet
    
    @IBOutlet weak var articleSearchBar: UISearchBar!
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    // MARK: IBAction
    
    // @IBAction private func btnTapped(_ sender: UIButton) {
    
    // }
    var searchArticles: [Doc] = []
    private var pendingRequestWorkItem: DispatchWorkItem?
    // MARK: SetupView
    
    private func setupView() {
        setupSearchBar()
        setupCollectionView()
    }
    
    private func setupSearchBar() {
        articleSearchBar.delegate = self
    }
    
    private func setupCollectionView() {
        articleCollectionView.register(UINib.init(nibName: HorizontalArticleCell.className, bundle: nil), forCellWithReuseIdentifier: HorizontalArticleCell.className)
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let space: CGFloat = 3.0 + 16
        let dimension =  (view.frame.size.width - (2 * space))
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: 120)
        articleCollectionView.collectionViewLayout = flowLayout
    }
    
    func doGetSearchArticles(by q: String) {
        showLoading()
        let request = SearchArticles.Search.Request(q: q)
        interactor?.doGetSearchArticles(request: request)
    }
    
    func displaySearchArticles(viewModel: SearchArticles.Search.ViewModel) {
        hideLoading(completion: {[weak self] in
            self?.searchArticles = viewModel.docs ?? []
            self?.articleCollectionView.reloadData()
        })
    }
    
    func displayError(message: String) {
        hideLoading(completion: {[weak self] in
            self?.showAlert(message: message)
        })
    }
    
    deinit {
        print("deinit: \(self.className)")
    }
}

extension SearchArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.routeToDetails()
    }
}

extension SearchArticlesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = searchBar.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if updatedText.isEmpty {
            doGetSearchArticles(by: "")
        } else {
            pendingRequestWorkItem?.cancel()
            
            let requestWorkItem = DispatchWorkItem { [weak self] in
                self?.doGetSearchArticles(by: updatedText)
            }
            
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3,
                                          execute: requestWorkItem)
        }
        
        return true
    }
}

extension SearchArticlesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalArticleCell.className, for: indexPath) as! HorizontalArticleCell
        cell.configure(with: searchArticles[indexPath.row])
        
        return cell
    }
    
}
