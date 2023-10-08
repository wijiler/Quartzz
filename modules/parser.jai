
LiteralExpr :: struct {
    value: string;
}
ReturnExpr :: struct {
    count:u64;
}

ftag :: enum {
    FT_ENTRY;
    FT_ASYNC;
    FT_META;
    FT_NONE;
}

FunctionExpr :: struct {
    type:ftag;
    symbol:string;
    count:u64;
}

VarExpr :: struct {
    name:string;
    immutable:bool;
}

Expression :: union { 
    Literal: LiteralExpr;
    Var: VarExpr;
    Return: ReturnExpr;
    Function: FunctionExpr; // function count
}
Node :: struct 
{
    Value: Expression;
    Children : [..] Node;
}

AST :: struct {
    Root:Node;
}


parse_node :: (tokens:[..] Token) -> [..] Node #expand
{
    nodearr:[..] Node;
    for 0..tokens.count - 1 {
        if tokens[it].type == {
            case 255; array_add(*nodearr,parse_return(tokens,it));
            case 254; array_add(*nodearr,parse_lit(tokens[it]));
            case 253; 
            node,skip := parse_function(tokens,it);
            array_add(*nodearr,node);
            it += cast(s64) skip;
            case 245;
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case 244; 
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case 243;
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case 242;
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case;;
        }
    }
    
    return nodearr;
}

parse :: (tokens:[..] Token) -> AST
{
    nodearr:[..] Node;
    for 0..tokens.count - 1 {
        if tokens[it].type == {
            case 255; array_add(*nodearr,parse_return(tokens,it));
            case 254; array_add(*nodearr,parse_lit(tokens[it]));
            case 253; 
            node,skip := parse_function(tokens,it);
            array_add(*nodearr,node);
            it += cast(s64) skip;
            case 245; 
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case 244; 
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case 243;
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case 242;
            node,skip := parse_var(tokens,it);
            array_add(*nodearr,node);
            it += skip;
            case;;
        }
    }
    print("Succesfully parsed % tokens\nnodearr:%\n",tokens.count,nodearr);
    ep:int = -1;
    for 0..nodearr.count - 1 {
        if nodearr[it].Value.Function.type == .FT_ENTRY {
            ep = it;
        }
    }
    if ep == -1 {
        print("No entrypoint for software");
        exit(1);
    }
    ast:AST = AST.{nodearr[ep]};
    return ast;
}

// "Growing trees?!    I thought this was computer science not botany class"
#import "lexer";
#import "File";
#import "Basic";
#import "parsefunctions";