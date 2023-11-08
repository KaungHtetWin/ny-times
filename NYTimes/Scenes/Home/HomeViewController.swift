//
//  HomeVC.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayHome(viewModel: Home.GetArticles.ViewModel)
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
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    // MARK: IBAction
    
    // @IBAction private func btnTapped(_ sender: UIButton) {
    
    // }
    
    // MARK: SetupView
    
    private func setupView() {
        
    }
    
    func doGetArticles() {
        showLoading()
        let request = Home.GetArticles.Request()
        interactor?.doGetHome(request: request)
    }
    
    func displayHome(viewModel: Home.GetArticles.ViewModel) {
        hideLoading(completion: {[weak self] in
            
        })
    }
    
    func displayError(message: String) {
        hideLoading(completion: {[weak self] in
            self?.showAlert(message: message)
        })
    }
}
