//
//  ViewController.swift
//  NasaPicture
//
//  Created by Lyudmila Tokar on 3/24/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var showPictureButton: UIButton!
    
    var nasaDataManager = NasaDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nasaDataManager.dataManagerDelegate = self
        showPictureButton.layer.cornerRadius = 10
    }
    
    @IBAction func showPicturePressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datePicker.date)
        
        nasaDataManager.fetchNasaData(data: dateString)
    }
}

//MARK: - NasaDataManagerDelegate

extension ViewController: NasaDataManagerDelegate {
    func didUpdateNasaData(_ nasaDataManager: NasaDataManager, nasaData: NasaDataModel) {
        
        DispatchQueue.main.async {
            self.imageTitleLabel.text = nasaData.titleImage
            self.descriptionTextView.text = nasaData.description
            
            let url = URL(string: nasaData.urlImage)
            let data = try? Data(contentsOf: url!)
            self.imageView.image = UIImage(data: data!)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
