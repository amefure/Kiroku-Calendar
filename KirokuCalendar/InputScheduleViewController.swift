//
//  InputScheduleViewController.swift
//  KirokuCalendar
//
//  Created by t&a on 2022/10/24.
//

import UIKit
import RealmSwift

class InputScheduleViewController:  UITableViewController {
    
    // MARK: - receive property
    var date:Date = Date()
    var schedule:ScheduleModels? = nil
    
    // MARK: - instance
    let realm = try! Realm()
    let df = DateFormatter()
    
    // MARK: - Outlet
    @IBOutlet weak var titleField:UITextField!
    @IBOutlet weak var memoField:UITextField!
    @IBOutlet weak var startDatePicker:UIDatePicker!
    @IBOutlet weak var endDatePicker:UIDatePicker!
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Function
    func validationInput() -> Bool{
        if titleField.text == "" || startDatePicker.date > endDatePicker.date {
            return false
        }
        return true
    }
    
    // MARK: - Image
    func docURL(_ fileName:String) -> URL? {
        let fileManager = FileManager.default
        do {
            // Docmentsフォルダ
            let docsUrl = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            // URLを構築
            let url = docsUrl.appendingPathComponent(fileName)
            return url
        } catch {
            return nil
        }
    }
    
    func loadImage(name:String){
        // blankならnil
        if name == "blank"{
            imageView.image = nil
        }else{
        // 名前があるなら画像をセット
            let path = docURL("\(name).jpg")!.path
            if FileManager.default.fileExists(atPath: path) {
                if let image = UIImage(contentsOfFile: path) {
                    imageView.image = image
                }
                else {
                    print("読み込みに失敗しました")
                }
            }
        }
    }
    
    func saveImage(name:String) -> Bool {
            guard let imageData = imageView.image?.jpegData(compressionQuality: 1.0) else {
                // imageView.image = nil
                return false
            }
            // imageView.image = image
            do {
                // 画像保存処理
                try imageData.write(to: docURL("\(name).jpg")!)
                return true
            } catch {
                // print("保存失敗")
                return false
            }
    }
    
    func deleteImage(name:String) {
        let url = docURL("\(name).jpg")!
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
//            print("削除失敗")
        }
    }
    
    // MARK: - Image
    // MARK: - Function
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        self.df.dateFormat = "yyyy年MM月dd日(EEE)"
        
        // MARK: - NavigationItem
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style:.plain, target: self, action: #selector(self.entrySchedule))
        self.navigationItem.rightBarButtonItem = rightButton
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style:.plain, target: self, action: #selector(self.backAction))
        self.navigationItem.leftBarButtonItem = leftButton
        // MARK: - NavigationItem
        
        if schedule == nil{
            // Create
            titleField.placeholder = "タイトル"
            memoField.placeholder = "メモ"
            startDatePicker.date = date
            endDatePicker.date = date
            imageView.image = nil
        }else{
            // UpDate
            titleField.text = schedule!.title
            memoField.text = schedule!.memo
            startDatePicker.date = schedule!.start
            endDatePicker.date = schedule!.end
            loadImage(name: schedule!.image)
        }
        imageBtn.addTarget(self, action: #selector(self.selectImage(_:)), for: .touchUpInside)
        if imageView.image != nil {
            // 画像設定済み→ゴミ箱ボタン
            imageBtn.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))), for: .normal)
        }else{
            // 画像未設定→Plusボタン
            imageBtn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))), for: .normal)
        }
        
    }
    // MARK: - View
    
    // MARK: - Action
    // MARK: - Navigation Btn Right
    @objc func entrySchedule(){
        if validationInput() {
            
            if schedule == nil{
                let obj = ScheduleModels()
                obj.title = titleField.text!
                obj.memo = memoField.text!
                obj.start = startDatePicker.date
                obj.end = endDatePicker.date
                
                
                let name = UUID().uuidString // 画像のファイル名を構築
                if saveImage(name: name) {
                    // 保存した場合はファイル名をデータに保存
                    obj.image = name
                }else{
                    // 未保存なら"blank"とする
                    obj.image = "blank"
                }
                
                try! realm.write{
                    realm.add(obj)
                }
                
                if let presentationController = presentationController {
                    presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
                }
                
            }else{
                let result = realm.objects(ScheduleModels.self).first(where: {$0.id == schedule?.id})
                try! realm.write{
                    result?.title = titleField.text!
                    result?.memo = memoField.text!
                    result?.start = startDatePicker.date
                    result?.end = endDatePicker.date
                    
                    if schedule!.image == "blank"{
                        // 元の画像名がblankなら画像名を構築
                        let name = UUID().uuidString
                        if saveImage(name: name) {
                            // 画像がセットされていれば
                            result?.image = name // 保存した場合のみデータに保存
                        }else{
                            // 画像が未セット
                            result?.image = "blank"
                        }
                    }else{
                        // 元の画像名が存在するなら画像名を更新
                        if saveImage(name: schedule!.image) {
                            // 画像がセットされていれば
                            result?.image = schedule!.image // 保存した場合のみデータに保存
                        }else{
                            // 画像が未セット
                            deleteImage(name:schedule!.image)
                            result?.image = "blank"
                        }
                    }
                }
            }
            self.dismiss(animated: true,completion: nil)
            
        }
        
    }
    
    // MARK: - Navigation Btn Left
    @objc func backAction(){
        self.dismiss(animated: true,completion: nil)
    }
    
    // MARK: - 画像選択
    @objc func selectImage(_ sender: UIButton) {
        if imageView.image != nil {
            imageView.image = nil
            imageBtn.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))), for: .normal)
        }else{
            // カメラロールが利用可能か？ NSPhotoLibraryUsageDescriptionのキーを追加
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerView = UIImagePickerController() // 写真を選ぶビュー
                pickerView.sourceType = .photoLibrary // カメラロールから選択
                pickerView.delegate = self
                self.present(pickerView, animated: true)
            }
        }
    }
    // MARK: - Action
    
}

// MARK: - Image extension
extension InputScheduleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 写真を選んだ後に呼ばれる処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 選択した写真を取得する
        let image = info[.originalImage] as! UIImage
        // ビューに表示する
        imageView.image = image
        imageBtn.setImage(UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 10))), for: .normal)
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
}


