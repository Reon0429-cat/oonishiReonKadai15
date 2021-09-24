//
//  AddFruitViewController.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddFruitVCDelegate: AnyObject {
    func fruitDidSaved()
}

final class AddFruitViewController: UIViewController {
    
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var fruitNameTextField: UITextField!
    
    weak var delegate: AddFruitVCDelegate?
    private let viewModel: AddFruitViewModelType = AddFruitViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        
    }
    
    private func setupBindings() {
        saveButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.inputs.saveButtonDidTapped(
                    fruitNameText: self.fruitNameTextField.text
                )
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: viewModel.inputs.cancelButtonDidTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                switch event {
                    case .returnToPreviousScreen:
                        self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}
