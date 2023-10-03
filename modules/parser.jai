#import "lexer";
#import "File";
#import "Basic";
#import "parsefunctions";
LiteralExpr :: struct {
    value: string;
}
ReturnExpr :: struct {
    count:u64;
}

FunctionExpr :: struct {
    count:u64;
}

Expression :: union { 
    Variable: LiteralExpr;
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
            case;;
        }
    }
    print("Succesfully parsed % tokens\nnodearr:%\n",tokens.count,nodearr);
    ast:AST = AST.{nodearr[0]};
    
    return ast;
}

// "Growing trees?!    I thought this was computer science not botany class"