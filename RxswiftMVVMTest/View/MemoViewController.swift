//
//  MemoViewController.swift
//  RxswiftMVVMTest
//
//  Created by 곽재선 on 2022/12/29.
//

import UIKit
import RxSwift
import RxCocoa

class MemoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMemoButton: UIBarButtonItem!
    
    var disposable = Disposables.create()
    
    let viewModel = MemoViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        disposable = self.viewModel.memoListObservable
            .bind(to: self.tableView.rx.items) { tableView, index, memo in
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell") as? MemoTableViewCell else { return UITableViewCell() }
                cell.memoTitleLabel.text = memo.title
                return cell
            }
        
        Observable.zip(tableView.rx.modelSelected(Memo.self), tableView.rx.itemSelected)
            .subscribe(onNext: { [weak self] (item, indexPath) in
                guard let memoDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "MemoDetailViewController") as? MemoDetailViewController else { return }
                let viewModel = MemoDetailViewModel(selectedMemo: item)
                memoDetailVC.viewModel = viewModel
                memoDetailVC.viewModel.deleteBtnTapped
                // 수정하기
                    .map { _ in Memo(title: "", content: "") }
                    .subscribe(onNext: {
                        self?.viewModel.memo.onNext(($0,.delete(indexPath)))
                    })
                    .disposed(by: self!.disposeBag)
                
                memoDetailVC.viewModel.memo
                    .subscribe(onNext: {
                        self?.viewModel.memo.onNext(($0,.edit(indexPath)))
                    })
                    .disposed(by: self!.disposeBag)
                
                self?.navigationController?.pushViewController(memoDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let writeMemoVC = segue.destination as? WriteMemoViewController else { return }
        let viewModel = WriteMemoViewModel()
        writeMemoVC.viewModel = viewModel
        writeMemoVC.viewModel.memo
            .subscribe(onNext: { [weak self] in
                self?.viewModel.memo.onNext(($0,.add))
            })
            .disposed(by: disposeBag)
    }
}
