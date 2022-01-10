//
//  AppCoordinator.swift
//  Umba
//
//  Created by CWG Mobile Dev on 06/01/2022.
//

import Foundation
import UIKit

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
enum CoordinatorType {
    case home, other, app
}
protocol AppCoordinatorProtocol: Coordinator {
    func showHomePage()
    func showCarDetails()
}
final class AppCoordinator : AppCoordinatorProtocol{
    func showCarDetails() {
        //let navigationController = UINavigationController()
//        let appLaunchCordinator = ApplaunchCordinator.init(navigationController: navigationController)
//        appLaunchCordinator.finishDelegate = self
//        appLaunchCordinator.start()
//        childCordinators.append(appLaunchCordinator)
        
    }
    func  showHomePage() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let tabCoordinator = HomeCoordinator.init(navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }

    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorType { .app }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(false, animated: true)
    }
    private(set)  var childCordinators: [Coordinator] = []
    func start() {
    showHomePage()
    }
}
extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        case .other:
            navigationController.viewControllers.removeAll()
            showHomePage()
        case .app, .home:
            navigationController.viewControllers.removeAll()
            showCarDetails()
        }
    }
}


