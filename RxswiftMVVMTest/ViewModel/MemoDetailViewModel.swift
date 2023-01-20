//
//  MemoDetailViewModel.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2023/01/17.
//

import Foundation
import RxSwift
import RxCocoa

class MemoDetailViewModel {
    
    let titleText: BehaviorSubject<String>
    let contentText: BehaviorSubject<String>
    
    let deleteBtnTapped: PublishSubject<Bool>
//    let editBtnTapped: PublishSubject<Bool>
    
    let memo: PublishSubject<Memo>
    
    let disposeBag = DisposeBag()
    
    init(selectedMemo: Memo = Memo(title: "", content: "")) {
        deleteBtnTapped = PublishSubject()
//        editBtnTapped = PublishSubject()
        
        memo = PublishSubject()
        
        titleText = BehaviorSubject<String>(value: selectedMemo.title)
        contentText = BehaviorSubject<String>(value: selectedMemo.content)
        
//        editBtnTapped
//            .filter { $0 }
//            .debug()
//            .subscribe(onNext: { _ in
//                self.tapEditButton(title: selectedMemo.title, content: selectedMemo.content)
//            })
//            .disposed(by: disposeBag)
    }
    
    func editMemo() {
        Observable.zip(titleText, contentText)
            .map { Memo(title: $0, content: $1) }
            .bind(to: memo)
            .disposed(by: disposeBag)
    }
    
//    func tapEditButton(title: String, content: String) {
//        titleText.onNext(title)
//        contentText.onNext(content)
//    }
}
