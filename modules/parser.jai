#import "lexer";
#import "File";
#import "Basic";
#import "parsefunctions";
LiteralExpr :: struct {
    value: string;
}
ReturnExpr :: struct {
    args: LiteralExpr;
}

Expression :: union { 
    Variable: LiteralExpr;
    Return: ReturnExpr;
}
Node :: struct 
{
    Value: Expression;
    Children : [..] Node;
}

AST :: struct {
    Root:Node;
}

parse :: (tokens:[..] Token) -> AST
{
    exprarr:[..] Expression;
    for 0..tokens.count - 1 {
        if tokens[it].type == {
            case 255; array_add(*exprarr,parse_return(tokens,it));
            case 254; array_add(*exprarr,parse_lit(tokens[it],"variable"));
            case;;
        }
    }
    print("Succesfully parsed % tokens",tokens.count);
    root:Node;
    root.Value = exprarr[0];
    ast:AST = AST.{root};
    
    return ast;
}