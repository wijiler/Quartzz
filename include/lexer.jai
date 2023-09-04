#import "String";
Token :: struct 
{
    type: u8;
    expr: string;
}
TokenType :: enum u8 {
    RET :: 255;
    LIT :: 254;
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

    for 0..str.count - 1 {
           // Characters are just 1 byte so we can just check
           if str[it] != 10 || str[it] != 9 || str[it] != 13 
           then append(*strcon,str[it]);
    }
    s := builder_to_string(*strcon);
    return s;
}
is_num :: (str:string) -> bool {
    for 0..str.count -1 {
        
    }
}
parse_string :: (str: string) -> []string 
{
        // copy of str to preserve str incase we need to cross-reference 
        cpstr := remove_whitespace(str);
        parsed := split(cpstr,";");
        return parsed;
}

// Turn string into tokens
tokenize :: (src:[] string) -> [..] Token {
    tokens:[..] Token;
    line:int = 0;
    
    for 0..src.count - 1 {
        // split each line on a space and then match since we are going line by line here
        str := split(src[it]," ");
        for 0..str.count - 1 {
            tok: Token;
            if str[it] =={
                case "return";
                    tok.type = cast(u8) TokenType.LIT;
                    tok.expr = "";
                    array_add(*tokens,tok);
                    free(*tok);
                #through;
                case; log_error("Lexing error on line %,unknown token:\n%",line,str[it]);
            }
        }
    }
    return tokens;
}

begin_descent :: (lex:Lexer) 
{
        src := parse_string(lex.source);

}
