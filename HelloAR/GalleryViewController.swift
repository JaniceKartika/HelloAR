//
//  GalleryViewController.swift
//  HelloAR
//
//  Created by Janice Kartika on 07/06/18.
//  Copyright © 2018 Bukalapak. All rights reserved.
//

import UIKit
import QuickLook

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    @IBOutlet var collectionView: UICollectionView!
    
    let usdzFiles = ["wheelbarrow",
                     "wateringcan",
                     "trowel",
                     "teapot",
                     "gramophone",
                     "cupandsaucer",
                     "retrotv",
                     "redchair",
                     "tulip",
                     "plantpot"]
    
    var images: [UIImage] = []
    var imageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        
        for file in usdzFiles {
            if let image = UIImage(named: "\(file).jpg") {
                images.append(image)
            }
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as? GalleryCollectionViewCell
        
        if let cell = cell, let image = images[safe: indexPath.item] {
            cell.galleryImageView.image = image
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageIndex = indexPath.item
        preview()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url = Bundle.main.url(forResource: usdzFiles[safe: imageIndex], withExtension: "usdz")!
        return url as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, transitionViewFor item: QLPreviewItem) -> UIView? {
        let indexPath = IndexPath(item: imageIndex, section: 0)
        if let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
            return cell.galleryImageView
        }
        return nil
    }
    
    private func preview() {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.delegate = self
        
        present(previewController, animated: true)
    }
}
