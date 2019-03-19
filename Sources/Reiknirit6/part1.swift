import Common

func runPart1()
{
    guard let inp: String = input("Jafna") else {
        print("Jafna er ekki gild")
        return
    }
    let integration = Integration(eq: inp)
    let res = integration.run()

    print(res)
}