//
//  HDBKeychainViewController.swift
//  keychainSwift
//
//  Created by Hector H. De Diego Brito on 12/27/16.
//  Copyright © 2016 BBVA Bancomer. All rights reserved.
//

import UIKit

class HDBKeychainViewController: UIViewController {
  
  @IBOutlet weak var lblGroupTitle: UILabel!
  @IBOutlet weak var lblKeychainGroup: UITextView!
  
  // Keychain UITextViews
  @IBOutlet weak var lblPhone: UITextView!
  @IBOutlet weak var lblSeed: UITextView!
  @IBOutlet weak var lblCentro: UITextView!
  @IBOutlet weak var lblURLScheme: UITextView!
  @IBOutlet weak var lblOTP: UITextView!
  @IBOutlet weak var lblGemaltoIUM: UITextView!
  
  // Generated UITextViews
  @IBOutlet weak var lblIUM: UITextView!
  
  // Group UIButtons
  @IBOutlet weak var btnDefault: UIButton!
  @IBOutlet weak var btnWallet: UIButton!
  @IBOutlet weak var btnBancomer: UIButton!
  @IBOutlet weak var btnVida: UIButton!
  @IBOutlet weak var btnNexo: UIButton!
  
  // Class vars
  var selectedGroupIndex: Int = 0
  var accessGroup: String? = nil
  var timer: Timer!
  
  override func viewDidLoad() {
    super.viewDidLoad()    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reinitKeychainData()
  }
  
  
  private func reinitKeychainData() {
    KeyChainHandler.deleteInstance()
    
    var teamID: String? = nil
    if let newGroup = Bundle.main.infoDictionary!["AppIdentifierPrefix"] as? String {
      teamID = newGroup
    }
    
    let grupoW = "\(teamID ?? "")com.bbva.bbvawallet.mx"
    let grupoB = "\(teamID ?? "")com.bancomer.bbva.bancomermovil"
    let grupoV = "\(teamID ?? "")com.bancomer.bbva.vidaBancomer"
    let grupoN = "\(teamID ?? "")com.bancomer.bbva.Nexodistribucion"
    let grupoP = "\(teamID ?? "")com.bancomer.bbva.bsave"
    
    
    switch selectedGroupIndex {
    case 0: accessGroup = grupoP // Plan
    case 1: accessGroup = grupoW // Wallet
    case 2: accessGroup = grupoB // Bancomer
    case 3: accessGroup = grupoV // Vida
    case 4: accessGroup = grupoN // Nexo
    default: break
    }
    
    lblGroupTitle.text = "Cambiando..."
    
    hideLabels()
    
    let anInterval: TimeInterval = 1.5
    if let previousTimer = timer {
      previousTimer.invalidate()
    }
    timer = Timer.scheduledTimer(
      timeInterval: anInterval,
      target: self,
      selector: #selector(self.loadKeychainData),
      userInfo: nil,
      repeats: false
    )
  }
  
  func loadKeychainData() {
    // Keychain Data
    
    lblKeychainGroup.text = accessGroup ?? ""
    
    switch selectedGroupIndex {
    case 0:  lblGroupTitle.text = "Plan"
    case 1:  lblGroupTitle.text = "Wallet"
    case 2:  lblGroupTitle.text = "Bancomer"
    case 3:  lblGroupTitle.text = "Vida"
    case 4:  lblGroupTitle.text = "Nexo"
    default: lblGroupTitle.text = "???"
    }
    
    lblPhone.text = KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .leerDeKeyChain("numCel") ?? "nil"
    
    lblSeed.text = KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .leerDeKeyChain("seed") ?? "nil"
    
    lblCentro.text = KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .leerDeKeyChain("centro") ?? "nil"
    
    lblURLScheme.text = KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .leerDeKeyChain("URLScheme") ?? "nil"
    
    lblOTP.text = KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .leerDeKeyChain("otp") ?? "nil"
    
    lblGemaltoIUM.text = KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .leerDeKeyChain("StringST") ?? "nil"
    
    // Generated Data
    
    if let doubleFromSeed: Double = Double(lblSeed.text) {
      lblIUM.text = BmovilTools.computeIUM(
        withUser: lblPhone.text,
        andActivationTime: doubleFromSeed
      )
    } else {
      lblIUM.text = "nil"
    }
    
    showLabelsAnimated()
    
    let tempAccessGroup = KeyChainHandler.getInstanceWithAccessGroup(accessGroup).getKeychainGroup()
    debugPrint("El grupo de acceso del keychain actual es: \(tempAccessGroup ?? "nil")")
  }
  
  private func hideLabels() {
    lblPhone.alpha = 0.1
    lblSeed.alpha = 0.1
    lblCentro.alpha = 0.1
    lblURLScheme.alpha = 0.1
    lblOTP.alpha = 0.1
    lblIUM.alpha = 0.1
    lblGemaltoIUM.alpha = 0.1
    lblGroupTitle.alpha = 0.1
    lblKeychainGroup.alpha = 0.1
  }
  
  private func showLabelsAnimated() {
    UIView.animate(
      withDuration: 0.5,
      delay: 0.3,
      options: [],
      animations: {
        self.lblPhone.alpha = 1
        self.lblSeed.alpha = 1
        self.lblCentro.alpha = 1
        self.lblURLScheme.alpha = 1
        self.lblOTP.alpha = 1
        self.lblIUM.alpha = 1
        self.lblGemaltoIUM.alpha = 1
        self.lblGroupTitle.alpha = 1
        self.lblKeychainGroup.alpha = 1
    },
      completion: nil
    )
  }
  
  @IBAction func actRefreshData(_ sender: UIButton) {
    reinitKeychainData()
  }
  
  @IBAction func actDelete(_ sender: UIButton) {
    KeyChainHandler
      .getInstanceWithAccessGroup(accessGroup)
      .borrarKeyChain()
    
    reinitKeychainData()
  }
  
  @IBAction func actSwitchGroup(_ sender: UIButton) {
    switch sender {
    case btnDefault:  selectedGroupIndex = 0
    case btnWallet:   selectedGroupIndex = 1
    case btnBancomer: selectedGroupIndex = 2
    case btnVida:     selectedGroupIndex = 3
    case btnNexo:     selectedGroupIndex = 4
    default: break;
    }
    reinitKeychainData()
  }
}

