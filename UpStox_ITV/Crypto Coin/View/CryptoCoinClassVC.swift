//
//  ViewController.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 13/11/24.
//

import UIKit

class CryptoCoinClassVC: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // ViewModel for managing the data related.
    var coinViewModel: CoinViewModel? = nil
    
    // UI elements for filtering, searching and Nav bar.
    private var filterView: FilterView?
    private var customNavBar: CustomNavigationBar?
    private var customSearchBar: CustomSearchBar?
    private var refreshControl: UIRefreshControl?
    private var errorView: ErrorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coinViewModel = CoinViewModel(delegate: self,
                                           dataManager: CDCrptoDataManager(objDataRepositery: CDCrptoDataRepository()),
                                           apiManager: CoinAPIResources(httpUtility: HttpUtility())
        )
        self.setupNavigationBar()
        self.setupTableView()
        self.setUpSearchBar()
        self.addFilterView()
        self.getCoinList()
        self.addErrorView()
    }
    
    // Sets up the table view layout and constraints.
    func setupTableView() {
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.customNavBar!.topAnchor, constant: 64),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        self.setupPullToRefresh()
    }

    // Setup the pull-to-refresh control
    func setupPullToRefresh() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = .blue
        self.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    // Handle the pull-to-refresh action
    @objc func refreshData() {
        self.refreshControl?.endRefreshing()
        
        // Reset the filter options
        self.resetFilter()
        
        // hiding the search bar
        self.customSearchBar?.clearTextField()
        self.customSearchBar?.isHidden = true
        
        // Checking Internet connection and calling an API
        if NetworkReachability.shared.isInternetAvailable() {
            self.coinViewModel?.getCoinList(isPullToRefreshTriggered: true)
        }
    }
    
    // Configures the search bar and its constraints.
    func setUpSearchBar() {
        self.customSearchBar = CustomSearchBar(
            frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 50),
            placeholder: StringMessage.searchPlaceHolder.value,
            cancelButtonColor: .white,
            delegate: self,
            cancelButtonAction: { [weak self] in
                self?.onTapSearch() // to hide the search bar
                self?.customSearchBar?.clearTextField() // to clear the text Field and with dismiss the keyboard
                self?.coinViewModel?.filterDataBasedOnSearch(searchText: nil) // loading data
            }
        )
        self.customSearchBar?.backgroundColor = UIColor.blue
        self.view.addSubview(self.customSearchBar!)
        self.customSearchBar?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customSearchBar!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customSearchBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSearchBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customSearchBar!.heightAnchor.constraint(equalToConstant: 64)
        ])
        self.customSearchBar?.isHidden = true
    }
    
    // Sets up the custom navigation bar with buttons for search and filter actions.
    func setupNavigationBar() {
        self.customNavBar = CustomNavigationBar(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64),
            title: StringMessage.navigationBarTitle.value,
            rightButtonImageName: ["magnifyingglass", "line.horizontal.3.decrease.circle"]
        ) {[weak self] index in
            switch index {
            case 0:
                self?.onTapSearch()
            case 1:
                self?.onTapFilter()
            default:
                break
            }
        }
        self.customNavBar?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customNavBar!)
        NSLayoutConstraint.activate([
            customNavBar!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar!.heightAnchor.constraint(equalToConstant: 64)
        ])
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.blue
    }
    
    // Adds an error view to the tableView with a message when no data is available or an error occurs. This error view will appear as the background of the tableView and can be customized with the provided title and text color.
    func addErrorView() {
        self.errorView = ErrorView(
            frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 64),
            title: StringMessage.noData.value,
            titleTextColor: .black
            )
        self.errorView?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundView = self.errorView
        NSLayoutConstraint.activate([
            errorView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView!.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            errorView!.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor)
        ])
        self.backgroundViewWithErroView(shouldShow: true)
    }
    
    // Toggles the visibility of the search bar when the search button is tapped.
    func onTapSearch() {
        self.filterView?.isHidden = true
        self.customSearchBar?.isHidden.toggle()
        if !(self.customSearchBar?.isHidden ?? false) {
            self.customSearchBar?.becomeResponder()
        }
        self.resetFilter()
    }
    
    // Resets the filter view and applies default filter options.
    func resetFilter() {
        self.customNavBar?.filterDot.isHidden = true
        self.filterView?.resetFilter()
        self.coinViewModel?.applyFilter(selectedFilterOptions: [])
    }
    
    // Toggles the visibility of the filter view when the filter button is tapped.
    func onTapFilter() {
        guard let filterView = self.filterView else { return }
        if filterView.isHidden {
            filterView.isHidden = false
            self.filterView?.performAnimation(isHide: false)
        } else {
            self.filterView?.performAnimation(isHide: true, animations: {
                filterView.isHidden = true
            })
        }
    }

    // Sets up the Filter view with Done Button to apply the filter and showing the DOT.
    private func addFilterView() {
        self.filterView = FilterView(frame: self.view.bounds)
        self.filterView?.translatesAutoresizingMaskIntoConstraints = false
        self.filterView?.backgroundColor = .lightGray.withAlphaComponent(0.3)
        self.view.addSubview(self.filterView!)
        self.filterView?.isHidden = true
                
        NSLayoutConstraint.activate([
            filterView!.topAnchor.constraint(equalTo: tableView.topAnchor),
            filterView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView!.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
        ])
        self.filterView?.doneButtonTapped = { [weak self] selectedFilterOptions in
            self?.onTapFilter()
            self?.customNavBar?.filterDot.isHidden = selectedFilterOptions.isEmpty
            self?.coinViewModel?.applyFilter(selectedFilterOptions: selectedFilterOptions)
        }
    }
    
    deinit {
        debugPrint("CryptoCoinClassVC deinit")
    }
    
    // Call the below method to clear data and remove views from the screen. It is useful for resetting, cleaning up, or transitioning to a new screen.
    private func clearData() {
        self.filterView?.removeFromSuperview()
        self.customNavBar?.removeFromSuperview()
        self.customSearchBar?.removeFromSuperview()
        self.filterView = nil
        self.customNavBar = nil
        self.customSearchBar = nil
        self.coinViewModel = nil
    }
    
    // Fetches the list of coins from the ViewModel.
    func getCoinList() {
        self.view.activityStartAnimating()
        self.coinViewModel?.getCoinList()
    }
    
    // Reloads the table view when the data is updated.
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// Shows or hides the search and filter buttons based on whether data is available.
    /// - Parameter shouldShow: A boolean indicating whether to show or hide the buttons.
    /// If data is available, the buttons are displayed; otherwise, they remain hidden.
    func updateSearchAndFilterButtonsVisibility() {
        if self.coinViewModel?.numberOfRowsInSection() == 0 {
            self.customNavBar?.setRightButtonsVisibility(shouldShow: true)
            self.backgroundViewWithErroView(shouldShow: false)
        } else {
            self.customNavBar?.setRightButtonsVisibility(shouldShow: false)
            self.backgroundViewWithErroView(shouldShow: true)
        }
    }
    
    // Show the error view by calling the backgroundViewWithErrorView method
    private func backgroundViewWithErroView(shouldShow: Bool) {
        if self.customSearchBar?.isHidden ?? true == true {
            self.tableView.backgroundView?.isHidden = shouldShow
            self.errorView?.isHidden = shouldShow
        } else {
            // No need to show the background text during search
            self.tableView.backgroundView?.isHidden = true
            self.errorView?.isHidden = true
        }
    }
}

extension CryptoCoinClassVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.customSearchBar?.resignResponder()
    }
}
