import UIKit

final class MyCabinetCollectionViewController: UICollectionViewController, TutorialDelegate {
    let myCabinetCollectionViewModel = MyCabinetCollectionViewModel()
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Cabinet"
        self.view.backgroundColor = AppFeatures.backgroundColor
        let nc = NotificationCenter.default
        let notification = Notification.Name(rawValue: "updateMyCabinet")
        nc.addObserver(self,
                       selector: #selector(self.didUpdateMyCabinet),
                       name: notification,
                       object: nil)
        self.setupNavigationBar()
        self.setupCollectionView()
        self.setUpSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView?.reloadData()
        self.collectionView?.reloadInputViews()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            var cellSize = UIScreen.main.bounds.size
            cellSize.width *= 0.45
            cellSize.height = cellSize.width + 30
            layout.itemSize = cellSize
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
        guard self.myCabinetCollectionViewModel.tutorialState?.isActive ?? true else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.myCabinetTitle,
                          message: TutorialState.myCabinetMessage,
                          alertActionTitle: "OK!",
                          completion: self.myCabinetCollectionViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - Setup functions
extension MyCabinetCollectionViewController {
    private func setupNavigationBar() {
        self.navigationController?.view.backgroundColor = AppFeatures.backgroundColor
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isOpaque = true
    }

    private func setupCollectionView() {
        self.collectionView.backgroundColor = .clear
        MyCabinetCollectionViewCell.register(with: self.collectionView)
    }

    private func setUpSearchController() {
        self.searchController = UISearchController(searchResultsController: IngredientSearchResultsTVC())
        self.searchController?.searchResultsUpdater = self
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.searchBar.placeholder = "Search"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    @objc func didUpdateMyCabinet() {
        self.collectionView?.reloadData()
        self.collectionView?.reloadInputViews()
    }

    func deleteAlertController(indexPath: IndexPath, ingredient: Ingredient) {
        let alertControler = UIAlertController(title: "Delete!", message: "Would you like to delete this item (\(IngredientController.shared.ingredients[indexPath.row].name))?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
            IngredientController.shared.delete(ingredient: ingredient)
            self?.collectionView?.reloadData()
            self?.collectionView?.reloadInputViews()
            CabinetController.shared.cabinetHasBeenUpdated = true
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
        alertControler.addAction(cancelAction)
        alertControler.addAction(deleteAction)
        self.present(alertControler, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension MyCabinetCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return IngredientController.shared.ingredients.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MyCabinetCollectionViewCell.dequeue(from: collectionView, for: indexPath)
        cell.configure(with: IngredientController.shared.ingredients[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "searchHeader",
                                                                       for: indexPath)
            if let searchController = searchController { view.addSubview(searchController.searchBar) }
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: UICollectionViewDelegate
extension MyCabinetCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        deleteAlertController(indexPath: indexPath, ingredient: IngredientController.shared.ingredients[indexPath.row])
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 canPerformAction action: Selector,
                                 forItemAt indexPath: IndexPath,
                                 withSender sender: Any?) -> Bool {
        return false
    }
}

// MARK: - UISearchResultsUpdating
extension MyCabinetCollectionViewController: UISearchResultsUpdating {
    var isSearchBarEmpty: Bool {
        return self.searchController?.searchBar.text?.isEmpty ?? true
    }

    func updateSearchResults(for searchController: UISearchController) {
        self.myCabinetCollectionViewModel.filterContentFor(searchController) { (view) in
            DispatchQueue.main.async {
                view?.tableView.reloadData()
            }
        }
    }
}
