package tokens

Eof :: struct {}
Colon :: struct {} // :
Arrow :: struct {} // ->
Caret :: struct {} // ^
Ampersand :: struct {} // &
Assign :: struct {} // =

Open_Paren :: struct {} // (
Close_Paren :: struct {} // )
Open_Bracket :: struct {} // {
Close_Bracket :: struct {} // }


Val :: struct {}
Mut :: struct {}
Fn :: struct {}
Return :: struct {}
Identifier :: string

Int_Literal :: i32 // TODO: consider

Token :: union {
	Eof,
	Colon,
	Arrow,
	Caret,
	Ampersand,
	Assign,
	Open_Paren,
	Close_Paren,
	Open_Bracket,
	Close_Bracket,
	Val,
	Mut,
	Fn,
	Return,
	Identifier,
	Int_Literal,
}
