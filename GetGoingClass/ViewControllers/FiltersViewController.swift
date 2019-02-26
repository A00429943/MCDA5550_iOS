//
//  FiltersViewController.swift
//  GetGoingClass
//
//  Created by Alla Bondarenko on 2019-02-04.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    // Temporary Filter Variables
    var radiusTemp = Globals.radius
    var onlyOpenNowTemp = Globals.onlyOpenNow
    var rankByTemp =  Globals.rankBy
    var delegate: FiltersViewDelegate?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var isOpenNow: UISwitch!
    @IBOutlet weak var rankByLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var rankBySelectedLabel: UILabel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isOpenNow.isOn = Globals.onlyOpenNow
        radiusSlider.value = Float(Globals.radius)
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        rankByLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rankByLabelTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        rankByLabel.addGestureRecognizer(tapGestureRecognizer)
        rankBySelectedLabel.text = Globals.rankByDictionary.first?.description()
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44.0)
        let toolBar = UIToolbar(frame: frame)
        toolBar.sizeToFit()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.hidePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace, doneItem], animated: true)
        pickerView.addSubview(toolBar)
        pickerView.bringSubviewToFront(toolBar)
        pickerView.isUserInteractionEnabled = true
    }
    
    // MARK: - IBActions
    
    @objc func rankByLabelTapped() {
        print("label was tapped")
        pickerView.isHidden = !pickerView.isHidden
    }
    
    @objc func hidePicker() {
        print("done was tapped")
        pickerView.isHidden = true
    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        delegate?.filtersViewWillDismiss(filtersViewController: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        radiusTemp = Globals.radiusDefault
        onlyOpenNowTemp = Globals.onlyOpenNowDefault
        rankByTemp = Globals.rankByDefault
        
        isOpenNow.isOn = Globals.onlyOpenNowDefault
        radiusSlider.value = Float(Globals.radiusDefault)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        Globals.rankBy = (rankBySelectedLabel.text)!
        Globals.radius = radiusTemp
        Globals.onlyOpenNow = onlyOpenNowTemp
        Globals.rankBy = rankByTemp
    }
    
    @IBAction func radiusSliderChangedValue(_ sender: UISlider) {
        radiusTemp = Int(sender.value)
        print("slider value changed to \(sender.value) int \(Int(sender.value))")
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        onlyOpenNowTemp = sender.isOn
        print("switch value was changed to \(sender.isOn)")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FiltersViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Globals.rankByDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Globals.rankByDictionary[row].description()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rankBySelectedLabel.text = Globals.rankByDictionary[row].description()
    }
}

// Custom protocol for passing data
protocol FiltersViewDelegate: class {
    func filtersViewWillDismiss(filtersViewController: FiltersViewController )
}
