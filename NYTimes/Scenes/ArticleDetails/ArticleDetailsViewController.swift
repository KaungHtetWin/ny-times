//
//  ArticleDetailsViewController.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import UIKit
import Kingfisher
import SafariServices

protocol ArticleDetailsDisplayLogic: AnyObject {
    func displayArticleDetails(viewModel: ArticleDetails.Get.ViewModel)
}

class ArticleDetailsViewController: UIViewController, ArticleDetailsDisplayLogic {
    var interactor: ArticleDetailsBusinessLogic?
    var router: (NSObjectProtocol & ArticleDetailsRoutingLogic & ArticleDetailsDataPassing)?
    
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
        let interactor = ArticleDetailsInteractor()
        let presenter = ArticleDetailsPresenter()
        let router = ArticleDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        doGetArticlesDetails()
    }
    
    // MARK: IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTopPoster: UIImageView!
    @IBOutlet weak var txtDesription: UITextView!
    @IBOutlet weak var lblByline: UILabel!
    @IBOutlet weak var lblPublicDate: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    // MARK: IBAction
    
    @IBAction func btnReadMoreTapped(_ sender: UIButton) {
        readMoreArticle(articleURL ?? "")
    }
    
    var articleURL: String?
    // MARK: SetupView
    
    private func setupView() {
        
    }
    
    func doGetArticlesDetails() {
        let request = ArticleDetails.Get.Request()
        interactor?.doGetArticleDetails(request: request)
    }
    
    func displayArticleDetails(viewModel: ArticleDetails.Get.ViewModel) {
            if let article = viewModel.article {
                renderArticleDetails(article: article)
            }
            if let doc = viewModel.doc {
                renderArticleDetails(doc: doc)
            }
    }
    
    func renderArticleDetails(article: Article) {
        lblTitle.text = article.title
        lblByline.text = article.byline
        lblSource.text = article.source
        lblPublicDate.text = article.publishedDate
        txtDesription.text = article.abstract
        articleURL = article.url
        setPosterImage(urlString: article.getImage(format: .mediumThreeByTwo440))
    }
    
    func renderArticleDetails(doc: Doc) {
        lblTitle.text = doc.headline?.main
        lblByline.text = doc.byline?.original
        lblSource.text = doc.source
        lblPublicDate.text = doc.pubDate?.displayPublicDate()
        txtDesription.text = doc.abstract
        articleURL = doc.webURL
        setPosterImage(urlString: doc.getImage())
    }
    
    private func setPosterImage(urlString: String?) {
        if let urlString {
            imgTopPoster.kf.indicatorType = .activity
            imgTopPoster.kf.setImage(with: urlString.url, placeholder: UIImage(named: "ico-placeholder"))
        }
    }
    
    deinit {
        print("deinit: \(self.className)")
    }
}
extension ArticleDetailsViewController {
    func readMoreArticle(_ url: String) {
        if let url = URL(string: url) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
