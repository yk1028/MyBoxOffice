//
//  Extension.swift
//  MyBoxOffice
//
//  Created by 정화 on 20/01/2019.
//  Copyright © 2019 Wongeun Song. All rights reserved.
//

import UIKit

extension UIViewController {
    func requestMoviesWithEscaping() {
        requestMovies(){
            (error) in
            if let error = error {
                self.alertFailMessage(errorMessage: error.localizedDescription)
            }
        }
    }
    
    //Alert `errorMessage` in `viewController`.
    func alertFailMessage(errorMessage: String) {
        let actionSheetController = UIAlertController(title: "ERROR!", message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Action sheet
    func showActionSheetController() {
        let actionSheetController = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let reservationRateAction = UIAlertAction(title: "예매율", style: .default, handler: { (action: UIAlertAction) in
            OrderType.orderTypeProperty = 0
            self.requestMoviesWithEscaping()
        })
        
        let curationAction = UIAlertAction(title: "큐레이션", style: .default, handler: { (action: UIAlertAction) in
            OrderType.orderTypeProperty = 1
            self.requestMoviesWithEscaping()
            
        })
        
        let releaseDateAction = UIAlertAction(title: "개봉일", style: .default, handler: { (action: UIAlertAction) in
            OrderType.orderTypeProperty = 2
            self.requestMoviesWithEscaping()
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        actionSheetController.addAction(reservationRateAction)
        actionSheetController.addAction(curationAction)
        actionSheetController.addAction(releaseDateAction)
        actionSheetController.addAction(cancelAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheetController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }
        else {
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
}
