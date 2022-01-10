//
//  MovieItemCollectionViewCell.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import UIKit
import Cosmos

class MovieItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var votes: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var ratings: CosmosView!
    @IBOutlet weak var movieTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
