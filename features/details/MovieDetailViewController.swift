//
//  MovieDetailViewController.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import UIKit
import Cosmos
import Reusable

class MovieDetailViewController: BaseViewController , StoryboardBased{


    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var ratings: CosmosView!
    @IBOutlet weak var movieImage: UIImageView!
    var movie:Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewText.text = movie?.overview
        movieTitle.text = movie?.title
        ratings.rating = movie!.voteAverage!
        ratings.settings.updateOnTouch = false
        embedImage(imageItem: movieImage, url: AppUrls.IMAGE_PATH+movie!.posterPath!)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
