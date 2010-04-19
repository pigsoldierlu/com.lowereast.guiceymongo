grammar GuiceyData;

options {
	language=Java;
	output=AST;
}

tokens {
	DATA='data';
	TYPE_MAP='map';
	TYPE_SET='set';
	TYPE_LIST='list';
	// primitive can be a user-defined Data type
	TYPE_PRIMITIVE='primitive';
	PROPERTY='property';
	OPTION='option';
	PAIR='pair';
	ENUM='enum';
}

@header {
package com.lowereast.guiceymongo.data.parser;
}
@lexer::header {
package com.lowereast.guiceymongo.data.parser;
}

start	:	entry+ EOF
	;

entry	:	data
	|	enumeration
	;

data	:	DATA type '{' data_entry* '}' -> ^(DATA type data_entry*)
	;

enumeration
	:	ENUM type '{}' -> ^(ENUM type)
	|	ENUM type '{' (value_type ',')* value_type '}' -> ^(ENUM type value_type+)
	;

data_entry
	:	entry
	|	option* property -> ^(property option*)
	;

option
	:	'[' ID ']' -> ^(OPTION ID)
	|	'[' ID '(' value ')]' -> ^(OPTION ID value)
//	|	'[' ID '(' pair ')]' -> ^(OPTION ID pair)
	|	'[' ID '(' (pair ',')* pair ')]' -> ^(OPTION ID pair+)
	;
	
pair
	:	key '=' value -> ^(PAIR key value)
	;
	
key
	:	ID
	;
value
	:	INT
	|	FLOAT
	|	STRING
	;

property 
	:	'map<' key_type ',' value_type '>' ID ';' -> ^(PROPERTY ID TYPE_MAP key_type value_type)
	|	'set<' type '>' ID ';' -> ^(PROPERTY ID TYPE_SET type)
	|	'list<' type '>' ID ';' -> ^( PROPERTY ID TYPE_LIST type)
	|	type 'data;' -> ^(PROPERTY 'data' TYPE_PRIMITIVE type)
	|	type ID ';' -> ^(PROPERTY ID TYPE_PRIMITIVE type)
	;

key_type
	: type
	;

value_type
	: type
	;

type
	:	ID
	|	TYPE
	;

TYPE	:	ID ('.' ID)+
	;

ID 	:	('a'..'z'|'A'..'Z') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
	;

WS 	:   ( ' '
	| '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

INT :	'0'..'9'+
    ;

FLOAT
    :   ('0'..'9')+ '.' ('0'..'9')* EXPONENT?
    |   '.' ('0'..'9')+ EXPONENT?
    |   ('0'..'9')+ EXPONENT
    ;

//COMMENT
//    :   '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;}
//    |   '/*' ( options {greedy=false;} : . )* '*/' {$channel=HIDDEN;}
//    ;

STRING
    :  '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\''
    ;

fragment
EXPONENT : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;