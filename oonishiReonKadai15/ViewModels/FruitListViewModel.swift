//
//  FruitListViewModel.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol FruitListViewModelInput {
    func viewWillAppear()
    func cellDidTapped(fruit: Fruit)
}

protocol FruitListViewModelOutput: AnyObject {
    var event: Driver<FruitListViewModel.Event> { get }
    var fruits: Driver<[Fruit]> { get }
}

protocol FruitListViewModelType {
    var inputs: FruitListViewModelInput { get }
    var outputs: FruitListViewModelOutput { get }
}

final class FruitListViewModel {
    
    init(addFruitButtonObservable: Observable<Void>) {
        setupBindings()
        
        addFruitButtonObservable
            .subscribe(onNext: {
                self.eventRelay.accept(.presentAddFruitVC)
            })
            .disposed(by: disposeBag)
    }
    
    enum Event {
        case presentAddFruitVC
    }
    private let fruitUseCase = FruitUseCase(
        repositry: FruitRepository(
            dataStore: FruitRealmDataStore()
        )
    )
    private let disposeBag = DisposeBag()
    private let eventRelay = PublishRelay<Event>()
    private let fruitsRelay = BehaviorRelay<[Fruit]>(value: [])
    
    private func setupBindings() {
        fruitUseCase.fruits
            .bind(to: fruitsRelay)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Input
extension FruitListViewModel: FruitListViewModelInput {
    
    func viewWillAppear() {
        fruitUseCase.loadAllFruits()
    }
    
    func cellDidTapped(fruit: Fruit) {
        fruitUseCase.updateIsSelected(fruit: fruit)
        fruitUseCase.loadAllFruits()
    }
    
}

// MARK: - Output
extension FruitListViewModel: FruitListViewModelOutput {
    
    var event: Driver<Event> {
        eventRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var fruits: Driver<[Fruit]> {
        return fruitsRelay.asDriver()
    }
    
}

extension FruitListViewModel: FruitListViewModelType {
    
    var inputs: FruitListViewModelInput {
        return self
    }
    
    var outputs: FruitListViewModelOutput {
        return self
    }
    
}
