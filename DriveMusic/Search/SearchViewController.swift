//
//  SearchViewController.swift
//  DriveMusic
//
//  Created by Quasar on 01.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: AnyObject {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?

    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel.init(cells: [])
    private var timer: Timer?

    @IBOutlet weak var table: UITableView!
    
    
  // MARK: Object lifecycle
  

  // MARK: Setup
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
      setup()

      setupTableView()
      setupSearchBar()
  }

    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        let nibFile = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nibFile, forCellReuseIdentifier: TrackCell.reuseId)
    }


  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .some:
          print("ViewController .some")
      case .displayTracks(let searchViewModel):
          print("ViewController .displayTracks")
          self.searchViewModel = searchViewModel
          table.reloadData()
      }

  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell

        let cellViewModel = searchViewModel.cells[indexPath.row]
        print("cellViewModel.previewUrl", cellViewModel.previewUrl)
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)


        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension SearchViewController:  UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })

    }
}
