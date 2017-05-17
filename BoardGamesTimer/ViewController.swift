//
//  ViewController.swift
//  BoardGamesTimer
//
//  Created by Diego on 5/15/17.
//  Copyright © 2017 Diego. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var jugadoresStepper: UIStepper!
    @IBOutlet var jugadoresLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        jugadoresStepper.value = 6
        jugadoresStepperValueChanged(jugadoresStepper)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // por ahora vamos directo
        self.performSegue(withIdentifier: "toTimersSegue", sender: self)
    }
    
    @IBAction func jugadoresStepperValueChanged(_ sender: Any) {
        jugadoresLabel.text =  "\(Int(jugadoresStepper.value)) jugadores"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cvc = segue.destination as! TimersViewController
        cvc.jugadores = Int(jugadoresStepper.value)
    }

}

