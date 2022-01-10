//
//  HomeCoordinator.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .other }
    func start() {
        let vc = GetStartedViewController.instantiate()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    func openHomePage(){
        let vc = HomeViewController.instantiate()
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: true)
    }
    func openMovieDetail(movie: Movie){
        let vc = MovieDetailViewController.instantiate()
        vc.movie = movie
        vc.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
    func openMovieList(typ: LIST_TYPE){
        let vc = MovieListViewController.instantiate()
        vc.typ = typ
        vc.coordinator = self
        vc.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(vc, animated: true)
    }
   
}

