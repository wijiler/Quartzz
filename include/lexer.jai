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
    //ascii number character codes from 48 - 57
    if str[0] == 48 || str[0] == 49 || str[0] == 50 || str[0] == 51 || str[0] == 52 || str[0] == 53 || str[0] == 54 || str[0] == 55 || str[0] == 56 || str[0] == 57 then return true; else return false;
}
parse_string :: (str: string) -> []string 
{
        // copy of str to preserve str incase we need to cross-reference 
        cpstr := remove_whitespace(str);
        parsed := split(cpstr,";");
        return parsed;
}
// Function to help handle the default case,old method was getting to big
handle_default :: (str: string,tokens: [..] Token,line:int) -> bool {
                if str.count > 1 {
                if is_num(str) {
                     print("number\n");
                     tok: Token;
                     tok.type = cast(u8) TokenType.LIT;
                     tok.expr = str;
                     array_add(*tokens,tok);
                     return false;
                 }
                else {
                    log_error("Lexing error on line %,unknown token:\n%",line,str);
                    return true;
                }
                line += 1;
            }
            else {
                return false;
            }
}
// Turn string into tokens
tokenize :: (src:[] string) -> [..] Token {
    tokens:[..] Token;
    line:int = 1;
    error:bool = false;
    for 0..src.count - 1 {
        // split each line on a space and then match since we are going line by line here
        str := split(src[it]," ");
        for 0..str.count - 1 {
            // switch on token
            if str[it] =={
                case "return";
                    tok: Token;
                    tok.type = cast(u8) TokenType.RET;
                    tok.expr = "";
                    array_add(*tokens,tok);
                case; error = handle_default(str[it],tokens,line);
            }
        }
    }
    if error == true {
        print("due to the errors above the rest of compilation has not been completed\n");
        exit(1);
    }
    return tokens;
}

begin_descent :: (lex:Lexer) -> [..] Token
{
        src := parse_string(lex.source);
        return tokenize(src);
}
