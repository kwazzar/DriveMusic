//
//  SearchViewController.swift
//  DriveMusic
//
//  Created by Quasar on 23.10.2023.
//

import UIKit

struct TrackModel {
    var trackName: String
    var artistName: String
}


class SearchViewController: UITableViewController {
    
    let seachController = UISearchController(searchResultsController: nil)
    
    let tracks = [TrackModel(trackName: "Wasted", artistName: "Metz"),
                 TrackModel(trackName: "Wet Blanket", artistName: "Metz")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    MARK: 8:18 vid
        view.backgroundColor = .white
        
        setupSearchBar()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = seachController
        navigationItem.hidesSearchBarWhenScrolling = false
        seachController.searchBar.delegate = self
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = UIImage(imageLiteralResourceName: "Image")
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
