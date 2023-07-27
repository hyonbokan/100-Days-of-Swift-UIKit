//
//  ViewController.swift
//  Project25-GCD
//
//  Created by dnlab on 2023/07/27.
// WARNING! Bug 1: In the newer versions of XCode, be sure to select "Estimate Size - None" in the Size Inspertor
// Link to Bug 2: https://stackoverflow.com/questions/58563621/multipeer-connectivity-not-working-after-xcode-11-update

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    
    var images = [UIImage]()
    
//    var peerID: MCPeerID?
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
//    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showOperations))
        
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    

    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func showOperations() {
        let ac = UIAlertController(title: "Choose your operation", message: nil, preferredStyle: .actionSheet)
        //The importPicture method takes no parameters, but the UIAlertAction handler is expected to take a single UIAlertAction parameter.
        ac.addAction(UIAlertAction(title: "Add an image", style: .default) {
            [weak self] _ in
            self?.importPicture()
        })
        ac.addAction(UIAlertAction(title: "Send a message", style: .default, handler: sendMessage))
        //Challenge 3
        ac.addAction(UIAlertAction(title: "Show connected peers", style: .default, handler: showConnectedPeers))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func sendMessage(action: UIAlertAction) {
        let ac = UIAlertController(title: "Input message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "OK", style: .default) {
            [weak ac, weak self] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.sendAction(message: text)
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    func sendAction(message: String){
        guard let messageData = message.data(using: .utf8) else {
            print("Failed to convert message to data.")
            return
        }
        guard let mcSession = mcSession else { return }
        do {
            try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
            let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // Multipeer
        
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
//    func startHosting(action: UIAlertAction) {
//        guard let mcSession = mcSession else { return }
//        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
//        mcAdvertiserAssistant?.start()
//    }
    func startHosting(action: UIAlertAction) {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let ac = UIAlertController(title: "Project25", message: "'\(peerID.displayName)' wants to connect", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] _ in
            invitationHandler(true, self?.mcSession)
        }))
        ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
            invitationHandler(false, nil)
        }))
        present(ac, animated: true)
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        // Chanllenge 1: Must be on the main thread
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async{
                [weak self] in
                self?.showAlert(title: "Device connected", message: "\(peerID) is connected to your device")
            }
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Disconnected: \(peerID.displayName)")
            DispatchQueue.main.async{
                [weak self] in
                self?.showAlert(title: "Device disconnected", message: "\(peerID) disconnected from your device")
            }
        // Normally, .notConnected could be our default state, but in case, there are other possible states @unknown is used.
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // Pushing to the main thread
        DispatchQueue.main.async {
            [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
            if let message = String(data: data, encoding: .utf8) {
                let ac = UIAlertController(title: "Message Received", message: message, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
            
        }
    }
    
    func showConnectedPeers(action: UIAlertAction) {
        // Challenge 3 -
        guard let mcSession = mcSession else { return }
        let connectedPeers = mcSession.connectedPeers
        let peerIDs = connectedPeers.map { $0.displayName }
        showAlert(title: "Connected Peers", message:  "Peers: \(peerIDs.joined(separator: ", "))")
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

