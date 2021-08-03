//
//  EmployeeListViewController.swift
//  CoreDataRxSWift
//
//  Created by mind-0023 on 11/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData
import RxDataSources
import RxCoreData

class EmployeeListViewController: UIViewController {

    //MARK:- IBOutlets -
    @IBOutlet weak var employeeTableView: UITableView!{
        didSet {
            employeeTableView.register(EmployeeTableCell.self)
            employeeTableView.tableFooterView = UIView()
        }
    }

    //MARK:- Variables -
    static func instantiate() -> EmployeeListViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeeListViewController") as? EmployeeListViewController
    }
    private let disposeBag = DisposeBag()
    private var addButton : UIBarButtonItem!
    private var logoutButton: UIBarButtonItem!


    // MARK:- LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK:- General Methods -
extension EmployeeListViewController {
    fileprivate func initialization() {
        self.title = Title.employee
        setupUI()
        configureTableView()
    }

    private func setupUI() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        addButton.tintColor = .white

        addButton.rx.tap
            .debounce(RxTimeInterval.microseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                if let addEmployeeVC = AddEmployeeViewController.instance() {
                    self.navigationController?.pushViewController(addEmployeeVC, animated: true)
                }
            }).disposed(by: disposeBag)

        logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: nil)
        logoutButton.tintColor = .white
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                let actions: [UIAlertController.AlertAction] = [
                    .action(title: AlertConstant.Logout),
                    .action(title: AlertConstant.Cancel, style: .cancel)
                ]
                UIAlertController
                    .present(in: self, title: AlertConstant.Logout, message: ErrorMessage.logout, style: .alert, actions: actions)
                    .subscribe(onNext: { buttonIndex in
                        if buttonIndex == 0 {
                            UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.isLogin)
                            CoreDataModel.shared.deleteAllRecord(ForEntity: Employee.entityName)
                        }
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItems = [logoutButton,addButton]
    }
}

//MARK:- Configure TableView
private extension EmployeeListViewController {

    func configureTableView() {
        let animatedDataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Employee>>(configureCell: { dateSource, tableView, indexPath, emp in
            if let cell = tableView.dequeueCell(EmployeeTableCell.self) {
                cell.employee = emp
                return cell
            }
            return UITableViewCell()
        })

        CoreDataModel.shared.managedObjectContext
            .rx
            .entities(Employee.self, sortDescriptors: [NSSortDescriptor(key: Employee.shortingAttributeName, ascending: false)])
            .map { employees in
                if employees.count == 0 {
                    self.employeeTableView.setEmptyMessage(ErrorMessage.noEmplpoyee)
                } else {
                    self.employeeTableView.restore()
                }
                return [AnimatableSectionModel(model: "", items: employees)]
            }
            .bind(to: employeeTableView.rx.items(dataSource: animatedDataSource))
            .disposed(by: disposeBag)

        employeeTableView.rx.itemDeleted
            .map { [unowned self] ip -> Employee in
                return try self.employeeTableView.rx.model(at: ip)
            }
            .subscribe(onNext: { (event) in
                do {
                    try CoreDataModel.shared.managedObjectContext.rx.delete(event)
                } catch {
                    print(error)
                }
            })
            .disposed(by: disposeBag)

        animatedDataSource.canEditRowAtIndexPath = { _,_  in
            return true
        }
    }
}
