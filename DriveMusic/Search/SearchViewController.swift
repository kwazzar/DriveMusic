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

    private lazy var footerView = FooterView()


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
      searchBar(searchController.searchBar, textDidChange: "Metz")
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
        table.tableFooterView = footerView
    }


  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
      switch viewModel {
      case .displayTracks(let searchViewModel):
          print("ViewController .displayTracks")
          self.searchViewModel = searchViewModel
          table.reloadData()
          footerView.hideLoader()
      case .displayFooterView:
          footerView.showLoader()
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
//        print("cellViewModel.previewUrl", cellViewModel.previewUrl)
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row]
        print("cellViewModel.trackName:", cellViewModel.trackName)

        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            let windows = windowScene.windows.filter { $0.isKeyWindow }
            if let window = windows.first {
                let trackDetailsView: TrackDetailView = TrackDetailView.loadFromNib()
                trackDetailsView.set(viewModel: cellViewModel)
                trackDetailsView.delegate = self
                window.addSubview(trackDetailsView)

            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !searchViewModel.cells.isEmpty ? 0 : 250
    }
}
// MARK: - UISearchBarDelegate

extension SearchViewController:  UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })

    }
}

extension SearchViewController: TrackMovingDelegate {

    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }

        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cells[nextIndexPath.row]
        print("cellViewModel.trackName:", cellViewModel.trackName)
        return cellViewModel
    }

    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        print("Go back")
        return getTrack(isForwardTrack: false)
        return nil
    }

    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        print("Go forward")
        return getTrack(isForwardTrack: true)
        return nil

    }
}
