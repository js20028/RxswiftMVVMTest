//
//  MemoViewModel.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2022/12/29.
//

import Foundation
import RxSwift

class MemoViewModel {
    
    enum MemoType {
        case add, edit(IndexPath), delete(IndexPath)
    }
    
    let disposeBag = DisposeBag()
    
    let memo = PublishSubject<(Memo, MemoType)>()
    
    let titleText = BehaviorSubject<String>(value: "")
    let contentText = BehaviorSubject<String>(value: "")
    
    let memoListObservable = BehaviorSubject<[Memo]>(value: [])
    
    private var memoList: [Memo] = [
        Memo(title: "메모1", content: "1"),
        Memo(title: "메모2", content: "2"),
        Memo(title: "메모3", content: "3"),
        Memo(title: "메모4", content: "4"),
        Memo(title: "메모5", content: "5")
    ]
    init() {
        
        _ = memo.subscribe(onNext: { [weak self] memo, type in
            self?.checkMemoType(memo: memo, type: type)
        })
        .disposed(by: disposeBag)

        memoListObservable.onNext(memoList)
    }
    
    func checkMemoType(memo: Memo, type: MemoType) {
        switch type {
        case .add:
            addMemo(memo: memo)
        case let .delete(indexPath):
            deleteMemo(memo: memo, indexPath: indexPath)
        case let .edit(indexPath):
            editMemo(memo: memo, indexPath: indexPath)
        }
    }
    
    private func addMemo(memo: Memo) {
        memoList.append(memo)
        memoListObservable.onNext(memoList)
    }
    
    private func deleteMemo(memo: Memo, indexPath: IndexPath) {
        memoList.remove(at: indexPath.row)
        memoListObservable.onNext(memoList)
    }
    
    private func editMemo(memo: Memo, indexPath: IndexPath) {
        memoList[indexPath.row] = memo
        memoListObservable.onNext(memoList)
    }
    
}
