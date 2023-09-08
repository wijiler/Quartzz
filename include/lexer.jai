#import "String";
Token :: struct 
{
    type: u8;
    expr: string;
    pos: int;
}
TokenType :: enum u8 {
    RET :: 255;
    LIT :: 254;
    NOTHING :: 1;
    UNKNOWN :: 0;
}
Lexer :: struct 
{
    tokens: [..] Token; // resizable array of tokens
    source: string;
}

// doesnt remove spaces 
remove_nl :: (str:string) -> string 
{
    s := str;
    // different os's have different newlines (fuck you windows)
    if str.count > 1 {
        if str[0] == #char "\r" || str[0] == #char "\n" {
                #if OS == .WINDOWS {
                    s.count -= 2;
                    s.data += 2;
                }
                #if OS == .LINUX {
                    s.count -= 1;
                    s.data += 1;
                }
                #if OS == .MACOS {
                    s.count -= 1;
                    s.data += 1;
                }
        }
    }
    return s;
}
format_str :: (str: string,line:bool) -> []string 
{
        if line {
        // copy of str to preserve str incase we need to cross-reference 
        cpstr := remove_nl(str);
        parsed := split(cpstr," ");
        return parsed;
        }
        else {
        cpstr := remove_nl(str);
        parsed := split(cpstr,";");
        return parsed;
        }
}


// Function to help handle the default case,old method was getting to big
handle_default :: (str: string,line:int) -> Token {
                if str.count > 0 {
                if is_digit(str[0]) {
                    //  tok: Token;
                    //  tok.type = cast(u8) TokenType.LIT;
                    //  tok.expr = str;
                    //  array_add(*tokens,tok);
                     return Token.{cast(u8) TokenType.LIT,str,line};
                }
                else {
                    return Token.{cast(u8) TokenType.UNKNOWN,str,line};
                }
            }
            else {
                return Token.{cast(u8) TokenType.NOTHING,str,line};
            }
}
lexer_error :: (tokens: [..] Token) -> [..] Token 
{
        toks := tokens;
        error: bool;
        for 0..toks.count - 1 {
            if toks[it].type == 1 {
                array_ordered_remove_by_index(*toks,it);
            }
            else if toks[it].type == 0 {
                error = true;
                print("Unknown Token found on line %:\n%\n",toks[it].pos,toks[it].expr);
            }
        }
        if error == true {
            print("could not continue compiling due to the errors above\n");
            exit(1);
        }
        return toks;
}
// Turn string into tokens
tokenize :: (src:string) -> [..] Token 
{
    tokens:[..] Token;
    line:int = 1;
    error:bool = false;
    srccp := format_str(src,false);
    for 0..srccp.count - 1 {
        // split each line on a space and then match since we are going line by line here
        str := format_str(srccp[it],true);
        for 0..str.count - 1 {
            // switch on token
            if str[it] =={
                case "return";
                    tok: Token;
                    tok.type = cast(u8) TokenType.RET;
                    tok.expr = "";
                    tok.pos = line;
                    array_add(*tokens,tok);
                case; 
                tok: Token;
                tok = handle_default(str[it],line);
                array_add(*tokens,tok);
            }
            line += 1;
        }
    }
    toks_error_checked := lexer_error(tokens);
    print("Succesfully lexed the file\n");
    return toks_error_checked;
}

