//
//  LatestMovieTableViewCell.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol LatestMovieCLick{
    func onLatestMovieClick()
}
class LatestMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBody: UILabel!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    var disposeBag = DisposeBag()
    var tapGesture =  UITapGestureRecognizer()
    var delegate: LatestMovieCLick?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tapGesture.rx.event.subscribe{ [self]
            _ in
            delegate?.onLatestMovieClick()
        }.disposed(by: disposeBag)
        self.addGestureRecognizer(tapGesture)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
