//
//  token.h
//  quartzz
//
//  Created by Wijmac on 3/13/23.
//
#pragma once
#include<string>
using namespace std;
typedef enum  {
    // Types
    TYPE_NULL,
    TYPE_STRING, // [UINT_8;len]
    TYPE_INT,
    TYPE_UINT,
    TYPE_BOOL,
    TYPE_CHAR, // [UINT_8;1]
    TYPE_ARRAY_S, // [ *****
    TYPE_ARRAY_E, // ;*]
    // Keywords
    KEYWORD_FUNCTION,
    KEYWORD_TYPE,
    KEYWORD_STRUCT,
    KEYWORD_ENUM, // rust style enum
    KEYWORD_FOR,
    KEYWORD_WHILE,
    KEYWORD_BREAK,
    KEYWORD_CONTINUE,
    KEYWORD_RETURN,
    // Function tags
    TAG_MAIN, // @!
    TAG_ASYNC, // !#
    TAG_META,// !$
    // Logic
    LOGIC_IF,
    LOGIC_ELSE,
    LOGIC_TRUE, // 1
    LOGIC_FALSE, // 0
    LOGIC_SWITCH,
    LOGIC_AND,
    LOGIC_OR,
    LOGIC_GREATER,
    LOGIC_LESSER,
    LOGIC_NOT_EQUAL,
    LOGIC_EQUAL,
    LOGIC_LESSER_EQUAL,
    LOGIC_GREATER_EQUAL,
    //EOL
    SEMI,
    //Special
    IDENT,
    ARGS_S,
    ARGS_E,
    // Eval
    ADD,
    SUBTRACT,
    MULTIPLY,
    DIVIDE,
    EQUALS,
    E_PAREN_S,
    E_PAREN_E,
    MODULO,
    
}Tokentype;

variant<int,string,char> lits;
