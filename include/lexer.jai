#import "String";
Token :: struct 
{
    type: u8;
    expr: string;
}

Lexer :: struct 
{
    tokens: [..] Token; // resizable array of tokens
    source: string;
}

peek :: (str: [..]string,index: int) -> string 
{
            assert((index < str.count) == true,"Lexer Tried to peek starting at non-existant index");
            return str[index + 1];
}
// doesnt remove spaces 
remove_whitespace :: (str:string) -> string 
{
    strcon:String_Builder;
    init_string_builder(*strcon);

    for 1..str.count - 1 {
           // Characters are just 1 byte so we can just check
           if str[it] != 10 || str[it] != 9 || str[it] != 13 
           then append(*strcon,str[it]);
    }
    s := builder_to_string(*strcon);
    return s;
}

parse_string :: (str: string) -> []string 
{
        // copy of str to preserve str incase we need to cross-reference 
        cpstr := remove_whitespace(str);
        parsed := split(cpstr,";");
        return parsed;
}

// Turn string into tokens
tokenize :: (src:[] string) {
        split := parse_string(line);
}

begin_descent :: (lex:Lexer) 
{
        src := parse_string(lex.source);
}
