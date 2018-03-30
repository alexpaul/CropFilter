//
//  CroppedImageController.swift
//  CropFilter
//
//  Created by Alex Paul on 3/29/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit

class CroppedImageController: UIViewController {
    
    @IBOutlet weak var croppedImageView: UIImageView!
    
    lazy var collectionView: UICollectionView = {
        let collectionViewHeight: CGFloat = UIScreen.main.bounds.height * 0.25
        let itemWidth: CGFloat = UIScreen.main.bounds.width * 0.40
        let cellSpacing: CGFloat = 10.0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: itemWidth, height: collectionViewHeight - (cellSpacing * 2.0))
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsetsMake(cellSpacing, cellSpacing, cellSpacing, cellSpacing)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.register(ImageFilterCell.self, forCellWithReuseIdentifier: "ImageFilterCell")
        cv.backgroundColor = .yellow
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    public var image: UIImage!
    
    private let ciFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone",
        "CISpotColor"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        croppedImageView.image = image
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Image", style: .plain, target: self, action: #selector(saveToCameraRoll))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    public static func storyboardInstance() -> CroppedImageController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let croppedImageController = storyboard.instantiateViewController(withIdentifier: "CroppedImageController") as! CroppedImageController
        return croppedImageController
    }
    
    private func addFilter(filterName: String) {
        // Create filters for each button
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        let filter = CIFilter(name: filterName )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let filteredUIImage = UIImage.init(cgImage: filteredImageRef!)//UIImage(CGImage: filteredImageRef!);
        croppedImageView.image = filteredUIImage
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func saveToCameraRoll() {
        UIImageWriteToSavedPhotosAlbum(croppedImageView.image!, nil, nil, nil)
        showAlert(title: "Save to Camera Roll", message: "Image has been saved to Camera Roll")
    }
}

extension CroppedImageController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ciFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageFilterCell", for: indexPath) as! ImageFilterCell
        cell.backgroundColor = .orange
        let filterName = ciFilterNames[indexPath.row]
        cell.filterNameLabel.text = filterName
        return cell
    }
}

extension CroppedImageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterName = ciFilterNames[indexPath.row]
        addFilter(filterName: filterName)
    }
}
