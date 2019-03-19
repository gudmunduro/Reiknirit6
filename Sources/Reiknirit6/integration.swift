import Common

fileprivate struct EPart {
    var valueBefore: Int
    var x: String
    var pow: Int
}

public class Integration {

    private let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let eq: String

    public init(eq: String)
    {
        self.eq = eq
    }

    private func splitEq() -> [String]
    {
        return eq.components(separatedBy: ["+", "-"])
    }

    private func findAllPMOperators() -> [String]
    {
        var result: [String] = []
        for c in eq {
            switch c {
                case "+": result.append("+")
                case "-": result.append("-")
                default: break
            }
        }
        return result
    }

    private func splitSinglePart(_ e: String) -> EPart
    {
        var part = 0
        var result: [String] = []
        for c in e {
            if result.length < part + 1 {
                result.append("")
            }
            switch part {
                case _ where numbers.contains(String(c)):
                    result[part] += c
                case "x":
                    part++
                    result[part] = "x"
                    part++
                case "^":
                    part++
                default: break
            }
        }

        let ePart = EPart(valueBefore: Int(result[0])!, x: result[1], pow: Int(result[2])!)

        return ePart
    }

    private func integrate(_ e: String) -> String
    {
        var newE = e
        switch e {
            case _ where e.contains("sin"):
                break
            case _ where e.contains("cos"):
                break
            case _ where e.contains("x"):
                if !newE.components(separatedBy: "x")[0].contains(where: numbers.contains) {
                    newE = "1" + newE
                }
                if newE.contains("^") {
                    newE += "^1"
                }

                var epart = splitSinglePart(newE)

                epart.pow += 1
                epart.valueBefore /= epart.pow
            default:
                return ""
        }
    }

    public func run() -> String
    {
        var result = ""

        let se = splitEq()
        let op = findAllPMOperators()
        
        for (e, o) in zip(se, op) {
            result += integrate(e)
            result += o
        }
    }

}