//
//  HorinzontalTableViewCell.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import UIKit
import RxSwift
import RxCocoa

protocol HorinzontalTableViewCellProtocol{
    func onMovieClick(movie: Movie)
    func onSeeAll(typ: LIST_TYPE!)
}
class HorinzontalTableViewCell: UITableViewCell, UICollectionViewDelegate {
    @IBOutlet weak var seeAllBtn: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var movieSubjects  = PublishSubject<[Movie]>()
    var disposeBag = DisposeBag()
    var typ: LIST_TYPE!
    var delegate:HorinzontalTableViewCellProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(UINib(nibName: "MovieListCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "MovieListCollectionViewCell")
        movieSubjects
        .asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: "MovieListCollectionViewCell", cellType: MovieListCollectionViewCell.self)) { [self]
                row, data, cell in
                cell.cellName.text = data.title
                embedImage(imageItem: cell.cellImage, url: AppUrls.IMAGE_PATH+data.posterPath!)
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
        seeAllBtn.rx.tap.subscribe{[self]
            _ in
            delegate.onSeeAll(typ: typ)
        }.disposed(by: disposeBag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension HorinzontalTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width-10)/2.3
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}
