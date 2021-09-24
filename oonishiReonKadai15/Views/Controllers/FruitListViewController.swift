//
//  FruitListViewController.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxDataSources

final class FruitListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addFruitButton: UIBarButtonItem!
    
    private let viewModel: FruitListViewModelType = FruitListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFruitButton.rx.tap
            .subscribe(onNext: viewModel.inputs.addFruitButtonDidTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                guard let self = self else { return }
                switch event {
                    case .presentAddFruitVC:
                        // センイ
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
