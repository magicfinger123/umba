//
//  MovieListViewController.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift
import RxDataSources
import SnackBar_swift
    
fileprivate enum CellModel{
    case movieCell(movies: [Movie])
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
class MovieListViewController: BaseViewController, StoryboardBased, UITableViewDelegate, HorinzontalTableViewCellProtocol {
    func onSeeAll(typ: LIST_TYPE!) {
    }
    
    func onMovieClick(movie: Movie) {
        coordinator.openMovieDetail(movie: movie)
    }
  
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var coordinator: HomeCoordinator!
    fileprivate var sectionModels:[SectionOfCustomData] = []
    fileprivate var dataSubject = PublishSubject<[SectionOfCustomData]>()
    fileprivate var data: RxTableViewSectionedReloadDataSource<SectionOfCustomData>?
    var page = 1
    var totalPage = 1
    var movies: [Movie] = []
    var moviesArray: [[Movie]] = []
    var productCount = 0
    var typ: LIST_TYPE!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        initTableView()
        viewModel.popularMoviesSubject.asObservable().subscribe{[self]
            result in
            refreshControl.endRefreshing()
            let r = result.element!
            if r.results!.count > 0 {
                page =  r.page ?? 1
                totalPage = r.totalPages ?? 1
                movies.append(contentsOf:  r.results!)
              sortMovie()
            }
            updateSectionModels()
        }.disposed(by: disposeBag)
        viewModel.upcomingMoviesSubject.asObservable().subscribe{[self]
            result in
            refreshControl.endRefreshing()
            let r = result.element!
            if r.results!.count > 0 {
                page =  r.page ?? 1
                totalPage = r.totalPages ?? 1
                movies.append(contentsOf:  r.results!)
              sortMovie()

            }
            updateSectionModels()
        }.disposed(by: disposeBag)
        viewModel.networkErrorSubject.asObservable().subscribe(onNext: {[self]
            message in
//           let s =  SnackBar.make(in: self.view, message: message, duration: .infinite).setAction(with: "Retry", action: {
//             initMovies(page: page)
//             s.dismiss()
//             viewModel.networkErrorSubject.accept("")
//
//            })
            if message.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                if message.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                    SnackBar.make(in: self.view, message: "Network Error", duration: .infinite).setAction(with: "Retry", action: {
                     initMovies(page: 1)
                     }).show()
                    viewModel.networkErrorSubject.accept("")
                }
               //
            }
        },onError: { error in
        }).disposed(by: disposeBag)
        initMovies(page: 1)
      
    }
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        initMovies(page: 1)
    }
    private func initMovies(page: Int) {
        switch typ{
        case .POPULAR:
            pageTitle.text = "Popular Movies"
            viewModel.getPopularModel(page: String(page))
            viewModel.getSavedMovies(name: "popular")
            break
        case .UPCOMIMG:
            pageTitle.text = "Upcoming Movies"
            viewModel.getUpcomingMovies(page: String(page))
            viewModel.getSavedMovies(name: "upcoming")
            break
        case .none:
            break
        }
    }
    func updateSectionModels() {
        sectionModels.removeAll()
        sortMovieSection()
        dataSubject.onNext(sectionModels)
    }
    func sortMovie(){
        let bytesPerRow = 2
        if  movies.count % bytesPerRow != 0 && movies.count > 0{
            movies.append(movies[0])
        }
        assert(movies.count % bytesPerRow == 0)
        let pixels2d: [[Movie]] = stride(from: 0, to: movies.count, by: bytesPerRow).map {
            return  Array(movies[$0..<$0+bytesPerRow])
        }
        moviesArray = pixels2d
        print("pixels2d \(pixels2d)")
        }
    func sortMovieSection(){
        var pCells: [CellModel] = []
        moviesArray.forEach { p in
            pCells.append(CellModel.movieCell(movies: p))
        }
        sectionModels.append(SectionOfCustomData(header: "", items: pCells))
        productCount = pCells.count
    }
    func movieCell(m: [Movie], from table: UITableView)->UITableViewCell {
        table.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell") as! MovieListTableViewCell
        cell.delegate = self
        cell.movieItemSubjects.accept(m)
        return cell
    }
    private func initTableView() {
        data = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: { dataSource, table, indexPath, item in
            switch item {
            case .movieCell(let  movies):
                return self.movieCell(m: movies, from: table)//(from: table)
            }
        })
        data?.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        dataSubject
            .bind(to: tableView.rx.items(dataSource: data!))
            .disposed(by: disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("index path \(indexPath.section) \(indexPath.row)")
        print("seection cells : \(sectionModels.count - 1)")
        if (indexPath.section == sectionModels.count  - 1) && ( indexPath.row == productCount  - 1) && productCount != 0{
            if totalPage > page {
               initMovies(page: page+1)
            }
        }
    }
}
