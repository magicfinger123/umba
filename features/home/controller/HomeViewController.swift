//
//  HomeViewController.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//
import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import Reusable
import SnackBar_swift


fileprivate enum CellModel{
    case latestMovie
    case upcomingMovies
    case popularMovies
}
fileprivate struct SectionOfCustomData {
    var header: String
    var items: [CellModel]
}

extension SectionOfCustomData: SectionModelType {
    init(original: SectionOfCustomData, items: [CellModel]) {
        self = original
        self.items = items
    }
}
class HomeViewController: BaseViewController, StoryboardBased, HorinzontalTableViewCellProtocol, LatestMovieCLick {
    func onLatestMovieClick() {
        var m = Movie()
        m.overview = latestMovieDetail?.overview
        m.title = latestMovieDetail?.title
        m.voteAverage = latestMovieDetail?.voteAverage
        m.voteCount = latestMovieDetail?.voteCount
        m.posterPath = latestMovieDetail?.posterPath ?? "/bfUO1SBTfgcK77em3lOuRFY2uLc.jpg"
        coordinator.openMovieDetail(movie: m)
    }
    
    func onSeeAll(typ: LIST_TYPE!) {
        coordinator.openMovieList(typ: typ)
    }
    
    func onMovieClick(movie: Movie) {
        coordinator.openMovieDetail(movie: movie)
    }
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var sectionModels:[SectionOfCustomData] = []
    fileprivate var dataSubject = PublishSubject<[SectionOfCustomData]>()
    fileprivate var data: RxTableViewSectionedReloadDataSource<SectionOfCustomData>?
    var popularMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var latestMovieDetail: MovieDetailResponse?
    var coordinator: HomeCoordinator!
    let refreshControl = UIRefreshControl()

    private func initMovies(page: Int) {
        viewModel.getLatestMovie()
        viewModel.getPopularModel(page: String(page))
        viewModel.getUpcomingMovies(page: String(page))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
         tableView.addSubview(refreshControl) // not required when using UITableViewController

        initTableView()
        initMovies(page: 1)
        viewModel.popularMoviesSubject.asObserver().subscribe{[self]
            result in
            refreshControl.endRefreshing()
          
            if result.element!.results!.count > 0 {
                popularMovies = result.element!.results!
                initSections()
            }
            
        }.disposed(by: disposeBag)
        viewModel.upcomingMoviesSubject.asObserver().subscribe{[self]
            result in
            refreshControl.endRefreshing()
            if result.element!.results!.count > 0 {
                upcomingMovies = result.element!.results!
                initSections()
            }
        }.disposed(by: disposeBag)
        viewModel.latestMovieSubject.asObserver().subscribe{[self]
            result in
            refreshControl.endRefreshing()
            latestMovieDetail = result.element!
            initSections()
        }.disposed(by: disposeBag)
        viewModel.networkErrorSubject.asObservable().subscribe(onNext: {[self]
            message in
            if message.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                SnackBar.make(in: self.view, message: "Network Error", duration: .infinite).setAction(with: "Retry", action: {
                 initMovies(page: 1)
                 }).show()
                viewModel.networkErrorSubject.accept("")
            }
          //
        },onError: { error in
        }).disposed(by: disposeBag)
        viewModel.getSavedMovies(name: "upcoming")
        viewModel.getSavedMovies(name: "popular")
        
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        initMovies(page: 1)
    }
    func popularCell(from table: UITableView) -> UITableViewCell{
        table.register(UINib(nibName: "HorinzontalTableViewCell", bundle: nil), forCellReuseIdentifier: "HorinzontalTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "HorinzontalTableViewCell") as! HorinzontalTableViewCell
        cell.delegate = self
        cell.typ = .POPULAR
        cell.title.text = "Popular Movies"
        cell.movieSubjects.onNext(popularMovies)
        return cell
    }
    func upcomingCell(from table: UITableView) -> UITableViewCell{
        table.register(UINib(nibName: "HorinzontalTableViewCell", bundle: nil), forCellReuseIdentifier: "HorinzontalTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "HorinzontalTableViewCell") as! HorinzontalTableViewCell
        cell.delegate = self
        cell.typ = .UPCOMIMG
        cell.title.text = "upcoming Movies"
        cell.movieSubjects.onNext(upcomingMovies)
        return cell
    }
    func latestMovie(from table: UITableView) -> UITableViewCell{
        table.register(UINib(nibName: "LatestMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "LatestMovieTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "LatestMovieTableViewCell") as! LatestMovieTableViewCell
        cell.cellTitle.text = latestMovieDetail?.title
        cell.delegate = self
       // cell.cellBody.text = latestMovieDetail?.overview
        embedImage(imageItem: cell.cellImage, url: AppUrls.IMAGE_PATH+(latestMovieDetail?.posterPath ?? "/bfUO1SBTfgcK77em3lOuRFY2uLc.jpg"))
        return cell
    }
    private func initTableView() {
        data = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: { dataSource, table, indexPath, item in
           switch item {
           case .upcomingMovies:
               return self.popularCell(from: table)
           case .popularMovies:
               return self.upcomingCell(from: table)
           case .latestMovie:
               return self.latestMovie(from: table)
           }
       })
        data?.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        dataSubject
          .bind(to: tableView.rx.items(dataSource: data!))
          .disposed(by: disposeBag)
    }
    fileprivate func initSections() {
        sectionModels.removeAll()
        if latestMovieDetail != nil{
            sectionModels.append(SectionOfCustomData(header: "", items: [CellModel.latestMovie]))
        }else{
            viewModel.getLatestMovie()
        }
        sectionModels.append(SectionOfCustomData(header: "", items: [CellModel.upcomingMovies]))
        sectionModels.append(SectionOfCustomData(header: "", items: [CellModel.popularMovies]))
        dataSubject.onNext( sectionModels )
    }
    
}
