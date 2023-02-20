//
//  NoteViewController.swift
//  iOS2_Note_0.2(UIKit)
//
//  Created by Illia Wezarino on 09.02.2023.
//

import UIKit
import CoreLocation

protocol NotesDelegate: AnyObject {
    func update(title: String, text: String, indexPath: IndexPath?, location: String?)
    
}

class NoteViewController: UIViewController {

    var titleOfNote = UITextField()
    var textOfNote = UITextView()
    weak var delegate: NotesDelegate? = nil
    var indexPath: IndexPath? = nil
    var locationManager = CLLocationManager()
    var location = CLLocation()
    var locationString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.update(title: titleOfNote.text ?? "", text: textOfNote.text ?? "", indexPath: indexPath, location: locationString)
    }
    
    func setupSubviews() {
        title = ""
        view.backgroundColor = .white
         
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.magnifyingglass"), style: .done, target: self, action: #selector(rightButtonOnNavigation))
        
        titleOfNote.keyboardType = UIKeyboardType.default
        titleOfNote.font = UIFont.systemFont(ofSize: 21)
        titleOfNote.layer.cornerRadius = 15
        titleOfNote.layer.borderColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.4750879553)
        titleOfNote.layer.borderWidth = 1.5
        textFieldPadding(textFieldName: titleOfNote)
        view.addSubview(titleOfNote)
         
        textOfNote.keyboardType = UIKeyboardType.default
        textOfNote.font = UIFont.systemFont(ofSize: 19)
        view.addSubview(textOfNote)
         
        view.subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func textFieldPadding(textFieldName: UITextField) {
        textFieldName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldName.frame.height))
        textFieldName.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldName.frame.height))
        textFieldName.leftViewMode = .always
        textFieldName.rightViewMode = .always
        }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            titleOfNote.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleOfNote.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleOfNote.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            titleOfNote.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            
            textOfNote.topAnchor.constraint(equalTo: titleOfNote.bottomAnchor, constant: 15),
            textOfNote.leadingAnchor.constraint(equalTo: titleOfNote.leadingAnchor),
            textOfNote.trailingAnchor.constraint(equalTo: titleOfNote.trailingAnchor),
            textOfNote.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15 )
        ])
    }
}

// MARK: - Location Setting

extension NoteViewController: CLLocationManagerDelegate  {
    
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
    }
    
    @objc func rightButtonOnNavigation() {
        DispatchQueue.main.async {
            self.location.fetchCityAndCountry { city, country, error in
                guard let city = city, let country = country, error == nil else { return }
                self.locationString = city + ", " + country
            }
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
            CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
        }
}
