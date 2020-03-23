//
//  CTOSAuthService.swift
//  CityOSAir
//
//  Created by Andrej Saric on 08/10/2017.
//  Copyright © 2017 CityOS. All rights reserved.
//

//
//  CTOSPeerServiceManager.swift
//  Pods
//
//  Created by Andrej Saric on 08/10/2017.
//

import Foundation
import MultipeerConnectivity

public protocol CTOSAuthServiceAdvertiserDelegate: class {
  func didGetToken(manager: CTOSAuthServiceManager, token: String)
}

public protocol CTOSAuthServiceBrowserDelegate: class {
  func didFoundPeer(name: String)
  func didConnectToPeer()
}

public class CTOSAuthServiceManager: NSObject {

  private var CTOSServiceType = "cityos-service"
  private var myPeerId = MCPeerID(displayName: UIDevice.current.name)
  private var serviceAdvertiser: MCNearbyServiceAdvertiser
  private var serviceBrowser: MCNearbyServiceBrowser

  public weak var browserDelegate: CTOSAuthServiceBrowserDelegate?
  public weak var advertiserDelegate: CTOSAuthServiceAdvertiserDelegate?

  private var foundPeer: MCPeerID?

  lazy var session: MCSession = {
    let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .optional)
    session.delegate = self
    return session
  }()

  public override init() {
    self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: CTOSServiceType)
    self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: CTOSServiceType)
    
    super.init()
    
    self.serviceAdvertiser.delegate = self
    self.serviceBrowser.delegate = self
  }

  public func advertiser() {
    self.serviceAdvertiser.startAdvertisingPeer()
  }

  public func browser() {
    self.serviceBrowser.startBrowsingForPeers()
  }

  public func stopAdvertising() {
    self.serviceAdvertiser.stopAdvertisingPeer()
  }

  public func stopBrowsing() {
    self.serviceBrowser.stopBrowsingForPeers()
  }

  public func send(token: String) {
    print("send token: \(token) to \(session.connectedPeers.count) peers")
    if session.connectedPeers.count > 0 {
      do {
        guard let data = token.data(using: .utf8) else {
          print("Unable to parse into data.")
          return
        }
        try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
      }
      catch let error {
        print("Error for sending: \(error)")
      }
    }
  }

  public func connect() {
    if let peer = foundPeer {
      serviceBrowser.invitePeer(peer, to: self.session, withContext: nil, timeout: 10)
    }
  }

  deinit {
    self.serviceAdvertiser.stopAdvertisingPeer()
    self.serviceBrowser.stopBrowsingForPeers()
  }

}

extension CTOSAuthServiceManager: MCNearbyServiceAdvertiserDelegate {

  public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
  }

  public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    invitationHandler(true, self.session)
  }

}

extension CTOSAuthServiceManager: MCNearbyServiceBrowserDelegate {

  public func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
    NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
  }

  public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
    NSLog("%@", "foundPeer: \(peerID)")
    NSLog("%@", "invitePeer: \(peerID)")


    if session.connectedPeers.count > 1 {
      return
    }

    if let existing = foundPeer {
      if existing.displayName == peerID.displayName {
        return
      }
    }

    self.foundPeer = peerID

    browserDelegate?.didFoundPeer(name: peerID.displayName)

  }

  public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    NSLog("%@", "lostPeer: \(peerID)")
  }

}

extension CTOSAuthServiceManager: MCSessionDelegate {

  public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    NSLog("%@", "didReceiveData: \(data)")
    let str = String(data: data, encoding: .utf8)!
    self.advertiserDelegate?.didGetToken(manager: self, token: str)
  }

  public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    NSLog("%@", "peer \(peerID) didChangeState: \(state)")

    if state == .connected {
      self.browserDelegate?.didConnectToPeer()
    }
  }

  public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

  }

  public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

  }

  public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

  }

  public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {

    certificateHandler(true)
  }
}


