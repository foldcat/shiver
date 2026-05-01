package tokens

// operators
Eof :: struct {}
Colon :: struct {} // :
Arrow :: struct {} // ->
Caret :: struct {} // ^
Ampersand :: struct {} // &
Assign :: struct {} // =

// brackets
Open_Paren :: struct {} // (
Close_Paren :: struct {} // )
Open_Bracket :: struct {} // {
Close_Bracket :: struct {} // }


// identifiers
Val :: struct {}
Mut :: struct {}
Fn :: struct {}
Return :: struct {}
If :: struct {}
Struct :: struct {}
Comma :: struct {}
Identifier :: string

// numebers
Int_Literal :: i32 // TODO: consider

Token :: union {
	// operators
	Eof,
	Colon,
	Arrow,
	Caret,
	Ampersand,
	Assign,

	// brackets
	Open_Paren,
	Close_Paren,
	Open_Bracket,
	Close_Bracket,

	// identifiers
	Val,
	Mut,
	Fn,
	Return,
	If,
	Struct,
	Comma,
	Identifier,

	// numbers
	Int_Literal,
}
