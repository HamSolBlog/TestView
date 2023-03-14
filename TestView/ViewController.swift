//
//  ViewController.swift
//  TestView
//
//  Created by 김정운 on 2023/02/28.
//

import UIKit
import NMapsMap
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!       // StackView
    
    @IBOutlet var stackViewSwitch: UISwitch!    // Switch
    
    @IBOutlet var naverMapView: UIView!         // naverMapView
    
    @IBOutlet var addressLabel: UILabel!        // 주소 입력 Label
    
    // 지도의 컨트롤을 내장한 지도 뷰 클래스.
    let nMapView = NMFMapView(frame: UIScreen.main.bounds)
    
    // 앱에 위치 관련 이벤트 전달을 시작하고 중지하는 데 사용하는 객체.
    var locationManager = CLLocationManager()
    
    @IBOutlet var detaileMapBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("")
        print("========================================")
        print("========================================")
        print("===== ViewController viewDidLoad() =====")
        print("========================================")
        print("========================================")
        print("")
        
        // 레이어의 배경에 둥근 모서리를 그릴 때 사용할 반경. 애니메이션 가능.
        stackView.layer.cornerRadius = 15
        stackViewSwitch.layer.cornerRadius = 15
        stackViewSwitch.backgroundColor = .white
        
        self.switchOnOff()
            
        locationManager.delegate = self // 업데이트 이벤트를 받기 위한 대리자 객체.

        // desiredAccuracy = 앱이 받고자 하는 위치 데이터의 정확성.
        // kCLLocationAccuracyBest = 이용 가능한 최고 수준의 정확도.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 앱이 사용 중인 동안 위치 서비스를 사용할 수 있는 사용자의 허가를 요청합니다.
        locationManager.requestWhenInUseAuthorization()

        // 장치에서 위치 서비스가 활성화되어 있는지 여부를 나타내는 부울 값을 턴합니다.
        if CLLocationManager.locationServicesEnabled()
        {
            print("")
            print("====================================")
            print("============ 현재 위치 on ============")
            print("====================================")
            print("")

            // 사용자의 현재 위치를 보고하는 업데이트를 시작합니다.
            locationManager.startUpdatingLocation()
            
            // frame = 슈퍼뷰의 좌표계에서 뷰의 위치와 크기를 설명하는 프레임 직사각형.
            // CGRect(x,y,width,height) = 직사각형의 위치와 치수를 포함하는 구조.
            nMapView.frame = CGRect(x: 0, y: 0, width: 373, height: 100)
            
            // 수신자의 하위 뷰 목록 끝에 뷰를 추가합니다.
            naverMapView.addSubview(nMapView)
            
            // setImage = 지정된 상태에 사용할 이미지를 설정합니다.
            // UIImage = 앱에서 이미지 데이터를 관리하는 객체.
            // systemName = 시스템 기호 이미지를 포함하는 이미지 객체를 만듭니다.
            // for = 지정된 상태에 사용할 이미지를 설정합니다.
            // .normal = 컨트롤이 활성화되어 있지만 선택되거나 강조되지 않은 컨트롤의 정상 또는 기본 상태.
            detaileMapBtn.setImage(UIImage(systemName: "exclamationmark.circle"), for: .normal)
            
            // 버튼 제목과 이미지에 적용할 색조 색상.
            detaileMapBtn.tintColor = .black
            
            // 뷰의 배경색.
            detaileMapBtn.backgroundColor = .white
        }
        else
        {
            print("")
            print("====================================")
            print("============ 현재 위치 off ============")
            print("====================================")
            print("")
        }
    }
    
    /**
     Switch의 이벤트 정의 함수
     */
    func switchOnOff()
    {
        print("")
        print("===============================================")
        print("============ switchOnOff() 함수 호출 ============")
        print("===============================================")
        print("")
        
        // Switch의 초기값
        self.stackViewSwitch.isOn = false
        
        // 버튼의  Action과 Event 설정
        self.stackViewSwitch.addTarget(self, action: #selector(onClickSwitch), for: .valueChanged)
    }
    
    /**
     Switch의 on/off 상태의 이벤트 함수
     */
    @objc func onClickSwitch(sender: UISwitch)
    {
        print("")
        print("================================================")
        print("============ onClickSwitch() 함수 호출 ============")
        print("-------------------------------------------------")
        print("------------ 파라미터 sender : \(sender) ----------")
        print("================================================")
        print("")
        
        print(stackViewSwitch.isOn)
        
        // 색상 데이터와 때로는 불투명도를 저장하는 개체.
        var color = UIColor()
        
        // 스위치가 켜졌는지 꺼졌는지를 결정하는 값.
        switch stackViewSwitch.isOn
        {
        case true :
            color = .white
            // axis = 배열된 전망이 배치된 축.
            // vertical = 물체 간의 수직 관계를 배치할 때 제약이 적용되었다.
            stackView.axis = .vertical
            stackView.backgroundColor = color
            self.Animation()
        case false :
            color = .white
            // axis = 배열된 전망이 배치된 축.
            // vertical = 물체 간의 수직 관계를 배치할 때 제약이 적용되었다.
            stackView.axis = .vertical
            stackView.backgroundColor = color
            self.Animation()
        }
    }
    
    /**
     Switch의 on/off 애니메이션
     */
    func Animation()
    {
        print("")
        print("==================================")
        print("======= Animation() 함수 호출 ======")
        print("==================================")
        print("")
        
        // 스위치가 켜졌는지 꺼졌는지를 결정하는 값.
        if stackViewSwitch.isOn == true
        {
            // 지정된 기간, 지연, 옵션 및 완료 핸들러를 사용하여 하나 이상의 뷰에 대한 변경을 애니메이션화
            UIView.animate(withDuration: 0.5, delay: 0, animations:
            {
                self.naverMapView.alpha = 1
                self.detaileMapBtn.isHidden = false
                self.naverMapView.isHidden = false
                self.addressLabel.isHidden = false
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, delay: 0, animations:
            {
                self.naverMapView.alpha = 0
                self.naverMapView.isHidden = true
                self.detaileMapBtn.isHidden = true
                self.addressLabel.isHidden = true
            })
        }
    }
    
    // 지도의 위치가 변경될 때마다 호출 됨.
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int)
    {
        print("")
        print("===========================================")
        print("===== 카메라가 변경됨 : reason : \(reason) ====")
        print("===========================================")
        print("")
        
        // 지도의 콘텐츠 영역 중심에 대한 카메라 위치.
        let cameraPosition = mapView.cameraPosition
        
        print(cameraPosition.target.lat , cameraPosition.target.lng)
    }
    
    // 상세버튼 이벤트
    @IBAction func btnEvent(_ sender: Any)
    {
        print("")
        print("===========================================")
        print("=============== btnEvent 호출 ==============")
        print("-------------------------------------------")
        print("======== 파라미터 sender : \(sender) ========")
        print("===========================================")
        print("")
        
        let naverMapVC = MapDetaileViewController(nibName: "MapDetaileViewController", bundle: nil)
        
        naverMapVC.addressDataDelegate = self
        
        self.present(naverMapVC, animated: true)
    }
    
    func test01(){
        let naverAPI = NaverAPI()
        
        naverAPI.getAPI()
    }
    
}

extension ViewController: NMFMapViewCameraDelegate ,CLLocationManagerDelegate
{
    
}

extension ViewController: AddressDataDelegate
{
    func addressDatas(xData: Double, yData: Double, addressData: String) {
        
        stackView.reloadInputViews()
        addressLabel.text = addressData
        
        nMapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: yData, lng: xData)))
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: yData, lng: xData)
        marker.mapView = self.nMapView
    }
}
