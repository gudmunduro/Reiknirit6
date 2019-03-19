import Foundation
import Common

while true {
    let menu = Menu(title: "Reiknirit - Verkefni 5", options: [
        (text: "Partur 1", option: runPart1),
        (text: "Exit", option: {
            exit(0)
        })
    ])

    menu.show()
}