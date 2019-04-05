import Common

func runPart1()
{
    guard let inp: String = input("Jafna") else {
        print("Jafna er ekki gild")
        return
    }
    let integration = Integration(eq: inp)
    do {
        let res = try integration.run()

        print(res)
    } catch {
        print(error)
    }
}