//
//  ViewController.swift
//  Dall-E
//
//  Created by MaCanMichis on 3/26/23.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        
        Task {
            do {
                let image = try await APIService().fetchImageForPrompt("A cat meme")
                await MainActor.run{
                    image.image = image
                }
            } catch{
                print ("Error")
            }
        }
    }

    private func configureUI(){
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
         imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        
        
        
        ])
    }

}

