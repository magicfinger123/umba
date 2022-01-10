//
//  GetStartedViewController.swift
//  Umba
//
//  Created by CWG Mobile Dev on 09/01/2022.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

class GetStartedViewController: BaseViewController, StoryboardBased{

    var coordinator: HomeCoordinator!
    @IBOutlet weak var proceedBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        proceedBtn.rx.tap.subscribe{ [self]
            _ in
            coordinator.openHomePage()
        }.disposed(by: disposeBag)
    }
}
