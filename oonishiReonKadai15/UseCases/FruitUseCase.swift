//
//  FruitUseCase.swift
//  oonishiReonKadai15
//
//  Created by 大西玲音 on 2021/09/24.
//

import Foundation
import RxSwift
import RxRelay

final class FruitUseCase {
    
    private let repository: FruitRepositoryProtocol
    init(repositry: FruitRepositoryProtocol) {
        self.repository = repositry
        setupBindings()
    }
    
    private let disposeBag = DisposeBag()
    private let saveFruitTrigger = PublishRelay<Fruit>()
    private let loadAllFruitsTrigger = PublishRelay<Void>()
    private let updateFruitTrigger = PublishRelay<(fruit: Fruit, index: Int)>()
    private let fruitsRelay = BehaviorRelay<[Fruit]>(value: [])
    
    var fruits: Observable<[Fruit]> {
        return fruitsRelay.asObservable()
    }
    
    private func setupBindings() {
        saveFruitTrigger
            .flatMapLatest(repository.save(fruit:))
            .subscribe()
            .disposed(by: disposeBag)
        
        loadAllFruitsTrigger
            .flatMapLatest(repository.loadAllFruits)
            .bind(to: fruitsRelay)
            .disposed(by: disposeBag)
        
        updateFruitTrigger
            .flatMapLatest { fruit, index -> Completable in
                self.repository.update(fruit: fruit, at: index)
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func save(fruit: Fruit) {
        saveFruitTrigger.accept(fruit)
    }
    
    func loadAllFruits() {
        loadAllFruitsTrigger.accept(())
    }
    
    func updateIsSelected(fruit: Fruit, index: Int) {
        let newFruit = Fruit(name: fruit.name,
                             isSelected: !fruit.isSelected)
        updateFruitTrigger.accept((fruit: newFruit, index: index))
    }
    
}
