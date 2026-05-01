package ast

// basic types

Named_Type :: string // i32, bool
Pointer_Type :: struct {
	name: Named_Type,
} // ^i32

Type :: union {
	Named_Type,
	Pointer_Type,
}

// expressions

Identifier_Expr :: string // just something
Int_Literal_Expr :: i32 // 12 (questioning is i32 enough?)
Address_Of_Expr :: ^Expr // &something
Derefernece_Expr :: ^Expr // ptr^

Expr :: union {
	Identifier_Expr,
	Int_Literal_Expr,
	Address_Of_Expr,
	Derefernece_Expr,
}

// statements

Var_Decl :: struct {
	is_mut:   bool,
	name:     string,
	type_ann: Type,
	init:     Expr,
}

Return :: struct {
	obj: Expr,
}

If :: struct {
	condition: Expr,
	body:      [dynamic]Stmt,
}

Expr_Stmt :: struct {
	obj: Expr,
}

Stmt :: union {
	Var_Decl,
	Return,
	If,
	Expr_Stmt,
}

// top level declarations

Param_Pair :: struct {
	name: string,
	type: Type,
}

Function :: struct {
	name:        string,
	params:      [dynamic]Param_Pair,
	return_type: Type,
	body:        [dynamic]Stmt,
}

Struct :: struct {
	name:   string,
	fields: [dynamic]Param_Pair,
}

Decl :: union {
	Function,
	Struct,
}
