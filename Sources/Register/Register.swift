@attached(member, names: named(rawValue), named(init), arbitrary)
public macro BitRegister() = #externalMacro(module: "RegisterMacroImplementation", type: "BitRegisterMacro")

@attached(accessor, names: named(get), named(set))
public macro Bits(_ range: Range<Int>) = #externalMacro(module: "RegisterMacroImplementation", type: "BitsMacro")

@attached(accessor, names: named(get), named(set))
public macro Bits(_ bit: Int) = #externalMacro(module: "RegisterMacroImplementation", type: "BitsMacro")

@attached(accessor, names: named(get), named(set))
public macro Bits(_ range: ClosedRange<Int>) = #externalMacro(module: "RegisterMacroImplementation", type: "BitsMacro")

@attached(member, names: named(read), named(write), arbitrary)
public macro SystemRegister(_ name: StaticString) =
    #externalMacro(module: "RegisterMacroImplementation", type: "SystemRegisterMacro")
