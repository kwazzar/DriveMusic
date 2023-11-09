//
//  TrackDetailView.swift
//  DriveMusic
//
//  Created by Quasar on 07.11.2023.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    let player: AVPlayer = {
        let avplayer = AVPlayer()
        avplayer.automaticallyWaitsToMinimizeStalling = false
        return avplayer
        
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.backgroundColor = .red
    }
    
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let urlImage = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: urlImage)
    }
    
    private func playTrack(previewUrl: String?) {
        print("Try play track with url: \(previewUrl ?? "nil" )")
        
        guard let urlTrack = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: urlTrack)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    @IBAction func handleCurrentTimerSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        
        self.removeFromSuperview()
    }
    
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(imageLiteralResourceName: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(imageLiteralResourceName: "play"), for: .normal)
        }
        
        
    }
}


