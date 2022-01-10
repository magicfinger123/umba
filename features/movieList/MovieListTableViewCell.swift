//
//  MovieListTableViewCell.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import UIKit
import RxCocoa
import RxSwift

class MovieListTableViewCell: UITableViewCell, UICollectionViewDelegate {

    var disposeBag = DisposeBag()
    var delegate:HorinzontalTableViewCellProtocol!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movieItemSubjects = BehaviorRelay<[Movie]>(value: [])
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "MovieItemCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "MovieItemCollectionViewCell")
        movieItemSubjects
        .asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: "MovieItemCollectionViewCell", cellType: MovieItemCollectionViewCell.self)) {
                row, data, cell in
                cell.movieTitle.text = data.title
                cell.releaseDate.text = data.releaseDate
                cell.ratings.rating = data.voteAverage!
                cell.ratings.settings.updateOnTouch = false
                cell.votes.text = "votes(\(data.voteCount!))  "
                embedImage(imageItem: cell.cellImage, url: AppUrls.IMAGE_PATH+(data.posterPath ?? ""))
            }.disposed(by: disposeBag)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        Observable.zip(
            collectionView.rx.itemSelected
            ,collectionView.rx.modelSelected(Movie.self))
            .asObservable()
            .bind{ [self] indexPath, model in
                delegate.onMovieClick(movie: model)
            }
            .disposed(by: disposeBag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    
}
extension MovieListTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = collectionView.bounds.width
        let cellWidth = (width - 20) / 2// compute your cell width
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
     }
}
