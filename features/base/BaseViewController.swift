//
//  BaseViewController.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import SnackBar_swift

class BaseViewController: UIViewController {

    var reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    var disposeBag = DisposeBag()
    var viewModel =  HomeVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        reachabilityListener()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        // Do any additional setup after loading the view.
    }
    func reachabilityListener(){
        self.reachabilityManager?.startListening { status in
            switch status {
            case .unknown:
                self.viewModel.networkErrorSubject.accept("Network unknown")
            case .notReachable:
                self.viewModel.networkErrorSubject.accept("Network unavailable")
            case .reachable(_):
                self.viewModel.networkErrorSubject.accept("")
            }
        }
       
    }
//
//    func showErrorMessage(vm: HomeVM){
//        vm.errorMsgObs.asObservable().subscribe(onNext: {[self]
//            message in
//            if message.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
//                vm.errorMsgObs.accept("")
//                vm.hideState.accept(true)
//                if message.lowercased() != "could not connect"{
//                    showAlert(with: "Error", message: message)
//                }
//            }
//        },onError: { error in
//
//        }).disposed(by: disposeBag)
//    }
//
//    func hideState(vm: HomeVM){
//        vm.hideState.asObservable().subscribe(onNext: {[self]
//            result in
//            if result == true {
//                apiStateUI.showAlert(state: .success, dismissProtocol: self)
//            }
//            else {
//                apiStateUI.showAlert(state: .loading, dismissProtocol: self)
//            }
//        },onError: { error in
//        }).disposed(by: disposeBag)
//        vm.networkErrorSubject.asObserver().subscribe{
//            result in
//            self.showAlert(with: "Network Error", message: result.element ?? "Network Unavailable")
//        }.disposed(by: disposeBag)
//    }

}
