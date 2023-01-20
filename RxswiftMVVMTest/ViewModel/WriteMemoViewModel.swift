//
//  WriteMemoViewModel.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2023/01/09.
//

import Foundation
import RxSwift

class WriteMemoViewModel {
    
    let disposeBag = DisposeBag()
    
    let memo = PublishSubject<Memo>()
    
    let titleText = BehaviorSubject<String>(value: "")
    let contentText = BehaviorSubject<String>(value: "")
    
    let isTitleValid = BehaviorSubject(value: false)
    let isContentValid = BehaviorSubject(value: false)
    
    init() {
        
        _ = titleText
            .map(validateTitle(_:))
            .distinctUntilChanged()
            .bind(to: isTitleValid)
        
        _ = contentText
            .map(validateContent(_:))
            .distinctUntilChanged()
            .bind(to: isContentValid)
        
    }
    
    private func validateTitle(_ title : String) -> Bool {
        return title.count > 0
    }
    
    private func validateContent(_ content: String) -> Bool {
        return content.count >= 0
    }
    
    func addMemo() {
        Observable.zip(titleText, contentText)
            .map { Memo(title: $0, content: $1) }
            .bind(to: memo)
            .disposed(by: disposeBag)
    }
}

