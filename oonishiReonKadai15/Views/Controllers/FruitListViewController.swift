//
//  FruitListViewController.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FruitListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addFruitButton: UIBarButtonItem!
    
    private let viewModel: FruitListViewModelType = FruitListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.inputs.viewWillAppear()
        
    }
    
    private func setupBindings() {
        addFruitButton.rx.tap
            .subscribe(onNext: viewModel.inputs.addFruitButtonDidTapped)
            .disposed(by: disposeBag)
        
        viewModel.outputs.event
            .drive(onNext: { [weak self] event in
                guard let strongSelf = self else { return }
                switch event {
                    case .presentAddFruitVC:
                        strongSelf.presentAddFruitVC()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.fruits
            .drive(tableView.rx.items) { tableView, row, fruit in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FruitListTableViewCell.identifier
                ) as! FruitListTableViewCell
                cell.configure(fruit: fruit)
                return cell
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected,
                       tableView.rx.modelSelected(Fruit.self))
            .bind { [weak self] indexPath, fruit in
                guard let strongSelf = self else { return }
                strongSelf.tableView.deselectRow(at: indexPath, animated: true)
                strongSelf.viewModel.inputs.cellDidTapped(fruit: fruit, at: indexPath.row)
            }
            .disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(FruitListTableViewCell.nib,
                           forCellReuseIdentifier: FruitListTableViewCell.identifier)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func presentAddFruitVC() {
        let addFruitVC = UIStoryboard(name: "AddFruit", bundle: nil)
            .instantiateViewController(withIdentifier: String(describing: AddFruitViewController.self)
            ) as! AddFruitViewController
        self.navigationController?.pushViewController(addFruitVC, animated: true)
    }
    
}

extension FruitListViewController: UIScrollViewDelegate { }
