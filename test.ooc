Parent: class {
  field1, field2: Int
  
  init: func {
    field1 = 1
    field2 = 2
  }
}

Child: class extends Parent {
  field3 := 3
}

test := Child new()

printf("The value is %i", test field3)
