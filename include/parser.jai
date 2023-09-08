#load "lexer.jai";

Node :: struct 
{
    Value: string;
    Args: string;
    Superior: int;
    Children : [..] Node;
}

AST :: struct {
    Root:Node;
}

grammar :: "defaultgram.qzg";

search_ast :: ()
{

}

parse :: (tokens:[..] Token) 
{

}