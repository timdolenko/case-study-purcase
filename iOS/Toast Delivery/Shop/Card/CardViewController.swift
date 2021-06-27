//
//  CardEntryViewController.swift
//  Toast Delivery
//

import UIKit
import SnapKit
import Typist
import Combine

class CardViewController: UIViewController {
    
    private typealias DataSource = UITableViewDiffableDataSource<Int, UUID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, UUID>
    
    weak var tableView: UITableView!
    weak var doneButton: UIButton!
    
    var viewModel: CardDetailsViewModel!
    
    private var keyboard = Typist()
    
    private lazy var dataSource = DataSource(
        tableView: tableView,
        cellProvider: cellProvider
    )
    
    private func cellProvider(
        tableView: UITableView,
        indexPath: IndexPath,
        identifier: UUID
    ) -> UITableViewCell {
        let cell: CardDetailsCell = tableView.dequeue()
        
        let publishers = cell.allFields.map { $0.publisher(for: .editingChanged).eraseToAnyPublisher() }
        
        Publishers.MergeMany(publishers).map { _ in
            cell.card
        }
        .assign(to: &viewModel.$card)
        
        return cell
    }
    
    var bindings = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupInitalSnapshot()
        setupDoneButton()
        setupKeyboard()
        setupValidation()
        bind()
        viewModel.viewDidLoad.send(())
    }
    
    private func bind() {
        bindings.collect {
            viewModel.failure.sink { [unowned self] error in
                showError(error: error)
            }
            viewModel.result.sink { [unowned self] result in
                handle(paymentResult: result)
            }
        }
    }
    
    private func setupTableView() {
        let tv = UITableView()
        view.addSubview(tv)
        tv.separatorStyle = .none
        tv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tv.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        tv.register(CardDetailsCell.self)
        tableView = tv
        
        tv.dataSource = dataSource
        tv.rowHeight = CardDetailsCell.prefferedHeight
    }
    
    private func setupInitalSnapshot() {
        var snap = Snapshot()
        snap.appendSections([0])
        snap.appendItems([UUID()])
        dataSource.apply(snap)
    }
    
    private func setupDoneButton() {
        let b = UIButton()
        b.setTitle(env.translations.card.doneButton, for: .normal)
        b.backgroundColor = env.style.accentColor
        b.isEnabled = false
        b.alpha = 0.3
        view.addSubview(b)
        
        b.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(64)
            make.bottom.equalToSuperview()
        }
        
        doneButton = b
        
        b.publisher(for: .touchUpInside)
            .map { _ in () }
            .handleEvents(receiveOutput: { [unowned b] in
                b.isEnabled = false
                b.alpha = 0.3
            })
            .receive(subscriber: AnySubscriber(viewModel.didTapDone))
    }
    
    private func setupKeyboard() {
        keyboard
            .on(event: .willShow) { [unowned self] options in
                doneButton.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(-options.endFrame.height)
                }
                UIView.animate(withDuration: options.animationDuration) {
                    view.layoutIfNeeded()
                }
            }
            .on(event: .willHide) { [unowned self] options in
                doneButton.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                UIView.animate(withDuration: options.animationDuration) {
                    view.layoutIfNeeded()
                }
            }
            .start()
    }
    
    private func setupValidation() {
        viewModel.$isCardValid
            .assign(to: \.isEnabled, on: doneButton)
            .store(in: &bindings)
        
        viewModel.$isCardValid
            .map { $0 ? 1 : 0.3 }
            .assign(to: \.alpha, on: doneButton)
            .store(in: &bindings)
    }
}

extension CardViewController {
    func handle(paymentResult: PaymentResult) {
        let alert = UIAlertController(
            title: "",
            message: "Payment is \(paymentResult.rawValue).",
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
            dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

fileprivate extension UIViewController {
    func showError(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [unowned self] _ in
            dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
