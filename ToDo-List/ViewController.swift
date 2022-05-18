//
//  ViewController.swift
//  ToDo-List
//
//  Created by 채명정 on 2022/05/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task](){
        didSet{
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
        
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
    
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self] _ in
//            debugPrint("\(alert.textFields?[0].text)")
            guard let title =  alert.textFields?[0].text else {return}
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cancleButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textFiled in
            textFiled.placeholder = "할 일을 입력 해 주세요."
        })
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveTasks(){
        let data = self.tasks.map{
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
        
    }
    
    func loadTasks(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String : Any]] else {return}
        
        self.tasks = data.compactMap{
            guard let title = $0["title"] as? String else {return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            return Task(title: title, done: done)
        }
    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // 각 섹션에 표시할 행의 갯수
        return self.tasks.count // 배열의 갯수 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // 특정 섹션의 n번째 row그리는데 필요한 셀을 반환 하는 함수
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if(task.done){
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // 셀을 선택 하였을때 어떤 셀이 선택 되었는지 알려주는 메소드
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
}
