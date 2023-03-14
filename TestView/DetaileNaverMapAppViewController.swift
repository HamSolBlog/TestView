//
//  DetaileNaverMapAppViewController.swift
//  TestView
//
//  Created by 김정운 on 2023/03/04.
//

import UIKit
import NMapsMap


class DetaileNaverMapAppViewController: UIViewController {

    @IBOutlet var mapApp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nMapView = NMFNaverMapView(frame : view.frame)
        
        self.title = ""
        
        nMapView.showLocationButton = true
        nMapView.showZoomControls = true
        nMapView.frame = CGRect(x: 0, y: 0, width: 390, height: 755)
        mapApp.addSubview(nMapView)
    }

}
