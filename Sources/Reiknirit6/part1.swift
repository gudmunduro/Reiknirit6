import Common

func runPart1()
{
    guard let f: String = input("Sláðu inn fall f(x)"), let g: String = input("Sláðu inn g(x)") else {
        print("Annað fallið er ekki gilt")
        return
    }
    guard let tostr: String = input("Sláðu inn x fyrir efri mörk svæðis "), let fromstr: String = input("Sláðu inn x fyrir neðri mörk svæðis") else {
        print("Önnur talan er ekki gild")
        return
    }
    guard let from = Double(fromstr), let to = Double(tostr) else {
        print("Önnur talan er ekki gild")
        return
    }
    let integ1 = Integration(eq: f)
    let integ2 = Integration(eq: g)
    do {
        print("!1")
        let int1 = try integ1.fullIntegrate()
        print("!2")
        let int2 = try integ2.fullIntegrate()

        print("Flatarmálið milli f(x) og g(x) er :\((try integ1.findArea(int1, from: from, to: to)) - (try integ2.findArea(int2, from: from, to: to)))")
    } catch {
        print(error)
    }
}