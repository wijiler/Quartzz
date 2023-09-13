#import "String";
#import "Basic";
Token :: struct 
{
    type: u8;
    expr: string;
    pos: int;
}
TokenType :: enum u8 {
    RET :: 255;
    LIT :: 254;
    FUNC :: 253;
    MAIN_TAG :: 252;
    RBRACK :: 251;
    LBRACK :: 250;
    LPAREN :: 249;
    RPAREN :: 248;
    IDENT :: 247;
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
handle_default :: (str: string,line:int,tokens: [..] Token,it:int) -> Token {
                if str.count > 0 {
                    if is_digit(str[0]) {
                            return Token.{cast(u8) TokenType.LIT,str,line};
                    }
                    else if tokens[it - 1].type == cast(u8) TokenType.FUNC {
                        return Token.{cast(u8) TokenType.IDENT,str,line};
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
            // uncomment for extremely helpful debugging info
            // print("%\n",tokens);
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
        using TokenType;
        for 0..str.count - 1 {
            // switch on token
            if str[it] =={
                case "return";array_add(*tokens,Token.{cast(u8) RET,"",line});
                case "{"; array_add(*tokens,Token.{cast(u8) LBRACK,"",line});
                case "}"; array_add(*tokens,Token.{cast(u8) RBRACK,"",line});
                case "("; array_add(*tokens,Token.{cast(u8) LPAREN,"",line});
                case ")"; array_add(*tokens,Token.{cast(u8) RPAREN,"",line});
                case "!!"; array_add(*tokens,Token.{cast(u8) MAIN_TAG,"",line});
                case "func"; array_add(*tokens,Token.{cast(u8) FUNC,"",line});
                case; array_add(*tokens,handle_default(str[it],line,tokens,it));
            }  
        }
        line += 1;
    }
    toks_error_checked := lexer_error(tokens);
    print("Succesfully lexed the file\n");
    return toks_error_checked;
}

