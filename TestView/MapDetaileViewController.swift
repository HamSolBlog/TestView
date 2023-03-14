//
//  MapDetaileViewController.swift
//  TestView
//
//  Created by 김정운 on 2023/03/07.
//

import UIKit
import NMapsMap

/**
    지도의 상세화 ViewController
 */
class MapDetaileViewController: UIViewController {
    
    @IBOutlet var mapApp: UIView!   // 지도
    
    @IBOutlet var mapNavigationBar: UINavigationBar!    // 지도의 NavigationBar
    
    @IBOutlet var mapNavigationTitle: UINavigationItem! // 지도의 Title
        
    @IBOutlet var searchBar: UISearchBar!
    
    //    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var detaileUIView: UIView!
    
    @IBOutlet var addressLabel: UILabel!
    
    // NMFNaverMapView = 지도의 컨트롤을 내장한 지도 뷰 클래스
    let nMapView = NMFMapView(frame: UIScreen.main.bounds)
    let marker = NMFMarker()
    let infoWindow = NMFInfoWindow()
    
    var naverXData: Double?
    var naverYData: Double?
    var jibunAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("")
        print("================================================")
        print("================================================")
        print("==== MapDetaileViewController viewDidLoad() ====")
        print("================================================")
        print("================================================")
        print("")
        
//        // NMFNaverMapView = 지도의 컨트롤을 내장한 지도 뷰 클래스.
//        let nMapView = NMFNaverMapView(frame : view.frame)
        
        self.navigationItems()
        
        self.naverMap()
        
        self.setSearchControllrt()
        
        nMapView.touchDelegate = self
        
        self.markerTouch()
        
        view.bringSubviewToFront(detaileUIView)
        
    }
    
    // Naver Map 지도 함수
    func naverMap()
    {
        // MapView의 크기 설정
        nMapView.frame = CGRect(x: 0, y: 0, width: 390, height: 675)
        
        // 실내 지도 기능여부
        nMapView.isIndoorMapEnabled = true
        
        if (naverXData != nil) && (naverYData != nil)
        {
            print("====================")
            print("===== 좌표 이동 ======")
            print("== naverXData : \(naverXData!) ==")
            print("== naverYData : \(naverYData!) ==")
            print("====================")
            
            nMapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: naverYData!, lng: naverXData!)))
            
            marker.position = NMGLatLng(lat: naverYData!, lng: naverXData!)
            
            marker.mapView = self.nMapView
        }
        
        mapApp.addSubview(nMapView)
    }
    
    func markerTouch()
    {
        // 마커를 탭하면:
        let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
            if overlay is NMFMarker
            {
                if self?.detaileUIView.isHidden == true {
                    // 현재 마커에 정보 창이 열려있지 않을 경우 엶
                    self?.HiddenEvent()
                    self?.addressLabel.text = self?.jibunAddress
                    print("열림")
                } else {
                    // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
                    self?.HiddenEvent()
                    print("닫힘")
                }
            }
            return true
        }
        marker.touchHandler = handler
    }
    
    /**
        NavigationItem 관리 함수
     */
    func navigationItems()
    {
        mapNavigationTitle.title = "지도"
        // 내비게이션 바 배경에 적용할 색조.
        mapNavigationBar.barTintColor = .white
    }
    
    func setSearchControllrt()
    {
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = false
    }
    
    func callAPI(query : String)
    {
        print("")
        print("=========================")
        print("=== CallAPI() 함수 호출 ===")
        print("-------------------------")
        print("=== 파라미터 : \(query) ===")
        print("=========================")
        print("")
        
        let naverAPI = NaverAPI()
        
        naverAPI.query = query
        naverAPI.naverAPIDelegate = self
        
        naverAPI.getAPI()
    }
    
    @IBAction func checkBtn(_ sender: Any)
    {
        print("")
        print("=========================")
        print("=========  확인  =========")
        print("=========================")
        print("")
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: Any)
    {
        print("")
        print("=========================")
        print("=========  취소  =========")
        print("=========================")
        print("")
        self.HiddenEvent()
    }
    
    func HiddenEvent()
    {
        print("")
        print("============================")
        print("===== HiddenEvent() 호출 ====")
        print("============================")
        print("")
        
        if detaileUIView.isHidden == true
        {
            self.detaileUIView.isHidden = false
        }
        else
        {
            self.detaileUIView.isHidden = true
        }
    }
}

extension MapDetaileViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print("")
        print("===========================")
        print("=== searchBarSearchButtonClicked() 함수 호출 ===")
        print("---------------------------")
        print("---------- 파라미터 호출 ------------")
        print("=== searchBar : \(searchBar) ===")
        print("=========================")
        print("")
        
        if searchBar.text != nil
        {
            self.callAPI(query: searchBar.text!)
        }
        else
        {
            return
        }
        
        print("")
        print("===========================")
        print("=== searchBarSearchButtonClicked() 함수 종료 ===")
        print("=========================")
        print("")
        
    }
}

extension MapDetaileViewController: NMFMapViewTouchDelegate
{
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint)
    {
        if self.detaileUIView.isHidden == false
        {
            // 현재 마커에 정보 창이 열려있지 않을 경우 엶
            self.detaileUIView.isHidden = true
            print("닫힘")
        }
    }
}

extension MapDetaileViewController:NavaerAPIDelegate
{
    func setXYData(xData: String, yData: String, jibunAddress: String) {
        let dXData = NSString(string: xData).doubleValue
        let dYData = NSString(string: yData).doubleValue
        
        self.naverXData = dXData
        self.naverYData = dYData
        self.jibunAddress = jibunAddress
        
        self.naverMap()
    }
}
