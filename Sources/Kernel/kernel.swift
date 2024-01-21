@_silgen_name("kmain")
public func kmain() {
    initUART()

    print("Hello Swift!")

    while true { putchar(getchar()) }
}
