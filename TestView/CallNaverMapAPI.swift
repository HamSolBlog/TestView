//
//  CallNaverMapAPI.swift
//  TestView
//
//  Created by 김정운 on 2023/03/08.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NavaerAPIDelegate
{
    func setXYData(xData:String , yData:String, jibunAddress:String)
}

class NaverAPI
{
    var query:String?
    
    var naverAPIDelegate : NavaerAPIDelegate? = nil
    
    func getAPI()
    {
        if(query != nil)
        {
            print("")
            print("==========================================")
            print("==========================================")
            print("=======        NaverAPI 클래스       =======")
            print("==========    getAPI() 함수호출    ==========")
            print("==========================================")
            print("==========================================")
            print("")
            
            let NAVER_CLIENT_ID = "prsvi0elij"
            let NAVER_CLIENT_SECRET = "QPYbB3FPbvsfN8R3Je4Wozyf9QOpK3eFu4Nh43uk"
            let NAVER_GEOCODE_URL = "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?"
            
            let header1 = HTTPHeader(name: "X-NCP-APIGW-API-KEY-ID", value: NAVER_CLIENT_ID)
            let header2 = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: NAVER_CLIENT_SECRET)
            let headers = HTTPHeaders([header1,header2])
            
            // key : value 딕셔너리
            let queryParam:Parameters = ["query" : query!]
            
            print("")
            print("=======================================")
            print("===========      Log     ==============")
            print("====     headers  : \(headers)     ====")
            print("====  queryParam  : \(queryParam)  ====")
            print("====          URL : \(NAVER_GEOCODE_URL)")
            print("=======================================")
            print("")
            
            AF.request(
                NAVER_GEOCODE_URL,                  // url
                method: .get,                       // 전송 방식
                parameters: queryParam,             // 전송 데이터
                encoding: URLEncoding.queryString,  // 인코딩 스타일
                headers: headers                    // 헤더 지정
            )
            .validate(statusCode: 200..<300) // statusCode : 응답에 지정된 순서의 상태 코드가 있는지 확인.
            .responseData // 요청이 완료되면 호출할 DataResponseSerializer를 사용하는 처리기를 추가.
            { response in
                switch response.result
                {
                case .success(let res):
                    print("")
                    print("====================================")
                    print("====    Get 방식 Http 응답 확인    ====")
                    print("------------------------------------")
                    print("====    응답 코드   : " , response.response?.statusCode ?? 0)
                    print("------------------------------------")
                    print("====    응답 데이터  : ", String(data: res, encoding: .utf8) ?? "")
                    print("====================================")
                    print("")
                    
                    var dicData : Dictionary<String, Any> = [String : Any]()
                    do
                    {
                        dicData = try JSONSerialization.jsonObject(with: res, options: []) as! [String:Any]
                        print("")
                        print("===============================")
                        print("dicDatakeys : " , dicData.keys)
                        print("===============================")
                        print("")
                    }
                    catch
                    {
                        print(error)
                    }
                    
                    var xData:String = ""
                    var yData:String = ""
                    var jibunAddress:String = ""

                    if let jsonDatas = dicData["addresses"] as? [[String:Any]]{
                        print("")
                        print("===============================")
                        print("jsonDatas : " , jsonDatas)
                        print("===============================")
                        print("")
                        
                        for jsonIndex in jsonDatas
                        {
                            xData = jsonIndex["x"] as! String
                            yData = jsonIndex["y"] as! String
                            jibunAddress = jsonIndex["jibunAddress"] as! String
                        }
                        
                    }

                    print("")
                    print("===============================")
                    print("xData : ", xData)
                    print("yData : ", yData)
                    print("jibunAddress : ", jibunAddress)
                    print("===============================")
                    print("")
                    
                    if (xData != "") && (yData != "")
                    {
                        self.naverAPIDelegate?.setXYData(xData: xData, yData: yData, jibunAddress: jibunAddress)
                    }
                    else
                    {
                        print("")
                        print("===========================")
                        print("===========================")
                        print("=====    검색 결과 없음   ====")
                        print("===========================")
                        print("===========================")
                        print("")
                        
                        return
                    }
                    
                    // 비동기 작업 수행
                    DispatchQueue.main.async
                    {
                        print("")
                        print("==========================")
                        print("====== 비동기 작업 수행 ======")
                        print("==========================")
                        print("")
                        
                        print("")
                        print("==========================")
                        print("====== 비동기 작업 종료 ======")
                        print("==========================")
                        print("")
                    }
                    break
                    
                case .failure(let err) :
                    print("")
                    print("=================================")
                    print("====   Get 방식 Http 응답 실패   ====")
                    print("------------------------------------")
                    print("====    응답 코드   : " , response.response?.statusCode ?? 0)
                    print("=================================")
                    print("catch : ", err.localizedDescription)
                    print("")
                    break
                }
            }
            print("")
            print("==========================================")
            print("==========     NaverAPI 클래스    ==========")
            print("==========    getAPI() 함수종료    ==========")
            print("==========================================")
            print("")
        }
        else
        {
            print("")
            print("======================")
            print("---- query == nil!!!! ----")
            print("======================")
            print("")
            return
        }
    }
}
