ident_list: [..] string;

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
    EMPTYARGS :: 246;
    STRINGTYPE :: 245;
    INTTYPE :: 244;
    UINTTYPE :: 243;
    CHARTYPE :: 242;
    EQUALS :: 241;
    VARIABLE :: 240;
    NOTHING :: 1;
    UNKNOWN :: 0;
}
uType :: enum u8 {
    Char :: 242;
    uInt :: 243;
    Int :: 244;
    String :: 245;
}
Lexer :: struct 
{
    tokens: [..] Token; // resizable array of tokens
    source: string;
}
// doesnt remove spaces 
remove_ws :: (str:string) -> string 
{
    s := str;
    
    // different os's have different newlines (fuck you windows)
    if str.count > 1 {
        for 0..s.count - 1 {
            if it < s.count - 1 {
                if s[it] == #char "\t" { 
                    string_remove_by_index(*s,it);
                }
            }
        }
    }
    // more print debugging
    //print("%\n",s);
    return s;
}
// simple preprocessing
format_str :: (str: string,line:bool) -> []string 
{
        if line {
            // copy of str to preserve str incase we need to cross-reference 
            cs := remove_ws(str);
            parsed := split(cs," ");
            return parsed;
        }
        else {
            cs := remove_ws(str);
            #if OS == .WINDOWS {
            parsed := split(cs,"\r\n");
            }
            else {
            parsed := split(cs,"\n");
            }
            return parsed;
        }
}


// Function to help handle the default case,old method was getting too big
handle_default :: (str: string,line:int,tokens: [..] Token,it:int) -> Token {
                using TokenType;
                if str.count > 0 {
                    if is_digit(str[0]) {
                            return Token.{cast(u8) LIT,str,line};
                    }

                    else {
                        s:*string = *str;
                        // remove first char
                        s.data += 1;
                        s.count -= 1;
                        return smoltokenize(s.*,line);
                    }
            }
            else {
                return Token.{cast(u8) NOTHING,str,line};
            }
}
is_number_uint :: (str:string) -> bool {
    for 0..str.count - 1 {
        if is_digit(str[it]) {

        }
        else {
            return false;
        }
    }
    return true;
}
is_number :: (str:string) -> bool {
    for 0..str.count - 1 {
        if is_digit(str[it]) || str[it] == #char "-" {

        }
        else {
            return false;
        }
    }
    return true;
}
typecheck :: (type:Token,Value:Token) -> bool {
    checksout:bool;
    if type.type== {
        case 245; checksout = Value.expr[0] == #char "\"" && Value.expr[Value.expr.count - 1] == #char "\"" ;
        case 244; checksout = is_number(Value.expr);
        case 243; checksout = is_number_uint(Value.expr);
        case 242; checksout = Value.expr[0] == #char "'" && Value.expr[Value.expr.count - 1] == #char "'" && Value.expr.count == 3;
    }
    return checksout;
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
        else if toks[it].type == 245 || toks[it].type == 244 || toks[it].type == 243 || toks[it].type == 242 {
            error = !typecheck(toks[it],toks[it+3]);
            if error {
                print("Wrong type for variable % on line %, wanted %, given %\n\nCould not compile due to above errors\n",toks[it+1].expr,toks[it].pos,cast(uType) toks[it].type,toks[it+3].expr);
                // for some god damn reason it worked and then stopped working so now I have to add this
                exit(1);
            }
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
                case "()"; array_add(*tokens,Token.{cast(u8) EMPTYARGS,"",line});
                case "!!"; array_add(*tokens,Token.{cast(u8) MAIN_TAG,"",line});
                case "func"; 
                array_add(*tokens,Token.{cast(u8) FUNC,"",line});
                array_add(*tokens,Token.{cast(u8) IDENT,str[it + 1],line});
                array_add(*ident_list,str[it + 1]);
                it += 1;
                case "String"; 
                array_add(*tokens,Token.{cast(u8) STRINGTYPE,"",line});
                array_add(*tokens,Token.{cast(u8) IDENT,str[it + 1],line});
                array_add(*ident_list,str[it + 1]);
                it += 1;
                case "Int"; 
                array_add(*tokens,Token.{cast(u8) INTTYPE,"",line});
                array_add(*tokens,Token.{cast(u8) IDENT,str[it + 1],line});
                array_add(*ident_list,str[it + 1]);
                it += 1;
                case "uInt"; 
                array_add(*tokens,Token.{cast(u8) UINTTYPE,"",line});
                array_add(*tokens,Token.{cast(u8) IDENT,str[it + 1],line});
                array_add(*ident_list,str[it + 1]);
                it += 1;
                case "char"; 
                array_add(*tokens,Token.{cast(u8) CHARTYPE,"",line});
                array_add(*tokens,Token.{cast(u8) IDENT,str[it + 1],line});
                array_add(*ident_list,str[it + 1]);
                it += 1;
                case "="; 
                array_add(*tokens,Token.{cast(u8) EQUALS,"",line});
                array_add(*tokens,Token.{cast(u8) VARIABLE,str[it + 1],line});
                it += 1;
                case "";;
                case; array_add(*tokens,handle_default(str[it],line,tokens,it));
            }  
        }
        line += 1;
    }
    //print("%\n",tokens);

    toks_error_checked := lexer_error(tokens);
    print("Succesfully lexed the file\n");
    return toks_error_checked;
}
// Keep in sync with @tokenize
smoltokenize :: (tok:string,line:int) -> Token {
            using TokenType;
            if tok =={
                case "return"; return Token.{cast(u8) RET,"",line};
                case "{"; return Token.{cast(u8) LBRACK,"",line};
                case "}"; return Token.{cast(u8) RBRACK,"",line};
                case "("; return Token.{cast(u8) LPAREN,"",line};
                case ")"; return Token.{cast(u8) RPAREN,"",line};
                case "()"; return Token.{cast(u8) EMPTYARGS,"",line};
                case "!!"; return Token.{cast(u8) MAIN_TAG,"",line};
                case "func"; return Token.{cast(u8) FUNC,"",line};
                case "String"; return Token.{cast(u8) STRINGTYPE,"",line};
                case "Int"; return Token.{cast(u8) INTTYPE,"",line};
                case "uInt"; return Token.{cast(u8) UINTTYPE,"",line};
                case "char"; return Token.{cast(u8) CHARTYPE,"",line};
                case "="; return Token.{cast(u8) EQUALS,"",line};
                case ""; return Token.{cast(u8) NOTHING,"",line};
                case; return Token.{cast(u8) UNKNOWN,tok,line};
            }  
}
#import "String";
#import "Basic";
#import "stringextras";