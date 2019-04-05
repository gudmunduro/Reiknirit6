import Foundation
import Common

while true {
    let menu = Menu(title: "Reiknirit - Verkefni 5", options: [
        (text: "Liður 1", option: runPart1),
        (text: "Liður 2", option: runPart2),
        (text: "Liður 3", option: runPart3),
        (text: "Exit", option: {
            exit(0)
        })
    ])

    menu.show()
}